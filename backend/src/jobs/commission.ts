import { Prisma } from '../generated/prisma/client';

type Decimal = Prisma.Decimal;

/**
 * Comisión de un trabajo (R6.3, ADR-0030): precio final × porcentaje / 100, redondeada a
 * 2 decimales con HALF_UP (0,005 sube). Decimal en todo el cálculo: nunca number.
 */
export function commissionOf(finalPriceBs: Decimal, commissionPct: Decimal): Decimal {
  return finalPriceBs.mul(commissionPct).div(100).toDecimalPlaces(2, Prisma.Decimal.ROUND_HALF_UP);
}

/** Lo que recibe el trabajador (R8.3): precio final − comisión. */
export function netOf(finalPriceBs: Decimal, commissionBs: Decimal): Decimal {
  return finalPriceBs.sub(commissionBs);
}
