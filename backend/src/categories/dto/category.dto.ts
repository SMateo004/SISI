import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsOptional,
  IsString,
  Length,
  Matches,
  MaxLength,
  ValidateIf,
} from 'class-validator';
import { MONEY_PATTERN, type EffectiveCategory, toBs } from '../effective-category';

const PCT_PATTERN = /^\d{1,3}(\.\d{1,2})?$/;
const MONEY_MESSAGE = 'El monto debe ser un número en Bs con hasta 2 decimales (ej. 80.00).';
const PCT_MESSAGE = 'La comisión debe ser un porcentaje con hasta 2 decimales (ej. 13.00).';

export class CategoryDto {
  @ApiProperty({ example: 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e' })
  id!: string;

  @ApiProperty({ example: 'plomeria', description: 'Identificador estable (ícono en la app)' })
  slug!: string;

  @ApiProperty({ example: 'Plomería' })
  name!: string;

  @ApiProperty({ example: 'Fugas, destapes, grifería', nullable: true, type: String })
  description!: string | null;

  @ApiProperty({ example: '80.00', description: 'Mínimo de referencia en Bs para tu ciudad' })
  priceMinBs!: string;

  @ApiProperty({ example: '300.00', description: 'Máximo de referencia en Bs para tu ciudad' })
  priceMaxBs!: string;
}

export const toCategoryDto = (c: EffectiveCategory): CategoryDto => ({
  id: c.id,
  slug: c.slug,
  name: c.name,
  description: c.description,
  priceMinBs: toBs(c.priceMinBs),
  priceMaxBs: toBs(c.priceMaxBs),
});

export class UpdateCategoryDto {
  @ApiPropertyOptional({ example: 'Plomería' })
  @IsOptional()
  @IsString()
  @Length(2, 60, { message: 'El nombre debe tener entre 2 y 60 caracteres.' })
  name?: string;

  @ApiPropertyOptional({ example: 'Fugas, destapes, grifería', nullable: true, type: String })
  @IsOptional()
  @ValidateIf((_, v) => v !== null)
  @IsString()
  @MaxLength(200, { message: 'La descripción admite hasta 200 caracteres.' })
  description?: string | null;

  @ApiPropertyOptional({ example: '80.00' })
  @IsOptional()
  @Matches(MONEY_PATTERN, { message: MONEY_MESSAGE })
  priceMinBs?: string;

  @ApiPropertyOptional({ example: '300.00' })
  @IsOptional()
  @Matches(MONEY_PATTERN, { message: MONEY_MESSAGE })
  priceMaxBs?: string;

  @ApiPropertyOptional({ example: '13.00' })
  @IsOptional()
  @Matches(PCT_PATTERN, { message: PCT_MESSAGE })
  commissionPct?: string;

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean({ message: 'active debe ser verdadero o falso.' })
  active?: boolean;
}

export class UpsertCategoryCityDto {
  @ApiProperty({ example: true, description: 'Disponible en la ciudad' })
  @IsBoolean({ message: 'active debe ser verdadero o falso.' })
  active!: boolean;

  @ApiPropertyOptional({
    example: '90.00',
    nullable: true,
    type: String,
    description: 'null = usa el valor base',
  })
  @IsOptional()
  @ValidateIf((_, v) => v !== null)
  @Matches(MONEY_PATTERN, { message: MONEY_MESSAGE })
  priceMinBs?: string | null;

  @ApiPropertyOptional({ example: null, nullable: true, type: String })
  @IsOptional()
  @ValidateIf((_, v) => v !== null)
  @Matches(MONEY_PATTERN, { message: MONEY_MESSAGE })
  priceMaxBs?: string | null;

  @ApiPropertyOptional({ example: null, nullable: true, type: String })
  @IsOptional()
  @ValidateIf((_, v) => v !== null)
  @Matches(PCT_PATTERN, { message: PCT_MESSAGE })
  commissionPct?: string | null;
}

export class AdminCategoryCityDto {
  @ApiProperty() cityId!: string;
  @ApiProperty({ example: 'santa-cruz' }) citySlug!: string;
  @ApiProperty() active!: boolean;
  @ApiProperty({ nullable: true, type: String, example: null }) priceMinBs!: string | null;
  @ApiProperty({ nullable: true, type: String, example: null }) priceMaxBs!: string | null;
  @ApiProperty({ nullable: true, type: String, example: null }) commissionPct!: string | null;
  @ApiProperty({ example: '80.00', description: 'Mínimo efectivo en la ciudad' })
  effectivePriceMinBs!: string;
  @ApiProperty({ example: '300.00' }) effectivePriceMaxBs!: string;
  @ApiProperty({ example: '13.00' }) effectiveCommissionPct!: string;
}

export class AdminCategoryDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 'plomeria' }) slug!: string;
  @ApiProperty({ example: 'Plomería' }) name!: string;
  @ApiProperty({ nullable: true, type: String }) description!: string | null;
  @ApiProperty({ example: '80.00' }) priceMinBs!: string;
  @ApiProperty({ example: '300.00' }) priceMaxBs!: string;
  @ApiProperty({ example: '13.00' }) commissionPct!: string;
  @ApiProperty() active!: boolean;
  @ApiProperty({ type: [AdminCategoryCityDto] }) cities!: AdminCategoryCityDto[];
}
