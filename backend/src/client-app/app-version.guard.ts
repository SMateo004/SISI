import { type CanActivate, type ExecutionContext, Injectable, SetMetadata } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { ApiError } from '../common/errors/api-error';
import { ClientAppService } from './client-app.service';
import { isAppPlatform } from './semver';

export const SKIP_VERSION_KEY = 'sisi:skip-app-version';
/** La ruta responde aunque la app esté desactualizada (configuración, salud, textos, borrar cuenta). */
export const SkipAppVersion = () => SetMetadata(SKIP_VERSION_KEY, true);

/**
 * Actualización obligatoria (ADR-0054): la app envía X-App-Platform y X-App-Version; si la
 * versión es menor que la mínima de su plataforma, la API responde 426 APP_UPGRADE_REQUIRED y la
 * app muestra "Actualiza la app". Sin esos headers (panel, scripts) no se aplica.
 */
@Injectable()
export class AppVersionGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly app: ClientAppService,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    if (context.getType() !== 'http') return true;
    const req = context.switchToHttp().getRequest<Request>();
    const platform = req.headers['x-app-platform'];
    const version = req.headers['x-app-version'];
    if (!isAppPlatform(platform) || typeof version !== 'string') return true;
    const skip = this.reflector.getAllAndOverride<boolean | undefined>(SKIP_VERSION_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (skip || !this.app.mustUpgrade(platform, version)) return true;
    throw new ApiError(
      426, // Upgrade Required (Nest no lo trae en su enum)
      'APP_UPGRADE_REQUIRED',
      'Hay una versión nueva de la app. Actualízala para seguir usándola.',
      { minVersion: this.app.minVersion(platform), storeUrl: this.app.storeUrl(platform) },
    );
  }
}
