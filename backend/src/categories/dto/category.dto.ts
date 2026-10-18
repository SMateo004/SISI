import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsOptional,
  IsString,
  Length,
  Matches,
  IsUUID,
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

  @ApiPropertyOptional({
    example: ['certificado_electricista'],
    type: String,
    isArray: true,
    description: 'Requisitos extra de verificación (claves en minúsculas, R2.2)',
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @Matches(/^[a-z0-9_]{2,40}$/, {
    each: true,
    message: 'Cada requisito es una clave en minúsculas (ej. certificado_electricista).',
  })
  extraRequirements?: string[];
}

/** Categoría nueva (R2.2). Se crea en las ciudades indicadas (activas). */
export class CreateCategoryDto {
  @ApiProperty({ example: 'jardineria', description: 'Identificador estable: no cambia después' })
  @Matches(/^[a-z][a-z0-9-]{1,39}$/, {
    message: 'El slug va en minúsculas, sin espacios (ej. jardineria).',
  })
  slug!: string;

  @ApiProperty({ example: 'Jardinería' })
  @IsString()
  @Length(2, 60, { message: 'El nombre debe tener entre 2 y 60 caracteres.' })
  name!: string;

  @ApiPropertyOptional({ example: 'Poda, césped y riego', nullable: true, type: String })
  @IsOptional()
  @ValidateIf((_, v) => v !== null)
  @IsString()
  @MaxLength(200, { message: 'La descripción admite hasta 200 caracteres.' })
  description?: string | null;

  @ApiProperty({ example: '80.00' })
  @Matches(MONEY_PATTERN, { message: MONEY_MESSAGE })
  priceMinBs!: string;

  @ApiProperty({ example: '300.00' })
  @Matches(MONEY_PATTERN, { message: MONEY_MESSAGE })
  priceMaxBs!: string;

  @ApiPropertyOptional({ example: '13.00', description: 'Por defecto 13 % (R2.2)' })
  @IsOptional()
  @Matches(PCT_PATTERN, { message: PCT_MESSAGE })
  commissionPct?: string;

  @ApiPropertyOptional({
    example: ['certificado_electricista'],
    type: String,
    isArray: true,
    description: 'Requisitos extra de verificación (claves en minúsculas, R2.2)',
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @Matches(/^[a-z0-9_]{2,40}$/, {
    each: true,
    message: 'Cada requisito es una clave en minúsculas (ej. certificado_electricista).',
  })
  extraRequirements?: string[];

  @ApiPropertyOptional({ type: String, isArray: true, description: 'Ciudades donde queda activa' })
  @IsOptional()
  @IsArray()
  @IsUUID('all', { each: true, message: 'Una ciudad no es válida.' })
  cityIds?: string[];
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
  @ApiProperty({ type: String, isArray: true }) extraRequirements!: string[];
  @ApiProperty({ type: [AdminCategoryCityDto] }) cities!: AdminCategoryCityDto[];
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Aviso al cambiar la comisión: solo afecta a los trabajos asignados desde ahora',
  })
  notice!: string | null;
}

export class AdminCityDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ example: 'santa-cruz' }) slug!: string;
  @ApiProperty({ example: 'Santa Cruz de la Sierra' }) name!: string;
  @ApiProperty({ example: 'America/La_Paz' }) timezone!: string;
  @ApiProperty() active!: boolean;
}
