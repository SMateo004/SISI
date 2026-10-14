import { Prisma } from '../generated/prisma/client';

type Decimal = Prisma.Decimal;

export interface BaseCategory {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  priceMinBs: Decimal;
  priceMaxBs: Decimal;
  commissionPct: Decimal;
  active: boolean;
}

export interface CityOverride {
  active: boolean;
  priceMinBs: Decimal | null;
  priceMaxBs: Decimal | null;
  commissionPct: Decimal | null;
}

/** Categoría con los valores que rigen en una ciudad (R2.2, R10.1). */
export interface EffectiveCategory {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  cityId: string;
  priceMinBs: Decimal;
  priceMaxBs: Decimal;
  commissionPct: Decimal;
  /** Activa globalmente Y habilitada en la ciudad. */
  active: boolean;
}

/**
 * Combina la categoría base con el override de la ciudad. Sin fila de ciudad la categoría
 * no está activa allí. Los campos null del override heredan el valor base.
 */
export function effectiveCategory(
  base: BaseCategory,
  cityId: string,
  override: CityOverride | null,
): EffectiveCategory {
  return {
    id: base.id,
    slug: base.slug,
    name: base.name,
    description: base.description,
    cityId,
    priceMinBs: override?.priceMinBs ?? base.priceMinBs,
    priceMaxBs: override?.priceMaxBs ?? base.priceMaxBs,
    commissionPct: override?.commissionPct ?? base.commissionPct,
    active: base.active && (override?.active ?? false),
  };
}

/** Monto Decimal con 2 decimales como texto ("80.00"): así viaja en la API. */
export const toBs = (value: Decimal): string => value.toFixed(2);

/** Texto "Bs 80,00" para mensajes al usuario (coma decimal, como se escribe en Bolivia). */
export const formatBs = (value: Decimal): string => `Bs ${value.toFixed(2).replace('.', ',')}`;

/** Valida montos que llegan como texto: hasta 8 enteros y 2 decimales, nunca float. */
export const MONEY_PATTERN = /^\d{1,8}(\.\d{1,2})?$/;

export const decimal = (value: string): Decimal => new Prisma.Decimal(value);
