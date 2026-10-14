import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsInt,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  IsUUID,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { MONEY_PATTERN } from '../../categories/effective-category';
import { RequestWarningDto } from '../price-warning';
import { REQUEST_STATUSES, type RequestStatus } from '../request-status.machine';

export class CreateRequestDto {
  @ApiProperty({ example: 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e' })
  @IsUUID('all', { message: 'Elige una categoría.' })
  categoryId!: string;

  @ApiProperty({
    example: 'Tengo una fuga debajo del lavaplatos de la cocina, gotea constantemente.',
    description: 'Entre 20 y 1000 caracteres (configurable)',
  })
  @IsString({ message: 'Describe el trabajo.' })
  @MaxLength(5000, { message: 'La descripción es demasiado larga.' })
  description!: string;

  @ApiProperty({ example: -17.7834 })
  @IsLatitude({ message: 'La ubicación no es válida.' })
  latitude!: number;

  @ApiProperty({ example: -63.1821 })
  @IsLongitude({ message: 'La ubicación no es válida.' })
  longitude!: number;

  @ApiProperty({
    example: 'Calle Junín 150, entre Ayacucho y Sucre',
    description: 'Dirección en texto',
  })
  @IsString({ message: 'Escribe la dirección.' })
  @MaxLength(200, { message: 'La dirección admite hasta 200 caracteres.' })
  address!: string;

  @ApiProperty({
    example: '150.00',
    description: 'Precio propuesto en Bs (incluye el traslado, R3.5)',
  })
  @Matches(MONEY_PATTERN, { message: 'El precio debe ser un monto en Bs con hasta 2 decimales.' })
  proposedPriceBs!: string;
}

export class RequestCategoryDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 'plomeria' }) slug!: string;
  @ApiProperty({ example: 'Plomería' }) name!: string;
}

export class RequestPhotoDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 0 }) position!: number;
  @ApiProperty({ description: 'URL temporal (1 h)' }) url!: string;
}

export class RequestDto {
  @ApiProperty() id!: string;

  @ApiProperty({ enum: REQUEST_STATUSES, example: 'buscando' })
  status!: RequestStatus;

  @ApiPropertyOptional({
    nullable: true,
    type: String,
    example: 'Estamos revisando tu solicitud. Te avisaremos cuando se publique.',
    description: 'Mensaje para el empleador según el estado (neutral si está retenida)',
  })
  statusMessage!: string | null;

  @ApiProperty({ type: RequestCategoryDto }) category!: RequestCategoryDto;
  @ApiProperty() cityId!: string;
  @ApiProperty() description!: string;
  @ApiProperty({ example: -17.7834 }) latitude!: number;
  @ApiProperty({ example: -63.1821 }) longitude!: number;
  @ApiProperty() address!: string;
  @ApiProperty({ example: '150.00' }) proposedPriceBs!: string;
  @ApiProperty({ type: [RequestPhotoDto] }) photos!: RequestPhotoDto[];
  @ApiProperty() createdAt!: string;
  @ApiPropertyOptional({ nullable: true, type: String }) publishedAt!: string | null;
  @ApiPropertyOptional({ nullable: true, type: String }) cancelledAt!: string | null;
}

export class CreatedRequestDto {
  @ApiProperty({ type: RequestDto }) request!: RequestDto;
  @ApiProperty({ type: [RequestWarningDto] }) warnings!: RequestWarningDto[];
}

export class PublishResultDto extends CreatedRequestDto {
  @ApiProperty({ description: 'Quedó retenida para revisión (R3.3)' })
  held!: boolean;

  @ApiProperty({ example: '¡Listo! Estamos buscando trabajadores cerca de ti.' })
  message!: string;
}

export class RequestPageDto {
  @ApiProperty({ type: [RequestDto] }) items!: RequestDto[];
  @ApiPropertyOptional({
    nullable: true,
    type: String,
    description: 'Cursor para la siguiente página',
  })
  nextCursor!: string | null;
}

export class ListRequestsQuery {
  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID('all', { message: 'Cursor inválido.' })
  cursor?: string;

  @ApiPropertyOptional({ default: 20, maximum: 50 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;
}

export class RejectRequestDto {
  @ApiProperty({ example: 'Ofrece venta de productos, no un servicio.' })
  @IsString()
  @MaxLength(300)
  reason!: string;
}

export class AdminHeldRequestDto extends RequestDto {
  @ApiProperty({ description: 'Términos que coincidieron (solo para el admin)' })
  matches!: unknown;

  @ApiProperty() employerId!: string;
}
