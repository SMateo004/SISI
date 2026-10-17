import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateOfferDto {
  @ApiProperty({
    enum: ['accept', 'counter'],
    description: 'accept = acepta el precio propuesto; counter = contraoferta (R5.2)',
  })
  @IsIn(['accept', 'counter'], { message: 'El tipo de oferta no es válido.' })
  type!: 'accept' | 'counter';

  @ApiPropertyOptional({ example: '180.00', description: 'Obligatorio en una contraoferta' })
  @IsOptional()
  @IsString({ message: 'El monto no es válido.' })
  @MaxLength(12, { message: 'El monto no es válido.' })
  amountBs?: string;
}

export class OfferWorkerDto {
  @ApiProperty({ example: 'María P.' }) shortName!: string;
  @ApiProperty({ example: '4.80' }) ratingAvg!: string;
  @ApiProperty({ example: 25 }) ratingCount!: number;
}

/** Oferta como la ve el empleador (R5.3): sin teléfono ni nombre completo. */
export class EmployerOfferDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: ['accept', 'counter'] }) type!: 'accept' | 'counter';
  @ApiProperty({ example: '180.00' }) amountBs!: string;
  @ApiProperty({ example: 12, description: 'Minutos estimados de llegada' }) etaMin!: number;
  @ApiProperty({ example: 850 }) distanceM!: number;
  @ApiProperty({ description: 'Sube cada vez que el trabajador reemplaza su oferta' })
  revision!: number;
  @ApiProperty({ type: OfferWorkerDto }) worker!: OfferWorkerDto;
  @ApiProperty({ type: String, format: 'date-time' }) updatedAt!: string;
}

/** Oferta propia del trabajador. */
export class MyOfferDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: ['accept', 'counter'] }) type!: 'accept' | 'counter';
  @ApiProperty({ example: '180.00' }) amountBs!: string;
  @ApiProperty() etaMin!: number;
  @ApiProperty({ enum: ['activa', 'aceptada', 'cerrada', 'retirada'] }) status!:
    'activa' | 'aceptada' | 'cerrada' | 'retirada';
  @ApiProperty() revision!: number;
  @ApiProperty({ type: String, format: 'date-time' }) updatedAt!: string;
}

export class IncomingPhotoDto {
  @ApiProperty() id!: string;
  @ApiProperty() position!: number;
  @ApiProperty({ description: 'URL temporal firmada (solo para notificados)' }) url!: string;
}

export class PriceRangeDto {
  @ApiProperty({ example: '80.00' }) minBs!: string;
  @ApiProperty({ example: '300.00' }) maxBs!: string;
}

/**
 * Solicitud que le llegó al trabajador (R5.1): distancia, descripción, fotos y precio.
 * Nunca incluye el teléfono ni el nombre del empleador (R9.4).
 */
export class IncomingRequestDto {
  @ApiProperty({ format: 'uuid' }) requestId!: string;

  @ApiProperty({
    enum: ['abierta', 'elegido', 'elegida_otra', 'cancelada', 'expirada'],
    description: 'abierta = puede ofertar; elegido = lo eligieron (ver contacto con jobId)',
  })
  outcome!: 'abierta' | 'elegido' | 'elegida_otra' | 'cancelada' | 'expirada';

  @ApiProperty({ example: { slug: 'plomeria', name: 'Plomería' } })
  category!: { slug: string; name: string };

  @ApiProperty() description!: string;
  @ApiProperty({ example: 850 }) distanceM!: number;
  @ApiProperty({ example: '150.00' }) proposedPriceBs!: string;
  @ApiProperty({ type: PriceRangeDto }) referenceRange!: PriceRangeDto;
  @ApiProperty({ example: '900.00', description: 'Tope de la contraoferta' }) maxCounterBs!: string;
  @ApiProperty({ type: [IncomingPhotoDto] }) photos!: IncomingPhotoDto[];
  @ApiProperty({ description: 'Anillo en el que le llegó' }) ring!: number;

  @ApiProperty({
    type: String,
    format: 'date-time',
    description: 'Fin del plazo de su anillo (cuenta regresiva en la app)',
  })
  respondBy!: string;

  @ApiProperty({ type: MyOfferDto, nullable: true }) myOffer!: MyOfferDto | null;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' }) jobId!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) notifiedAt!: string;
}

export class AcceptOfferResultDto {
  @ApiProperty({ format: 'uuid' }) jobId!: string;
  @ApiProperty({ format: 'uuid' }) requestId!: string;
}

/** Contacto de la contraparte, solo con el trabajo asignado (R5.4, R9.4). */
export class JobContactDto {
  @ApiProperty({ format: 'uuid' }) jobId!: string;
  @ApiProperty({ enum: ['employer', 'worker'], description: 'Rol de la contraparte' })
  role!: 'employer' | 'worker';
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty({ example: '+59171234567' }) phone!: string;
  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Dirección del trabajo (solo para el trabajador)',
  })
  address!: string | null;
  @ApiProperty({ example: '180.00' }) finalPriceBs!: string;
  @ApiProperty({ example: 'tel:+59171234567', description: 'Para el botón "Llamar"' })
  telUri!: string;
  @ApiProperty({
    example: 'https://wa.me/59171234567',
    description: 'Para el botón "WhatsApp" (sin "+", como pide wa.me)',
  })
  whatsappUri!: string;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Hasta cuándo se ve el contacto (24 h después de terminado o cancelado)',
  })
  visibleUntil!: string | null;
}
