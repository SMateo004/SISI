import { ApiProperty } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsString, MaxLength, MinLength } from 'class-validator';

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
  @ApiProperty({ example: '45000', description: 'Valor vigente, como texto' })
  value!: string;
  @ApiProperty({ example: '45000', description: 'Valor por defecto (variable de entorno)' })
  defaultValue!: string;
  @ApiProperty({ description: 'Cambiado desde el panel' }) overridden!: boolean;
  @ApiProperty({ type: String, nullable: true, format: 'date-time' }) updatedAt!: string | null;
}

export class SetSettingDto {
  @ApiProperty({
    example: '45000',
    description: 'Número en la unidad del parámetro (ms, días, Bs…) o los anillos, como texto',
  })
  @IsString({ message: 'El valor va como texto.' })
  @MaxLength(100)
  value!: string;

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
