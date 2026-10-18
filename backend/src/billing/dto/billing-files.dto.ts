import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';

export class FileUploadDto {
  @ApiProperty({ example: 'image/jpeg', description: 'JPEG, PNG o HEIC' })
  @IsString()
  contentType!: string;

  @ApiProperty({ example: 120000 })
  @IsInt()
  @Min(1)
  sizeBytes!: number;
}

export class SetQrDto {
  @ApiProperty({ description: 'Clave devuelta por qr/upload-url, después del PUT' })
  @IsString()
  @MaxLength(300)
  key!: string;
}

export class QrResultDto {
  @ApiProperty({ description: 'URL temporal del QR' }) qrUrl!: string;
}

export class CreateSubmissionDto {
  @ApiProperty({ description: 'Clave devuelta por submissions/upload-url, después del PUT' })
  @IsString()
  @MaxLength(300)
  receiptKey!: string;

  @ApiPropertyOptional({ example: '29.90', description: 'Monto que dice haber pagado (texto)' })
  @IsOptional()
  @Matches(/^\d{1,8}(\.\d{1,2})?$/, { message: 'El monto no es válido.' })
  declaredAmountBs?: string;

  @ApiPropertyOptional({ maxLength: 300 })
  @IsOptional()
  @IsString()
  @MaxLength(300)
  note?: string;
}

export class RejectSubmissionDto {
  @ApiProperty({ example: 'El comprobante no se lee.', minLength: 3, maxLength: 300 })
  @IsString()
  @MinLength(3)
  @MaxLength(300)
  note!: string;
}

export class ListSubmissionsQuery {
  @ApiPropertyOptional({ enum: ['pendiente', 'registrado', 'rechazado'], default: 'pendiente' })
  @IsOptional()
  @IsIn(['pendiente', 'registrado', 'rechazado'])
  status?: 'pendiente' | 'registrado' | 'rechazado';
}

/** Comprobante enviado por el trabajador ("pendiente de verificación"). */
export class PaymentSubmissionDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) workerId!: string;
  @ApiProperty({ enum: ['pendiente', 'registrado', 'rechazado'] }) status!:
    'pendiente' | 'registrado' | 'rechazado';
  @ApiProperty({ type: String, nullable: true, example: '29.90' }) declaredAmountBs!: string | null;
  @ApiProperty({ type: String, nullable: true }) note!: string | null;
  @ApiProperty({ type: String, nullable: true, description: 'Motivo si se rechazó' })
  reviewNote!: string | null;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' }) paymentId!: string | null;
  @ApiProperty({ description: 'URL temporal del comprobante' }) receiptUrl!: string;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

/** Comprobante en el panel: con quién lo envió. */
export class AdminPaymentSubmissionDto extends PaymentSubmissionDto {
  @ApiProperty({ type: String, nullable: true }) workerName!: string | null;
  @ApiProperty() workerPhone!: string;
}
