/**
 * Ciudades donde opera SISI (R10.1).
 *
 * Centro y radio de servicio: PROVISIONALES. Las zonas exactas del lanzamiento están
 * pendientes (docs/pendientes.md). Si se define un polígono, se carga en
 * cities.service_area y tiene prioridad sobre el radio (ADR-0019).
 */
export interface CitySeed {
  slug: string;
  name: string;
  countryCode: string;
  timezone: string;
  /** Centro de referencia (WGS84). */
  center: { lat: number; lng: number };
  /** Radio de servicio en km desde el centro. */
  serviceRadiusKm: string;
}

export const CITIES: CitySeed[] = [
  {
    slug: 'santa-cruz',
    name: 'Santa Cruz de la Sierra',
    countryCode: 'BO',
    timezone: 'America/La_Paz',
    // Plaza 24 de Septiembre. Provisional, pendiente de validación en el plan de negocio.
    center: { lat: -17.7834, lng: -63.1821 },
    // Provisional, pendiente de validación en el plan de negocio.
    serviceRadiusKm: '15.00',
  },
];
