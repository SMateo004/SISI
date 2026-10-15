import type { MatchingConfig } from './matching.config';

/** Qué hacer al terminar un anillo. */
export type NextStep =
  { kind: 'ring'; ring: number; delayMs: number } | { kind: 'close'; delayMs: number };

/**
 * Paso siguiente al anillo `ring` (R4.2, R4.3, ADR-0025):
 * - Si avisó a alguien, espera `ringWaitMs` antes de ampliar (o de cerrar, si era el último).
 * - Si no encontró a nadie nuevo, amplía de inmediato: esperar sin haber avisado a nadie
 *   solo retrasa al empleador (decisión registrada en docs/pendientes.md).
 * - Cerrar nunca corta antes de tiempo el plazo del último aviso enviado.
 */
export function nextStep(input: {
  ring: number;
  notifiedNow: number;
  now: number;
  lastNotifiedAt: number | null;
  config: Pick<MatchingConfig, 'rings' | 'ringWaitMs'>;
}): NextStep {
  const { ring, notifiedNow, now, lastNotifiedAt, config } = input;
  if (ring < config.rings.length) {
    return { kind: 'ring', ring: ring + 1, delayMs: notifiedNow > 0 ? config.ringWaitMs : 0 };
  }
  return { kind: 'close', delayMs: closeDelay(now, lastNotifiedAt, config.ringWaitMs) };
}

/** Lo que falta del plazo del último aviso (0 si nadie fue avisado o ya pasó). */
export function closeDelay(now: number, lastNotifiedAt: number | null, ringWaitMs: number): number {
  if (lastNotifiedAt === null) return 0;
  return Math.max(lastNotifiedAt + ringWaitMs - now, 0);
}

/** ¿Se amplía al anillo `ring`? No, si ya hay ofertas suficientes (R4.3). */
export function shouldExpand(ring: number, activeOffers: number, enoughOffers: number): boolean {
  return ring === 1 || activeOffers < enoughOffers;
}

/**
 * Al cerrar la búsqueda (R4.5): sin ofertas, expira ya. Con ofertas, el empleador tiene
 * `offersGraceMs` para elegir; si no elige, expira y se cierran las ofertas (propuesta en
 * docs/pendientes.md).
 */
export function closeDecision(
  activeOffers: number,
  now: number,
  offersGraceMs: number,
): { expireNow: true } | { expireNow: false; expiresAt: number } {
  if (activeOffers === 0) return { expireNow: true };
  return { expireNow: false, expiresAt: now + offersGraceMs };
}
