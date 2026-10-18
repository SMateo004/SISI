import {
  type CanActivate,
  type ExecutionContext,
  HttpStatus,
  Inject,
  Injectable,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import { type AuthenticatedRequest, ROLES_KEY } from '../../auth/decorators/auth.decorators';
import type { Role } from '../../auth/tokens/token.service';
import type { AppConfigService } from '../../config/app-config';
import { ApiError } from '../errors/api-error';
import { RateLimitStore } from '../rate-limit/rate-limit.store';
import { RateLimitedException } from '../rate-limit/rate-limited.exception';
import {
  ADMIN_EXPORT_KEY,
  ADMIN_PERMISSION_KEY,
  type AdminPermission,
  hasPermission,
} from './admin-permissions';

/** Tipo de límite del panel para un request (ADR-0040, ADR-0010). */
export const adminLimitKind = (method: string, isExport: boolean): 'export' | 'read' | 'write' =>
  isExport ? 'export' : ['GET', 'HEAD'].includes(method.toUpperCase()) ? 'read' : 'write';

/**
 * Guard global del panel. Corre después de RolesGuard (que ya exigió rol admin y aud=admin):
 * - verifica el permiso del área (@Admin('cobros'), …);
 * - una ruta @Roles('admin') sin permiso declarado se rechaza (falla cerrada);
 * - límites por admin: lectura, escritura y exportación (no por IP: detrás del proxy de
 *   Vercel todos los admins comparten IP).
 */
@Injectable()
export class AdminGuard implements CanActivate {
  private readonly logger = new Logger(AdminGuard.name);

  constructor(
    private readonly reflector: Reflector,
    private readonly store: RateLimitStore,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const targets = [context.getHandler(), context.getClass()];
    const roles = this.reflector.getAllAndOverride<Role[] | undefined>(ROLES_KEY, targets);
    if (!roles?.includes('admin')) return true;

    const req = context.switchToHttp().getRequest<Request & AuthenticatedRequest>();
    const permission = this.reflector.getAllAndOverride<AdminPermission | undefined>(
      ADMIN_PERMISSION_KEY,
      targets,
    );
    if (!permission) {
      this.logger.error(`Ruta admin sin @Admin(permiso): ${req.method} ${req.path}`);
      throw denied();
    }
    const user = req.user;
    if (!user || !hasPermission(user.role, permission)) throw denied();

    const isExport =
      this.reflector.getAllAndOverride<boolean | undefined>(ADMIN_EXPORT_KEY, targets) ?? false;
    const kind = adminLimitKind(req.method, isExport);
    const rule = {
      export: {
        limit: this.config.get('RATE_ADMIN_EXPORT_PER_HOUR', { infer: true }),
        windowSec: 3600,
      },
      read: { limit: this.config.get('RATE_ADMIN_READ_PER_MIN', { infer: true }), windowSec: 60 },
      write: { limit: this.config.get('RATE_ADMIN_WRITE_PER_MIN', { infer: true }), windowSec: 60 },
    }[kind];
    const decision = await this.store.consume([{ key: `admin:${kind}:user:${user.id}`, ...rule }]);
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);
    return true;
  }
}

const denied = (): ApiError =>
  new ApiError(
    HttpStatus.FORBIDDEN,
    'ADMIN_PERMISSION_DENIED',
    'No tienes permiso para esta sección del panel.',
  );
