import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';

export interface LatLng {
  lat: number;
  lng: number;
}

const EARTH_RADIUS_KM = 6371.0088;

/** Distancia en km sobre la esfera (haversine). Suficiente para radios urbanos. */
export function distanceKm(a: LatLng, b: LatLng): number {
  const rad = (deg: number): number => (deg * Math.PI) / 180;
  const dLat = rad(b.lat - a.lat);
  const dLng = rad(b.lng - a.lng);
  const h =
    Math.sin(dLat / 2) ** 2 + Math.cos(rad(a.lat)) * Math.cos(rad(b.lat)) * Math.sin(dLng / 2) ** 2;
  return 2 * EARTH_RADIUS_KM * Math.asin(Math.min(1, Math.sqrt(h)));
}

/** Coordenadas válidas (WGS84), finitas y no (0, 0). */
export function assertValidCoordinates(point: LatLng): void {
  const ok =
    Number.isFinite(point.lat) &&
    Number.isFinite(point.lng) &&
    point.lat >= -90 &&
    point.lat <= 90 &&
    point.lng >= -180 &&
    point.lng <= 180 &&
    !(point.lat === 0 && point.lng === 0);
  if (!ok) {
    throw new ApiError(HttpStatus.BAD_REQUEST, 'LOCATION_INVALID', 'La ubicación no es válida.');
  }
}

export interface ServiceArea {
  center: LatLng | null;
  radiusKm: number | null;
  /** Si la ciudad tiene polígono, el resultado de ST_Covers (calculado en PostGIS). */
  insidePolygon: boolean | null;
}

/**
 * ¿El punto está en la zona de servicio de la ciudad? (ADR-0019, propuesta).
 * Con polígono manda el polígono; si no, el radio desde el centro. Sin ninguno de los
 * dos la ciudad no está configurada y no se aceptan solicitudes.
 */
export function isInsideServiceArea(point: LatLng, area: ServiceArea): boolean {
  if (area.insidePolygon !== null) return area.insidePolygon;
  if (!area.center || area.radiusKm === null) return false;
  return distanceKm(point, area.center) <= area.radiusKm;
}

export const outsideCity = (): ApiError =>
  new ApiError(
    HttpStatus.BAD_REQUEST,
    'LOCATION_OUTSIDE_CITY',
    'Por ahora SISI solo atiende dentro de tu ciudad. Elige una ubicación dentro de la zona de servicio.',
  );
