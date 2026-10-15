import { distanceKm, type LatLng } from '../requests/location';
import { decideModeSwitch, type ModeSwitchDenial } from '../workers/mode-switch.rules';
import type { WorkerStatus } from '../workers/worker-status.machine';

export interface PersistedPoint extends LatLng {
  /** Cuándo se persistió en Postgres (ms Unix). */
  at: number;
}

/**
 * ¿Se persiste esta ubicación en Postgres? (ADR-0024). Redis GEO recibe todas; Postgres
 * solo si pasó `persistMs` desde la última o el trabajador se movió más de `persistM`.
 */
export function shouldPersist(
  last: PersistedPoint | null,
  point: LatLng,
  now: number,
  limits: { persistMs: number; persistM: number },
): boolean {
  if (!last) return true;
  if (now - last.at >= limits.persistMs) return true;
  return distanceKm(last, point) * 1000 >= limits.persistM;
}

export type AvailabilityDenial =
  { code: 'WORKER_MODE_REQUIRED'; message: string } | ModeSwitchDenial;

/** ¿Puede activar "Disponible"? Exige modo worker y perfil aprobado (ADR-0024). */
export function canBeAvailable(input: {
  activeMode: 'employer' | 'worker';
  status: WorkerStatus | null;
}): { allowed: true } | ({ allowed: false } & AvailabilityDenial) {
  // El estado se revisa primero: a quien no está aprobado se le dice por qué.
  const decision = decideModeSwitch('worker', input.status);
  if (!decision.allowed) return decision;
  if (input.activeMode !== 'worker') {
    return {
      allowed: false,
      code: 'WORKER_MODE_REQUIRED',
      message: 'Cambia a modo trabajador para recibir solicitudes.',
    };
  }
  return { allowed: true };
}
