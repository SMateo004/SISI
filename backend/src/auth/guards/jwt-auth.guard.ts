import {
  type CanActivate,
  type ExecutionContext,
  HttpStatus,
  Inject,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { Redis } from 'ioredis';
import { REDIS_CLIENT } from '../../redis/redis.constants';
import { ApiError } from '../../common/errors/api-error';
import { setContextUser } from '../../observability/request-context';
import { type AuthenticatedRequest, IS_PUBLIC_KEY } from '../decorators/auth.decorators';
import { type Audience, type Role, TokenService } from '../tokens/token.service';

export interface VerifiedAccess {
  id: string;
  role: Role;
  aud: Audience;
  /** Vencimiento del token de acceso (ms Unix), si lo trae. */
  expiresAt?: number;
}

/**
 * Verifica un token de acceso con las mismas reglas y errores para HTTP y para el
 * handshake de Socket.IO (ADR-0023).
 */
export async function authenticateAccessToken(
  tokens: TokenService,
  token: string | undefined,
): Promise<VerifiedAccess> {
  if (!token) {
    throw new ApiError(HttpStatus.UNAUTHORIZED, 'UNAUTHENTICATED', 'Inicia sesión para continuar.');
  }
  try {
    const payload = await tokens.verifyAccess(token);
    return {
      id: payload.sub,
      role: payload.role,
      aud: payload.aud ?? 'app',
      ...(payload.exp !== undefined ? { expiresAt: payload.exp * 1000 } : {}),
    };
  } catch {
    throw new ApiError(
      HttpStatus.UNAUTHORIZED,
      'TOKEN_INVALID',
      'Tu sesión venció. Vuelve a intentarlo.',
    );
  }
}

/** Guard global (APP_GUARD): exige un token de acceso salvo en endpoints @Public(). */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly tokens: TokenService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
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
    const user = await authenticateAccessToken(
      this.tokens,
      scheme === 'Bearer' ? token : undefined,
    );
    // Una cuenta recién eliminada: sus tokens de acceso vigentes dejan de servir (ADR-0049).
    if ((await this.redis.exists(`account:deleted:${user.id}`)) === 1) {
      throw new ApiError(HttpStatus.UNAUTHORIZED, 'ACCOUNT_DELETED', 'Esta cuenta fue eliminada.');
    }
    req.user = { id: user.id, role: user.role, aud: user.aud };
    setContextUser(user.id);
    return true;
  }
}
