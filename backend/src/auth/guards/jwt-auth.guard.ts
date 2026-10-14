import { type CanActivate, type ExecutionContext, HttpStatus, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ApiError } from '../../common/errors/api-error';
import { type AuthenticatedRequest, IS_PUBLIC_KEY } from '../decorators/auth.decorators';
import { TokenService } from '../tokens/token.service';

/** Guard global (APP_GUARD): exige un token de acceso salvo en endpoints @Public(). */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly tokens: TokenService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean | undefined>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const req = context
      .switchToHttp()
      .getRequest<AuthenticatedRequest & { headers: Record<string, string | undefined> }>();
    const [scheme, token] = (req.headers.authorization ?? '').split(' ');
    if (scheme !== 'Bearer' || !token) {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'UNAUTHENTICATED',
        'Inicia sesión para continuar.',
      );
    }
    try {
      const payload = await this.tokens.verifyAccess(token);
      req.user = { id: payload.sub, role: payload.role };
      return true;
    } catch {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'TOKEN_INVALID',
        'Tu sesión venció. Vuelve a intentarlo.',
      );
    }
  }
}
