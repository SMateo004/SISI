import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsBoolean, IsIn, IsOptional, IsString, MaxLength, MinLength } from 'class-validator';

export const TERM_KINDS = ['word', 'regex'] as const;
export const TERM_CATEGORIES = [
  'sexual',
  'drogas',
  'armas',
  'ilegal',
  'inmoral',
  'venta_productos',
] as const;

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

export class CreateModerationTermDto {
  @ApiProperty({ example: 'cocain*', description: 'Palabra/frase (con * de prefijo) o regex' })
  @IsString()
  @MaxLength(100, { message: 'El término admite hasta 100 caracteres.' })
  term!: string;

  @ApiProperty({ enum: TERM_KINDS, example: 'word' })
  @IsIn(TERM_KINDS, { message: 'kind debe ser word o regex.' })
  kind!: (typeof TERM_KINDS)[number];

  @ApiProperty({ enum: TERM_CATEGORIES, example: 'drogas' })
  @IsIn(TERM_CATEGORIES, { message: 'Categoría de prohibición no válida (R9.1).' })
  category!: (typeof TERM_CATEGORIES)[number];

  @ApiPropertyOptional({ example: 'Agregado por reporte del 15/10' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  note?: string;

  @ApiPropertyOptional({
    example: 'Pedido del equipo de operaciones',
    description: 'Motivo (queda en la auditoría)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  reason?: string;
}

export class UpdateModerationTermDto {
  @ApiPropertyOptional({ enum: TERM_CATEGORIES })
  @IsOptional()
  @IsIn(TERM_CATEGORIES, { message: 'Categoría de prohibición no válida (R9.1).' })
  category?: (typeof TERM_CATEGORIES)[number];

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  active?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(200)
  note?: string;

  @ApiPropertyOptional({
    example: 'Pedido del equipo de operaciones',
    description: 'Motivo (queda en la auditoría)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  reason?: string;
}

export class ModerationTermDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 'cocain*' }) term!: string;
  @ApiProperty({ enum: TERM_KINDS }) kind!: string;
  @ApiProperty({ enum: TERM_CATEGORIES }) category!: string;
  @ApiProperty() active!: boolean;
  @ApiProperty({ nullable: true, type: String }) note!: string | null;
}

export class TestModerationDto {
  @ApiProperty({ example: 'Necesito plomero y de paso me consigues marihuana' })
  @IsString()
  @MinLength(1, { message: 'Pega un texto para probar.' })
  @MaxLength(2000)
  @Transform(trim)
  text!: string;
}

export class ModerationMatchDto {
  @ApiProperty({ format: 'uuid' }) termId!: string;
  @ApiProperty() term!: string;
  @ApiProperty({ enum: TERM_KINDS }) kind!: string;
  @ApiProperty({ enum: TERM_CATEGORIES }) category!: string;
}

export class ModerationTestResultDto {
  @ApiProperty({ description: 'Con este texto, la solicitud o el mensaje quedaría retenido' })
  held!: boolean;
  @ApiProperty({ type: ModerationMatchDto, isArray: true }) matches!: ModerationMatchDto[];
  @ApiProperty({ description: 'Un regex no terminó a tiempo (se retendría por seguridad)' })
  timedOut!: boolean;
}
