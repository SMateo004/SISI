import type { RingConfig } from './matching.config';

/**
 * Lo que la consulta PostGIS devuelve de cada trabajador cercano (ADR-0025). La consulta
 * ya filtra por ciudad, categoría, disponible y radio del anillo usando el índice GiST;
 * `selectCandidates` vuelve a aplicar todos los criterios de R4.1 para que sean explícitos
 * y se puedan probar sin base de datos.
 */
export interface CandidateRow {
  workerId: string;
  status: string;
  activeMode: 'employer' | 'worker';
  available: boolean;
  locatedAt: Date | null;
  hasCategory: boolean;
  maxRadiusKm: number | null;
  distanceM: number;
  ratingAvg: number;
  alreadyNotified: boolean;
}

export interface SelectionContext {
  ring: RingConfig;
  employerId: string;
  now: number;
  staleLocationMs: number;
  /** Hook de tope de deuda (R7.5): hoy todos elegibles, se conecta en la Fase 5. */
  debtEligible: (workerId: string) => boolean;
}

export type Exclusion =
  | 'no_aprobado'
  | 'no_modo_trabajador'
  | 'no_disponible'
  | 'ubicacion_vencida'
  | 'sin_categoria'
  | 'fuera_de_su_radio'
  | 'fuera_del_anillo'
  | 'es_el_empleador'
  | 'ya_notificado'
  | 'tope_de_deuda';

/** Por qué un trabajador no es candidato (null = es candidato). Orden de R4.1. */
export function exclusionOf(row: CandidateRow, ctx: SelectionContext): Exclusion | null {
  if (row.status !== 'aprobado') return 'no_aprobado';
  if (row.activeMode !== 'worker') return 'no_modo_trabajador';
  if (!row.available) return 'no_disponible';
  if (!row.locatedAt || ctx.now - row.locatedAt.getTime() > ctx.staleLocationMs) {
    return 'ubicacion_vencida';
  }
  if (!row.hasCategory) return 'sin_categoria';
  if (row.maxRadiusKm === null || row.distanceM > row.maxRadiusKm * 1000) {
    return 'fuera_de_su_radio';
  }
  if (row.distanceM > ctx.ring.maxKm * 1000) return 'fuera_del_anillo';
  // Una misma cuenta tiene los dos modos: nunca se le ofrece su propia solicitud.
  if (row.workerId === ctx.employerId) return 'es_el_empleador';
  if (row.alreadyNotified) return 'ya_notificado';
  if (!ctx.debtEligible(row.workerId)) return 'tope_de_deuda';
  return null;
}

/**
 * Candidatos del anillo (R4.1, R4.4): los elegibles, ordenados por distancia y, como
 * desempate, por calificación (mayor primero), hasta el límite del anillo.
 */
export function selectCandidates(rows: CandidateRow[], ctx: SelectionContext): CandidateRow[] {
  return rows
    .filter((row) => exclusionOf(row, ctx) === null)
    .sort(
      (a, b) =>
        a.distanceM - b.distanceM ||
        b.ratingAvg - a.ratingAvg ||
        a.workerId.localeCompare(b.workerId),
    )
    .slice(0, ctx.ring.limit);
}
