import { HttpStatus } from '@nestjs/common';
import { decimal, MONEY_PATTERN, toBs } from '../categories/effective-category';
import { ApiError } from '../common/errors/api-error';
import type { Exclusion } from '../matching/candidates';

export type TransportMode = 'a_pie' | 'bicicleta' | 'moto' | 'auto' | 'transporte_publico';

/**
 * Lee ETA_SPEEDS_KMH ("a_pie:4.5,moto:25,..."). Debe traer todos los medios de transporte.
 */
export function parseSpeeds(value: string): Record<TransportMode, number> {
  const modes: TransportMode[] = ['a_pie', 'bicicleta', 'moto', 'auto', 'transporte_publico'];
  const map = new Map(
    value.split(',').map((part) => {
      const [mode, speed] = part.trim().split(':');
      return [mode, Number(speed)] as const;
    }),
  );
  return Object.fromEntries(
    modes.map((mode) => {
      const speed = map.get(mode);
      if (!speed || speed <= 0)
        throw new Error(`ETA_SPEEDS_KMH: falta una velocidad válida para ${mode}`);
      return [mode, speed];
    }),
  ) as Record<TransportMode, number>;
}

/**
 * Tiempo estimado de llegada en minutos (R5.3): distancia en línea recta × factor de
 * recorrido, a la velocidad del medio de transporte. Mínimo 1 minuto.
 */
export function estimateEtaMin(
  distanceM: number,
  transport: TransportMode | null,
  speeds: Record<TransportMode, number>,
  routeFactor: number,
): number {
  const speedKmh = speeds[transport ?? 'a_pie'];
  const minutes = ((distanceM / 1000) * routeFactor * 60) / speedKmh;
  return Math.max(Math.ceil(minutes), 1);
}

/**
 * Monto de la oferta (R5.2): aceptar usa el precio propuesto; la contraoferta debe ser
 * > 0, con hasta 2 decimales, y no pasar de `maxFactor` × el máximo de referencia de la
 * categoría en la ciudad (propuesta: 3×, docs/pendientes.md).
 */
export function offerAmount(input: {
  type: 'accept' | 'counter';
  amountBs: string | undefined;
  proposedPriceBs: string;
  priceMaxBs: string;
  maxFactor: number;
}): string {
  if (input.type === 'accept') return input.proposedPriceBs;
  const raw = input.amountBs?.trim().replace(',', '.') ?? '';
  if (!MONEY_PATTERN.test(raw) || decimal(raw).lte(0)) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'OFFER_AMOUNT_INVALID',
      'Indica un monto mayor a 0, con hasta 2 decimales.',
    );
  }
  const cap = decimal(input.priceMaxBs).mul(input.maxFactor);
  if (decimal(raw).gt(cap)) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'OFFER_AMOUNT_TOO_HIGH',
      `La contraoferta no puede pasar de Bs ${toBs(cap).replace('.', ',')}.`,
      { maxBs: toBs(cap) },
    );
  }
  return toBs(decimal(raw));
}

/** Tope de la contraoferta para mostrar en la app. */
export const counterCap = (priceMaxBs: string, maxFactor: number): string =>
  toBs(decimal(priceMaxBs).mul(maxFactor));

/** "María Pérez Gómez" → "María P." (R5.3: el empleador ve un nombre corto). */
export function shortName(name: string | null, fallback = 'Trabajador'): string {
  const parts = (name ?? '').trim().split(/\s+/).filter(Boolean);
  const [first, second] = parts;
  if (!first) return fallback;
  return second ? `${first} ${second.charAt(0).toUpperCase()}.` : first;
}

/** Mensaje en español cuando un notificado ya no puede ofertar. */
export function notEligibleMessage(reason: Exclusion): string {
  switch (reason) {
    case 'no_modo_trabajador':
      return 'Cambia a modo trabajador para ofertar.';
    case 'no_disponible':
    case 'ubicacion_vencida':
      return 'Activa "Disponible" y comparte tu ubicación para ofertar.';
    case 'ocupado':
      return 'Tienes un trabajo en curso: termínalo antes de ofertar en otro.';
    case 'fuera_de_su_radio':
      return 'Esta solicitud quedó fuera de tu radio de trabajo.';
    case 'tope_de_deuda':
      return 'Tienes comisiones pendientes: págalas para seguir recibiendo solicitudes.';
    default:
      return 'Ya no puedes ofertar en esta solicitud.';
  }
}
