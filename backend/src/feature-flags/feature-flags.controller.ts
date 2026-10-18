import { Body, Controller, Get, Param, Put } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { IsBoolean, IsOptional, IsString, IsUUID, MaxLength, ValidateIf } from 'class-validator';
import { AdminAuditService } from '../audit/admin-audit.service';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { FeatureFlagsService } from './feature-flags.service';

export class SetFeatureFlagDto {
  @ApiProperty({ example: true })
  @IsBoolean({ message: 'enabled debe ser verdadero o falso.' })
  enabled!: boolean;

  @ApiPropertyOptional({
    example: null,
    nullable: true,
    type: String,
    description: 'null u omitido = valor global',
  })
  @IsOptional()
  @ValidateIf((_, v) => v !== null)
  @IsUUID('all', { message: 'cityId no es válido.' })
  cityId?: string | null;

  @ApiPropertyOptional({ example: 'Pago dentro de la app (etapa 2)' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  description?: string;
}

export class FeatureFlagDto {
  @ApiProperty({ example: 'payments.in_app' }) key!: string;
  @ApiProperty({ nullable: true, type: String, example: null }) cityId!: string | null;
  @ApiProperty({ example: false }) enabled!: boolean;
  @ApiProperty({ nullable: true, type: String }) description!: string | null;
  @ApiProperty({ example: '2026-10-15T12:00:00.000Z' }) updatedAt!: string;
}

const toDto = (f: {
  key: string;
  cityId: string | null;
  enabled: boolean;
  description: string | null;
  updatedAt: Date;
}): FeatureFlagDto => ({ ...f, updatedAt: f.updatedAt.toISOString() });

@ApiTags('admin')
@ApiBearerAuth()
@Admin('configuracion')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/feature-flags')
export class FeatureFlagsController {
  constructor(
    private readonly flags: FeatureFlagsService,
    private readonly audit: AdminAuditService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Feature flags (globales y por ciudad)' })
  @ApiOkResponse({ type: FeatureFlagDto, isArray: true })
  async list(): Promise<FeatureFlagDto[]> {
    return (await this.flags.list()).map(toDto);
  }

  @Put(':key')
  @ApiOperation({
    summary: 'Enciende o apaga un flag',
    description: 'Con cityId solo afecta a esa ciudad; sin cityId es el valor global (R10.2).',
  })
  @ApiOkResponse({ type: FeatureFlagDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'FLAG_KEY_INVALID o VALIDATION_ERROR' })
  async set(
    @AdminCtx() ctx: AdminContext,
    @Param('key') key: string,
    @Body() dto: SetFeatureFlagDto,
  ): Promise<FeatureFlagDto> {
    return toDto(
      await this.flags.set(
        key,
        { cityId: dto.cityId ?? null, enabled: dto.enabled, description: dto.description },
        ctx.adminId,
        this.audit.hook(ctx),
      ),
    );
  }
}
