import { ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsOptional, IsString, Length } from 'class-validator';

export class UpdateMeDto {
  @ApiPropertyOptional({ example: 'María Pérez', minLength: 2, maxLength: 60 })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.trim().replace(/\s+/g, ' ') : value,
  )
  @IsString({ message: 'El nombre debe ser texto.' })
  @Length(2, 60, { message: 'El nombre debe tener entre 2 y 60 caracteres.' })
  name?: string;
}
