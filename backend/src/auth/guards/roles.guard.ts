import { type CanActivate, type ExecutionContext, HttpStatus, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ApiError } from '../../common/errors/api-error';
import { type AuthenticatedRequest, ROLES_KEY } from '../decorators/auth.decorators';
import type { Role } from '../tokens/token.service';

const forbidden = (): ApiError =>
  new ApiError(HttpStatus.FORBIDDEN, 'FORBIDDEN', 'No tienes permiso para esta acción.');

/**
 * Guard global: aplica @Roles(). Corre después de JwtAuthGuard.
 * Además separa las sesiones (ADR-0040): las rutas @Roles('admin') exigen una sesión del panel
 * (`aud=admin`), y una sesión del panel solo sirve en ellas.
 */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.getAllAndOverride<Role[] | undefined>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    const user = context.switchToHttp().getRequest<AuthenticatedRequest>().user;
    const adminRoute = roles?.includes('admin') ?? false;
    if (user?.aud === 'admin' && !adminRoute) {
      throw new ApiError(
        HttpStatus.FORBIDDEN,
        'ADMIN_SESSION_SCOPE',
        'La sesión del panel solo sirve para el panel.',
      );
    }
    if (!roles || roles.length === 0) return true;
    if (!user || !roles.includes(user.role)) throw forbidden();
    if (adminRoute && user.aud !== 'admin') {
      throw new ApiError(
        HttpStatus.FORBIDDEN,
        'ADMIN_SESSION_REQUIRED',
        'Ingresa al panel de administración para esta acción.',
      );
    }
    return true;
  }
}
