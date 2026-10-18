import { Body, Controller, Get, HttpCode, Param, Post, Put } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AdminAuditService } from '../audit/admin-audit.service';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { AppSettingsService } from './app-settings.service';
import { ResetSettingDto, SetSettingDto, SettingDto } from './dto/settings.dto';

@ApiTags('admin')
@Admin('configuracion')
@ApiNotFoundResponse({ type: ApiErrorBody, description: 'SETTING_NOT_FOUND' })
@Controller('admin/settings')
export class AdminSettingsController {
  constructor(
    private readonly settings: AppSettingsService,
    private readonly audit: AdminAuditService,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Parámetros de negocio editables (ADR-0043)',
    description: 'Valor vigente, valor por defecto (entorno), rango y unidad.',
  })
  @ApiOkResponse({ type: SettingDto, isArray: true })
  list(): SettingDto[] {
    return this.settings.list();
  }

  @Put(':key')
  @ApiOperation({
    summary: 'Cambiar un parámetro, con motivo',
    description: 'Se valida el rango. API, worker y cron lo toman en segundos, sin redeploy.',
  })
  @ApiOkResponse({ type: SettingDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'SETTING_OUT_OF_RANGE' })
  set(
    @AdminCtx() ctx: AdminContext,
    @Param('key') key: string,
    @Body() dto: SetSettingDto,
  ): Promise<SettingDto> {
    return this.settings.set(key, dto.value, ctx.adminId, this.audit.hook(ctx), dto.reason);
  }

  @Post(':key/reset')
  @HttpCode(200)
  @ApiOperation({ summary: 'Volver al valor por defecto (variable de entorno)' })
  @ApiOkResponse({ type: SettingDto })
  reset(
    @AdminCtx() ctx: AdminContext,
    @Param('key') key: string,
    @Body() dto: ResetSettingDto,
  ): Promise<SettingDto> {
    return this.settings.reset(key, this.audit.hook(ctx), dto.reason);
  }
}
