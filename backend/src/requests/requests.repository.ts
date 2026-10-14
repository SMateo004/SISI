import { Injectable, NotFoundException } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type { LatLng, ServiceArea } from './location';

/**
 * SQL directo para lo geográfico (doc 02 §2, ADR-0019): Prisma no puede escribir ni leer
 * la columna geography, así que el alta y la lectura de coordenadas van por $queryRaw.
 */
@Injectable()
export class RequestsRepository {
  constructor(private readonly prisma: PrismaService) {}

  async serviceArea(cityId: string, point: LatLng): Promise<ServiceArea> {
    const rows = await this.prisma.$queryRaw<
      { lat: number | null; lng: number | null; radius: number | null; inside: boolean | null }[]
    >`
      SELECT ST_Y(center::geometry) AS lat,
             ST_X(center::geometry) AS lng,
             service_radius_km::float8 AS radius,
             CASE WHEN service_area IS NULL THEN NULL
                  ELSE ST_Covers(service_area, ST_SetSRID(ST_MakePoint(${point.lng}, ${point.lat}), 4326)::geography)
             END AS inside
      FROM cities WHERE id = ${cityId}::uuid`;
    const row = rows[0];
    if (!row) throw new NotFoundException('La ciudad no existe.');
    return {
      center: row.lat === null || row.lng === null ? null : { lat: row.lat, lng: row.lng },
      radiusKm: row.radius,
      insidePolygon: row.inside,
    };
  }

  /** Crea el borrador y su primer evento en una transacción. Devuelve el id. */
  async insertDraft(input: {
    employerId: string;
    categoryId: string;
    cityId: string;
    description: string;
    point: LatLng;
    address: string;
    proposedPriceBs: Prisma.Decimal;
  }): Promise<string> {
    return this.prisma.$transaction(async (tx) => {
      const [row] = await tx.$queryRaw<{ id: string }[]>`
        INSERT INTO service_requests
          (employer_id, category_id, city_id, description, geog, address, proposed_price_bs, status, updated_at)
        VALUES (
          ${input.employerId}::uuid, ${input.categoryId}::uuid, ${input.cityId}::uuid, ${input.description},
          ST_SetSRID(ST_MakePoint(${input.point.lng}, ${input.point.lat}), 4326)::geography,
          ${input.address}, ${input.proposedPriceBs.toFixed(2)}::numeric, 'borrador', now()
        )
        RETURNING id`;
      if (!row) throw new Error('No se pudo crear la solicitud');
      await tx.serviceRequestEvent.create({
        data: {
          requestId: row.id,
          event: 'CREATE',
          toStatus: 'borrador',
          actorId: input.employerId,
        },
      });
      return row.id;
    });
  }

  /** Coordenadas de varias solicitudes. */
  async locations(ids: readonly string[]): Promise<Map<string, LatLng>> {
    if (ids.length === 0) return new Map();
    const rows = await this.prisma.$queryRaw<{ id: string; lat: number; lng: number }[]>`
      SELECT id, ST_Y(geog::geometry) AS lat, ST_X(geog::geometry) AS lng
      FROM service_requests WHERE id = ANY(${[...ids]}::uuid[])`;
    return new Map(rows.map((r) => [r.id, { lat: r.lat, lng: r.lng }]));
  }
}
