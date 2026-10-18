import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  Equals,
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  MaxLength,
  Min,
} from 'class-validator';

export const LEGAL_TYPES = ['terms', 'privacy'] as const;

export class LegalDocumentDto {
  @ApiProperty({ enum: LEGAL_TYPES }) type!: 'terms' | 'privacy';
  @ApiProperty({ example: 1 }) version!: number;
  @ApiProperty({ example: 'Términos de uso' }) title!: string;
  @ApiProperty({ description: 'Texto en Markdown' }) contentMd!: string;
  @ApiProperty({ type: String, format: 'date-time' }) publishedAt!: string;
  @ApiProperty({ description: 'Sigue pendiente de revisión legal (borrador)' }) draft!: boolean;
  @ApiProperty({ description: 'Versión v0 que solo vale para el piloto cerrado con invitación' })
  pilotOnly!: boolean;
}

export class AcceptLegalDto {
  @ApiProperty({ example: 1, description: 'Versión de los términos que se muestran' })
  @IsInt({ message: 'Versión inválida.' })
  @Min(1)
  termsVersion!: number;

  @ApiProperty({ example: 1, description: 'Versión de la política de privacidad que se muestra' })
  @IsInt({ message: 'Versión inválida.' })
  @Min(1)
  privacyVersion!: number;

  @ApiProperty({ description: 'Declaro ser mayor de 18 años' })
  @IsBoolean()
  @Equals(true, { message: 'Para usar la app tienes que ser mayor de 18 años.' })
  adult!: boolean;

  @ApiPropertyOptional({ example: '0.9.0+3' })
  @IsOptional()
  @IsString()
  @MaxLength(40)
  appVersion?: string;

  @ApiPropertyOptional({ enum: ['android', 'ios', 'web'] })
  @IsOptional()
  @IsIn(['android', 'ios', 'web'])
  platform?: 'android' | 'ios' | 'web';
}

export class LegalPendingDto {
  @ApiProperty({ enum: LEGAL_TYPES, isArray: true, description: 'Textos que falta aceptar' })
  legalPending!: ('terms' | 'privacy')[];
}
