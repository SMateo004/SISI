import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsIn, IsOptional, IsString, IsUUID, MaxLength, MinLength } from 'class-validator';
import { REJECTION_REASONS, type RejectionReason } from '../verification.rules';

const trim = ({ value }: { value: unknown }) => (typeof value === 'string' ? value.trim() : value);

export class VerificationQueueQueryDto {
  @ApiPropertyOptional({ format: 'uuid', description: 'nextCursor de la página anterior' })
  @IsOptional()
  @IsUUID()
  cursor?: string;
}

export class VerificationRowDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty() phone!: string;
  @ApiProperty() cityName!: string;
  @ApiProperty({ type: String, format: 'date-time' }) submittedAt!: string;
  @ApiProperty({ type: String, isArray: true }) categories!: string[];
}

export class VerificationPageDto {
  @ApiProperty({ type: VerificationRowDto, isArray: true }) items!: VerificationRowDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class VerificationCategoryDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() name!: string;
  @ApiProperty({
    type: String,
    isArray: true,
    description: 'Requisitos extra de verificación (R2.2)',
  })
  extraRequirements!: string[];
}

export class VerificationDocumentDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: ['ci_front', 'ci_back', 'selfie', 'cert'] }) type!: string;
  @ApiProperty({ description: 'URL temporal (5 minutos, sin caché). Nunca se guarda.' })
  url!: string;
  @ApiProperty({ type: String, format: 'date-time' }) expiresAt!: string;
}

export class VerificationDetailDto extends VerificationRowDto {
  @ApiProperty({ example: 'pendiente_revision' }) status!: string;
  @ApiProperty({ type: String, nullable: true, format: 'date' }) birthDate!: string | null;
  @ApiProperty({ type: Number, nullable: true, description: 'Edad en la zona de su ciudad' })
  age!: number | null;
  @ApiProperty({ type: String, nullable: true }) transport!: string | null;
  @ApiProperty({ type: Number, nullable: true }) maxRadiusKm!: number | null;
  @ApiProperty({ type: VerificationCategoryDto, isArray: true })
  categoryDetails!: VerificationCategoryDto[];
  @ApiProperty({ type: VerificationDocumentDto, isArray: true })
  documents!: VerificationDocumentDto[];
}

export class ApproveVerificationDto {
  @ApiPropertyOptional({ example: 'Documentos claros.' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  @Transform(trim)
  note?: string;
}

export class RejectVerificationDto {
  @ApiProperty({ enum: REJECTION_REASONS })
  @IsIn(REJECTION_REASONS, { message: 'Elige un motivo de la lista.' })
  reason!: RejectionReason;

  @ApiProperty({ example: 'La foto del reverso está movida; vuelve a sacarla con buena luz.' })
  @IsString({ message: 'Escribe una nota para el trabajador.' })
  @MinLength(5, { message: 'Escribe una nota para el trabajador (al menos 5 letras).' })
  @MaxLength(500)
  @Transform(trim)
  note!: string;
}

export class VerificationResultDto {
  @ApiProperty({ format: 'uuid' }) userId!: string;
  @ApiProperty({ enum: ['aprobado', 'rechazado'] }) status!: string;
  @ApiProperty({ type: String, nullable: true }) rejectionReason!: string | null;
}
