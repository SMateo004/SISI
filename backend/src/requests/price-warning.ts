import { ApiProperty } from '@nestjs/swagger';
import { type EffectiveCategory, formatBs, toBs } from '../categories/effective-category';
import type { Prisma } from '../generated/prisma/client';

export class RequestWarningDto {
  @ApiProperty({ example: 'PRICE_BELOW_REFERENCE' })
  code!: 'PRICE_BELOW_REFERENCE';

  @ApiProperty({
    example:
      'Tu precio está por debajo del mínimo de referencia para Plomería (Bs 80,00). Puedes publicar igual, pero podrías recibir menos ofertas.',
  })
  message!: string;

  @ApiProperty({ example: '80.00' })
  referenceMinBs!: string;
}

/**
 * R3.2: un precio bajo el mínimo de referencia se permite, pero se advierte.
 * El mínimo es el efectivo de la ciudad (CategoryResolver).
 */
export function priceWarnings(
  price: Prisma.Decimal,
  category: Pick<EffectiveCategory, 'name' | 'priceMinBs'>,
): RequestWarningDto[] {
  if (!price.lessThan(category.priceMinBs)) return [];
  return [
    {
      code: 'PRICE_BELOW_REFERENCE',
      message: `Tu precio está por debajo del mínimo de referencia para ${category.name} (${formatBs(category.priceMinBs)}). Puedes publicar igual, pero podrías recibir menos ofertas.`,
      referenceMinBs: toBs(category.priceMinBs),
    },
  ];
}
