import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsInt, IsString, MaxLength, Min } from 'class-validator';
import { ALLOWED_IMAGE_TYPES } from '../upload-policy';

export class UploadRequestDto {
  @ApiProperty({ enum: ALLOWED_IMAGE_TYPES, example: 'image/jpeg' })
  @IsIn(ALLOWED_IMAGE_TYPES, { message: 'Solo se aceptan fotos JPEG, PNG o HEIC.' })
  contentType!: string;

  @ApiProperty({ example: 245_812, description: 'Tamaño exacto del archivo en bytes (máx. 8 MB)' })
  @IsInt({ message: 'El tamaño debe ser un número entero de bytes.' })
  @Min(1, { message: 'La foto está vacía.' })
  sizeBytes!: number;
}

export class PresignedUploadDto {
  @ApiProperty({
    example: 'avatars/7b0a.../c0ffee.jpg',
    description: 'Clave para confirmar la subida',
  })
  key!: string;

  @ApiProperty({ example: 'https://...?X-Amz-Signature=...' })
  uploadUrl!: string;

  @ApiProperty({ example: 'PUT', enum: ['PUT'] })
  method!: 'PUT';

  @ApiProperty({
    example: { 'Content-Type': 'image/jpeg' },
    description: 'Headers a enviar tal cual en el PUT',
  })
  headers!: Record<string, string>;

  @ApiProperty({ example: '2026-10-14T12:05:00.000Z' })
  expiresAt!: string;
}

export class ConfirmUploadDto {
  @ApiProperty({ example: 'avatars/7b0a.../c0ffee.jpg' })
  @IsString({ message: 'Falta la clave del archivo.' })
  @MaxLength(300, { message: 'La clave del archivo no es válida.' })
  key!: string;
}
