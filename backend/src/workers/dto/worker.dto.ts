import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsIn,
  IsInt,
  IsUUID,
  Matches,
  Max,
  Min,
} from 'class-validator';
import { ALLOWED_IMAGE_TYPES } from '../../storage/upload-policy';
import { WORKER_STATUSES, type WorkerStatus } from '../worker-status.machine';

/** Propuesta aprobada para el MVP (docs/pendientes.md). */
export const TRANSPORT_MODES = [
  'a_pie',
  'bicicleta',
  'moto',
  'auto',
  'transporte_publico',
] as const;
export type TransportModeValue = (typeof TRANSPORT_MODES)[number];

/** Radio permitido en km (propuesta: alineado con el anillo máximo de R4.2). */
export const MAX_RADIUS_RANGE = { min: 1, max: 10 } as const;

/** Documentos que pide R1.3 para el upgrade. `cert` se usará con requisitos extra (Fase 2). */
export const REQUIRED_DOCUMENTS = ['ci_front', 'ci_back', 'selfie'] as const;
export type RequiredDocumentType = (typeof REQUIRED_DOCUMENTS)[number];

export class DocumentUploadRequestDto {
  @ApiProperty({ enum: REQUIRED_DOCUMENTS, example: 'ci_front' })
  @IsIn(REQUIRED_DOCUMENTS, { message: 'Tipo de documento no válido.' })
  type!: RequiredDocumentType;

  @ApiProperty({ enum: ALLOWED_IMAGE_TYPES, example: 'image/jpeg' })
  @IsIn(ALLOWED_IMAGE_TYPES, { message: 'Solo se aceptan fotos JPEG, PNG o HEIC.' })
  contentType!: string;

  @ApiProperty({ example: 1_245_812, description: 'Tamaño exacto en bytes (máx. 8 MB)' })
  @IsInt({ message: 'El tamaño debe ser un número entero de bytes.' })
  @Min(1, { message: 'La foto está vacía.' })
  sizeBytes!: number;
}

export class SubmitUpgradeDto {
  @ApiProperty({ example: '1995-04-21', description: 'Fecha de nacimiento (AAAA-MM-DD)' })
  @Matches(/^\d{4}-\d{2}-\d{2}$/, {
    message: 'La fecha de nacimiento debe tener el formato AAAA-MM-DD.',
  })
  birthDate!: string;

  @ApiProperty({ type: [String], example: ['b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e'] })
  @ArrayMinSize(1, { message: 'Elige al menos una categoría.' })
  @ArrayMaxSize(6, { message: 'Puedes elegir hasta 6 categorías.' })
  @IsUUID('all', { each: true, message: 'Alguna categoría no es válida.' })
  categoryIds!: string[];

  @ApiProperty({ enum: TRANSPORT_MODES, example: 'moto' })
  @IsIn(TRANSPORT_MODES, { message: 'Elige un medio de transporte de la lista.' })
  transport!: TransportModeValue;

  @ApiProperty({ example: 5, minimum: MAX_RADIUS_RANGE.min, maximum: MAX_RADIUS_RANGE.max })
  @IsInt({ message: 'El radio debe ser un número entero de kilómetros.' })
  @Min(MAX_RADIUS_RANGE.min, { message: 'El radio mínimo es 1 km.' })
  @Max(MAX_RADIUS_RANGE.max, { message: 'El radio máximo es 10 km.' })
  maxRadiusKm!: number;
}

export class WorkerDocumentStatusDto {
  @ApiProperty({ enum: ['ci_front', 'ci_back', 'selfie', 'cert'], example: 'ci_front' })
  type!: string;

  @ApiProperty({ enum: ['pendiente', 'aprobado', 'rechazado'], example: 'pendiente' })
  reviewStatus!: string;

  @ApiProperty({ example: '2026-10-14T12:00:00.000Z' })
  uploadedAt!: string;
}

export class WorkerProfileDto {
  @ApiProperty({ enum: WORKER_STATUSES, example: 'sin_solicitar' })
  status!: WorkerStatus;

  @ApiPropertyOptional({
    example: 'La foto del carnet está borrosa.',
    nullable: true,
    type: String,
  })
  rejectionReason!: string | null;

  @ApiPropertyOptional({ example: '1995-04-21', nullable: true, type: String })
  birthDate!: string | null;

  @ApiPropertyOptional({ enum: TRANSPORT_MODES, nullable: true })
  transport!: TransportModeValue | null;

  @ApiPropertyOptional({ example: 5, nullable: true, type: Number })
  maxRadiusKm!: number | null;

  @ApiProperty({ type: [String] })
  categoryIds!: string[];

  @ApiProperty({
    type: [WorkerDocumentStatusDto],
    description: 'Estado de cada documento. Nunca incluye la imagen (R9.5).',
  })
  documents!: WorkerDocumentStatusDto[];

  @ApiPropertyOptional({ example: '2026-10-14T12:00:00.000Z', nullable: true, type: String })
  submittedAt!: string | null;

  @ApiProperty({ example: true, description: 'Puede editar documentos y enviar la solicitud' })
  editable!: boolean;

  @ApiProperty({ example: ['ci_back', 'selfie'], description: 'Documentos que faltan subir' })
  missingDocuments!: string[];
}

export class DocumentUrlDto {
  @ApiProperty({
    example: 'https://...?X-Amz-Signature=...',
    description: 'Enlace temporal (5 min)',
  })
  url!: string;

  @ApiProperty({ example: '2026-10-14T12:05:00.000Z' })
  expiresAt!: string;
}
