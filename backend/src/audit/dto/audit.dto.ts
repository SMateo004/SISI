import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsString, IsUUID, Matches, MaxLength } from 'class-validator';

export class AuditQueryDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  adminId?: string;

  @ApiPropertyOptional({
    example: 'billing.',
    description: 'Acción o prefijo (p. ej. "billing." trae todas las de cobros)',
  })
  @IsOptional()
  @IsString()
  @MaxLength(64)
  action?: string;

  @ApiPropertyOptional({ example: 'worker' })
  @IsOptional()
  @IsString()
  @MaxLength(32)
  targetType?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(64)
  targetId?: string;

  @ApiPropertyOptional({ type: String, format: 'date-time', description: 'Desde (incluido)' })
  @IsOptional()
  @IsDateString()
  from?: string;

  @ApiPropertyOptional({ type: String, format: 'date-time', description: 'Hasta (excluido)' })
  @IsOptional()
  @IsDateString()
  to?: string;

  @ApiPropertyOptional({ description: 'nextCursor de la página anterior' })
  @IsOptional()
  @Matches(/^\d{1,19}$/)
  cursor?: string;
}

export class AuditEntryDto {
  @ApiProperty({ example: '42' }) id!: string;
  @ApiProperty({ format: 'uuid' }) adminId!: string;
  @ApiProperty({ type: String, nullable: true }) adminName!: string | null;
  @ApiProperty() adminPhone!: string;
  @ApiProperty({ example: 'verification.approve' }) action!: string;
  @ApiProperty({ example: 'worker' }) targetType!: string;
  @ApiProperty() targetId!: string;
  @ApiProperty({ type: 'object', nullable: true, additionalProperties: true })
  before!: unknown;
  @ApiProperty({ type: 'object', nullable: true, additionalProperties: true })
  after!: unknown;
  @ApiProperty({ type: String, nullable: true }) reason!: string | null;
  @ApiProperty({ type: String, nullable: true }) ip!: string | null;
  @ApiProperty({ type: String, nullable: true }) forwardedFor!: string | null;
  @ApiProperty({ type: String, nullable: true }) userAgent!: string | null;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' }) cityId!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class AuditPageDto {
  @ApiProperty({ type: AuditEntryDto, isArray: true }) items!: AuditEntryDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}
