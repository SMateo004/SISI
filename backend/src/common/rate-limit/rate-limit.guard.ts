import { type CanActivate, type ExecutionContext, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import type { AppConfigService } from '../../config/app-config';
import { clientIp } from './client-ip';
import { RATE_LIMIT_KEY } from './rate-limit.decorator';
import {
  RATE_LIMIT_POLICIES,
  type RateLimitPolicy,
  type RateLimitPolicyDef,
} from './rate-limit.policies';
import { RateLimitStore } from './rate-limit.store';
import { RateLimitedException } from './rate-limited.exception';

const scopeOf = (name: RateLimitPolicy): 'ip' | 'user' =>
  (RATE_LIMIT_POLICIES[name] as RateLimitPolicyDef).per ?? 'ip';

abstract class PolicyGuard implements CanActivate {
  protected abstract readonly scope: 'ip' | 'user';

  constructor(
    private readonly reflector: Reflector,
    private readonly store: RateLimitStore,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  /** Identidad del contador, o null si esta política no aplica a la petición. */
  protected abstract identity(req: Request): string | null;

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const policies = (
      this.reflector.getAllAndOverride<RateLimitPolicy[] | undefined>(RATE_LIMIT_KEY, [
        context.getHandler(),
        context.getClass(),
      ]) ?? []
    ).filter((name) => scopeOf(name) === this.scope);
    if (policies.length === 0) return true;

    const id = this.identity(context.switchToHttp().getRequest<Request>());
    if (id === null) return true;
    const decision = await this.store.consume(
      policies.map((name) => {
        const policy = RATE_LIMIT_POLICIES[name];
        return {
          key: `${name}:${this.scope}:${id}`,
          limit: this.config.get(policy.limitFrom, { infer: true }),
          windowSec: policy.windowSec,
        };
      }),
    );
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);
    return true;
  }
}

/** Políticas por IP de @RateLimit(): corre antes de la autenticación. */
@Injectable()
export class RateLimitGuard extends PolicyGuard {
  protected readonly scope = 'ip' as const;
  protected identity(req: Request): string {
    return clientIp(req);
  }
}

/** Políticas por usuario de @RateLimit(): corre después de JwtAuthGuard (ADR-0047). */
@Injectable()
export class UserRateLimitGuard extends PolicyGuard {
  protected readonly scope = 'user' as const;
  protected identity(req: Request): string | null {
    return (req as Request & { user?: { id: string } }).user?.id ?? null;
  }
}
