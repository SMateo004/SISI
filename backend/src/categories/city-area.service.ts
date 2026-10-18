import { HttpStatus, Injectable } from '@nestjs/common';
import type { AuditHook } from '../audit/admin-audit.service';
import { ApiError } from '../common/errors/api-error';
import { PrismaService } from '../prisma/prisma.service';
import { isInsideServiceArea, type LatLng } from '../requests/location';
import { RequestsRepository } from '../requests/requests.repository';

/** Polígono GeoJSON (un anillo exterior, sin huecos), [lng, lat] como en GeoJSON. */
export interface GeoJsonPolygon {
  type: 'Polygon';
  coordinates: [number, number][][];
}

export interface CityArea {
  cityId: string;
  center: LatLng | null;
  radiusKm: number | null;
  polygon: GeoJsonPolygon | null;
}

/** Bolivia, con margen: un polígono fuera de esto es casi seguro lat/lng invertidos. */
const BOLIVIA = { minLat: -23.5, maxLat: -9.5, minLng: -69.8, maxLng: -57.3 };

const invalid = (message: string) =>
  new ApiError(HttpStatus.BAD_REQUEST, 'SERVICE_AREA_INVALID', message);

/**
 * Zona de servicio de una ciudad (ADR-0019, ADR-0052): polígono GeoJSON o, si no hay, radio desde
 * el centro. El panel la edita; los cambios quedan auditados y valen para las solicitudes nuevas.
 */
@Injectable()
export class CityAreaService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly requests: RequestsRepository,
  ) {}

  async get(cityId: string): Promise<CityArea> {
    const rows = await this.prisma.$queryRaw<
      { lat: number | null; lng: number | null; radius: number | null; polygon: string | null }[]
    >`
      SELECT ST_Y(center::geometry) AS lat, ST_X(center::geometry) AS lng,
             service_radius_km::float8 AS radius,
             ST_AsGeoJSON(service_area::geometry, 6) AS polygon
      FROM cities WHERE id = ${cityId}::uuid`;
    const row = rows[0];
    if (!row) throw new ApiError(HttpStatus.NOT_FOUND, 'CITY_NOT_FOUND', 'La ciudad no existe.');
    return {
      cityId,
      center: row.lat === null || row.lng === null ? null : { lat: row.lat, lng: row.lng },
      radiusKm: row.radius,
      polygon: row.polygon ? (JSON.parse(row.polygon) as GeoJsonPolygon) : null,
    };
  }

  /** Validación de forma antes de PostGIS: mensajes claros para quien pega el GeoJSON. */
  static checkPolygon(value: unknown): GeoJsonPolygon {
    const p = value as Partial<GeoJsonPolygon> | null;
    if (p?.type !== 'Polygon' || !Array.isArray(p.coordinates)) {
      throw invalid('Pega un GeoJSON de tipo Polygon ({"type":"Polygon","coordinates":[...]}).');
    }
    if (p.coordinates.length !== 1) {
      throw invalid('Usa un solo contorno, sin huecos.');
    }
    const ring = p.coordinates[0] ?? [];
    if (ring.length < 4)
      throw invalid('El contorno necesita al menos 3 puntos y cerrar en el primero.');
    for (const pos of ring) {
      const [lng, lat] = Array.isArray(pos) ? pos : [];
      if (typeof lng !== 'number' || typeof lat !== 'number') {
        throw invalid('Cada punto es [longitud, latitud] en números.');
      }
      if (
        lat < BOLIVIA.minLat ||
        lat > BOLIVIA.maxLat ||
        lng < BOLIVIA.minLng ||
        lng > BOLIVIA.maxLng
      ) {
        throw invalid(
          `El punto [${String(lng)}, ${String(lat)}] cae fuera de Bolivia. GeoJSON va como [longitud, latitud].`,
        );
      }
    }
    const first = ring[0];
    const last = ring[ring.length - 1];
    if (first?.[0] !== last?.[0] || first?.[1] !== last?.[1]) {
      throw invalid('El contorno debe cerrar: el último punto igual al primero.');
    }
    return { type: 'Polygon', coordinates: [ring] };
  }

  async set(
    cityId: string,
    input: { polygon: unknown; radiusKm?: number },
    audit: AuditHook,
    reason: string,
  ): Promise<CityArea> {
    const before = await this.get(cityId);
    const polygon = input.polygon === null ? null : CityAreaService.checkPolygon(input.polygon);
    if (polygon) {
      const [check] = await this.prisma.$queryRaw<
        { valid: boolean; reason: string; covers: boolean | null }[]
      >`
        WITH g AS (SELECT ST_SetSRID(ST_GeomFromGeoJSON(${JSON.stringify(polygon)}), 4326) AS geom)
        SELECT ST_IsValid(geom) AS valid, ST_IsValidReason(geom) AS reason,
               (SELECT ST_Covers(geom::geography, center) FROM cities WHERE id = ${cityId}::uuid) AS covers
        FROM g`;
      if (!check?.valid)
        throw invalid(`El polígono no es válido: ${check?.reason ?? 'forma inválida'}.`);
      if (check.covers === false)
        throw invalid('El centro de la ciudad tiene que quedar dentro de la zona.');
    }
    const radius = input.radiusKm ?? before.radiusKm;
    await this.prisma.$transaction(async (tx) => {
      if (polygon) {
        await tx.$executeRaw`
          UPDATE cities
          SET service_area = ST_SetSRID(ST_GeomFromGeoJSON(${JSON.stringify(polygon)}), 4326)::geography,
              service_radius_km = ${radius}::numeric
          WHERE id = ${cityId}::uuid`;
      } else {
        await tx.$executeRaw`
          UPDATE cities SET service_area = NULL, service_radius_km = ${radius}::numeric
          WHERE id = ${cityId}::uuid`;
      }
      await audit.record(tx, {
        action: 'catalog.city_area_set',
        targetType: 'city',
        targetId: cityId,
        cityId,
        before: { polygon: before.polygon, radiusKm: before.radiusKm },
        after: { polygon, radiusKm: radius },
        reason,
      });
    });
    return this.get(cityId);
  }

  /** "Probar un punto": la misma regla que usa una solicitud nueva. */
  async test(
    cityId: string,
    point: LatLng,
  ): Promise<{ inside: boolean; by: 'polygon' | 'radius' | 'none' }> {
    const area = await this.requests.serviceArea(cityId, point);
    const by =
      area.insidePolygon !== null
        ? 'polygon'
        : area.center && area.radiusKm !== null
          ? 'radius'
          : 'none';
    return { inside: isInsideServiceArea(point, area), by };
  }
}
