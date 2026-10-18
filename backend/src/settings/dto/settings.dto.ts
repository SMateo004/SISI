import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsDefined, IsString, MaxLength, MinLength } from 'class-validator';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

export class SettingDto {
  @ApiProperty({ example: 'MATCHING_RING_WAIT_MS' }) key!: string;
  @ApiProperty({ enum: ['matching', 'ofertas', 'trabajos', 'cobros'] }) group!: string;
  @ApiProperty({ example: 'Espera por anillo' }) label!: string;
  @ApiProperty() help!: string;
  @ApiProperty({ enum: ['int', 'decimal', 'rings'] }) kind!: string;
  @ApiProperty({ enum: ['ms', 'días', 'hora', 'Bs', 'ofertas', 'veces', 'anillos'] }) unit!: string;
  @ApiProperty({ type: Number, nullable: true }) min!: number | null;
  @ApiProperty({ type: Number, nullable: true }) max!: number | null;
  @ApiProperty({ oneOf: [{ type: 'number' }, { type: 'string' }], description: 'Valor vigente' })
  value!: number | string;
  @ApiProperty({
    oneOf: [{ type: 'number' }, { type: 'string' }],
    description: 'Valor por defecto (variable de entorno)',
  })
  defaultValue!: number | string;
  @ApiProperty({ description: 'Cambiado desde el panel' }) overridden!: boolean;
  @ApiProperty({ type: String, nullable: true, format: 'date-time' }) updatedAt!: string | null;
}

export class SetSettingDto {
  @ApiProperty({
    oneOf: [{ type: 'number' }, { type: 'string' }],
    example: 45000,
    description: 'Número en la unidad del parámetro (ms, días, Bs…) o texto de anillos',
  })
  @IsDefined({ message: 'Falta el valor.' })
  value!: number | string;

  @ApiProperty({ example: 'Más trabajadores en la zona norte: se acorta la espera.' })
  @IsString({ message: 'Escribe el motivo.' })
  @MinLength(5, { message: 'Escribe el motivo (al menos 5 letras).' })
  @MaxLength(300)
  @Transform(trim)
  reason!: string;
}

export class ResetSettingDto {
  @ApiProperty({ example: 'Volver al valor de la propuesta.' })
  @IsString({ message: 'Escribe el motivo.' })
  @MinLength(5, { message: 'Escribe el motivo (al menos 5 letras).' })
  @MaxLength(300)
  @Transform(trim)
  reason!: string;
}
