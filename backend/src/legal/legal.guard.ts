import {
  type CanActivate,
  type ExecutionContext,
  HttpStatus,
  Inject,
  Injectable,
  SetMetadata,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Reflector } from '@nestjs/core';
import type { AuthenticatedRequest } from '../auth/decorators/auth.decorators';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { LegalService } from './legal.service';

export const SKIP_LEGAL_KEY = 'sisi:skip-legal';
/** La ruta funciona sin haber aceptado los textos vigentes (ver /me, aceptarlos, salir, borrar la cuenta). */
export const SkipLegal = () => SetMetadata(SKIP_LEGAL_KEY, true);

/**
 * Sin aceptar la versión vigente de los términos y la privacidad, una sesión de la app solo
 * puede ver su cuenta, leer y aceptar los textos, salir o eliminar la cuenta (ADR-0051). El
 * panel (aud=admin) no pasa por aquí.
 */
@Injectable()
export class LegalGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly legal: LegalService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    if (context.getType() !== 'http') return true;
    if (!this.config.get('LEGAL_ACCEPTANCE_REQUIRED', { infer: true })) return true;
    const skip = this.reflector.getAllAndOverride<boolean | undefined>(SKIP_LEGAL_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (skip) return true;
    const req = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const user = req.user;
    if (!user || user.aud === 'admin') return true;
    const pending = await this.legal.pendingFor(user.id);
    if (pending.length === 0) return true;
    throw new ApiError(
      HttpStatus.FORBIDDEN,
      'LEGAL_ACCEPTANCE_REQUIRED',
      'Para continuar, revisa y acepta los términos de uso y la política de privacidad.',
      { pending },
    );
  }
}
