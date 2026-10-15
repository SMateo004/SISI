/**
 * Feature flags iniciales (R10.2). Solo se crean si faltan: después se cambian desde el
 * admin (PUT /admin/feature-flags/:key) y el seed no los pisa.
 */
export const FEATURE_FLAGS: {
  key: string;
  citySlug: string | null;
  enabled: boolean;
  description: string;
}[] = [
  {
    key: 'matching.enabled',
    citySlug: 'santa-cruz',
    enabled: true,
    description:
      'Matching por anillos (ADR-0025). Apagado, las solicitudes quedan en buscando y el matching se retoma al encenderlo.',
  },
];
