/** Un anillo de búsqueda (R4.2): hasta `maxKm` y como máximo `limit` trabajadores nuevos. */
export interface RingConfig {
  maxKm: number;
  limit: number;
}

/** Parámetros del matching (ADR-0025). Todo configurable: los tests usan milisegundos. */
export interface MatchingConfig {
  rings: RingConfig[];
  /** Espera por anillo antes de ampliar (R4.3). */
  ringWaitMs: number;
  /** Con esta cantidad de ofertas activas no se amplía el anillo. */
  enoughOffers: number;
  /** Con ofertas sin elegir tras el último anillo, la solicitud expira después de esto. */
  offersGraceMs: number;
  /** Sin ubicación en este tiempo, el trabajador no cuenta como disponible (ADR-0024). */
  staleLocationMs: number;
  /** Tiempo mínimo de búsqueda desde que se publica, aunque los anillos estén vacíos. */
  minSearchMs: number;
  /** Mientras dura el mínimo, cada cuánto se vuelve a buscar en el último anillo. */
  rescanMs: number;
}

/**
 * Lee MATCHING_RINGS ("2:5,5:10,10:10" = km:límite). Los radios deben crecer y los
 * límites ser positivos.
 */
export function parseRings(value: string): RingConfig[] {
  const rings = value.split(',').map((part) => {
    const [km, limit] = part.trim().split(':').map(Number);
    if (!km || !limit || km <= 0 || !Number.isInteger(limit) || limit <= 0) {
      throw new Error(`MATCHING_RINGS inválido: "${part}" (formato km:límite, p. ej. 2:5)`);
    }
    return { maxKm: km, limit };
  });
  if (rings.length === 0) throw new Error('MATCHING_RINGS necesita al menos un anillo');
  for (let i = 1; i < rings.length; i++) {
    if ((rings[i]?.maxKm ?? 0) <= (rings[i - 1]?.maxKm ?? 0)) {
      throw new Error('MATCHING_RINGS: cada anillo debe llegar más lejos que el anterior');
    }
  }
  return rings;
}
