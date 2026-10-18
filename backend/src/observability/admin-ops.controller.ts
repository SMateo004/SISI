import { Controller, HttpCode, HttpStatus, Inject, Post } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiExcludeController } from '@nestjs/swagger';
import { Admin } from '../common/admin/admin-permissions';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';

/**
 * Simulacro de un 5xx real para probar la alerta de errores de Sentry (ADR-0048). Solo un
 * admin, y nunca en producción (404). No sale en el contrato.
 */
@ApiExcludeController()
@Admin('configuracion')
@Controller('admin/ops')
export class AdminOpsController {
  constructor(@Inject(ConfigService) private readonly config: AppConfigService) {}

  @Post('drill-500')
  @HttpCode(HttpStatus.NO_CONTENT)
  drill(): void {
    if (this.config.get('APP_ENV', { infer: true }) === 'production') {
      throw new ApiError(HttpStatus.NOT_FOUND, 'NOT_FOUND', 'No existe.');
    }
    throw new Error('Simulacro de error 5xx (ops drill): ignorar.');
  }
}
