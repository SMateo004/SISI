import { createParamDecorator, type ExecutionContext, SetMetadata } from '@nestjs/common';
import type { Audience, Role, TokenSubject } from '../tokens/token.service';

export const IS_PUBLIC_KEY = 'sisi:is-public';
export const ROLES_KEY = 'sisi:roles';

/** El endpoint no exige token (health, auth). Todo lo demás queda protegido por defecto. */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

/** Restringe el endpoint a uno o más roles (p. ej. @Roles('admin')). */
export const Roles = (...roles: Role[]) => SetMetadata(ROLES_KEY, roles);

export type AuthenticatedUser = TokenSubject & {
  /** Sesión de la app o del panel admin (ADR-0040). */
  aud?: Audience;
};

export interface AuthenticatedRequest {
  user?: AuthenticatedUser;
}

/** Usuario autenticado del request (lo coloca JwtAuthGuard). */
export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AuthenticatedUser => {
    const user = ctx.switchToHttp().getRequest<AuthenticatedRequest>().user;
    if (!user) throw new Error('CurrentUser usado en un endpoint público');
    return user;
  },
);
