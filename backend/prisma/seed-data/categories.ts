/**
 * Categorías iniciales (doc 00 §5). Lista cerrada administrada por la empresa (R2.1).
 *
 * ⚠️ RANGOS DE PRECIO: provisional, pendiente de validación en el plan de negocio.
 * Montos en Bs con 2 decimales, siempre como texto (se guardan como Decimal, nunca float).
 *
 * El seed solo CREA lo que falta: si una categoría ya existe (por slug) no se toca,
 * para no pisar cambios hechos después desde el panel admin. Para cambiar valores de
 * categorías ya creadas, usar los endpoints /admin/categories.
 */
export interface CategorySeed {
  slug: string;
  name: string;
  description: string;
  /** provisional, pendiente de validación en el plan de negocio */
  priceMinBs: string;
  /** provisional, pendiente de validación en el plan de negocio */
  priceMaxBs: string;
  commissionPct: string;
  /** Ciudades (slug) donde se activa al crearla. */
  cities: string[];
}

export const CATEGORIES: CategorySeed[] = [
  {
    slug: 'plomeria',
    name: 'Plomería',
    description: 'Fugas, destapes, grifería',
    priceMinBs: '80.00', // provisional, pendiente de validación en el plan de negocio
    priceMaxBs: '300.00', // provisional, pendiente de validación en el plan de negocio
    commissionPct: '13.00',
    cities: ['santa-cruz'],
  },
  {
    slug: 'electricidad',
    name: 'Electricidad',
    description: 'Tomacorrientes, cortocircuitos, luminarias',
    priceMinBs: '80.00', // provisional, pendiente de validación en el plan de negocio
    priceMaxBs: '300.00', // provisional, pendiente de validación en el plan de negocio
    commissionPct: '13.00',
    cities: ['santa-cruz'],
  },
  {
    slug: 'limpieza',
    name: 'Limpieza',
    description: 'Casas, oficinas, post-obra, vidrios',
    priceMinBs: '120.00', // provisional, pendiente de validación en el plan de negocio
    priceMaxBs: '350.00', // provisional, pendiente de validación en el plan de negocio
    commissionPct: '13.00',
    cities: ['santa-cruz'],
  },
  {
    slug: 'cuidado-hogar',
    name: 'Cuidado del hogar',
    description: 'Jardinería, pintura, armado de muebles',
    priceMinBs: '80.00', // provisional, pendiente de validación en el plan de negocio
    priceMaxBs: '400.00', // provisional, pendiente de validación en el plan de negocio
    commissionPct: '13.00',
    cities: ['santa-cruz'],
  },
  {
    slug: 'eventos',
    name: 'Eventos',
    description: 'Garzón, ayudante de cocina, bartender',
    priceMinBs: '100.00', // provisional, pendiente de validación en el plan de negocio
    priceMaxBs: '300.00', // provisional, pendiente de validación en el plan de negocio
    commissionPct: '13.00',
    cities: ['santa-cruz'],
  },
  {
    slug: 'mudanzas-carga',
    name: 'Mudanzas y carga',
    description: 'Cargadores, ayudantes',
    priceMinBs: '150.00', // provisional, pendiente de validación en el plan de negocio
    priceMaxBs: '600.00', // provisional, pendiente de validación en el plan de negocio
    commissionPct: '13.00',
    cities: ['santa-cruz'],
  },
];
