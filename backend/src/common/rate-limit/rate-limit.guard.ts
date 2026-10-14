import { type CanActivate, type ExecutionContext, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Reflector } from '@nestjs/core';
import type { Request } from 'express';
import type { AppConfigService } from '../../config/app-config';
import { clientIp } from './client-ip';
import { RATE_LIMIT_KEY } from './rate-limit.decorator';
import { RATE_LIMIT_POLICIES, type RateLimitPolicy } from './rate-limit.policies';
import { RateLimitStore } from './rate-limit.store';
import { RateLimitedException } from './rate-limited.exception';

/** Aplica las políticas declaradas con @RateLimit() usando la IP como clave. */
@Injectable()
export class RateLimitGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly store: RateLimitStore,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const policies = this.reflector.getAllAndOverride<RateLimitPolicy[] | undefined>(
      RATE_LIMIT_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (!policies || policies.length === 0) return true;

    const ip = clientIp(context.switchToHttp().getRequest<Request>());
    const decision = await this.store.consume(
      policies.map((name) => {
        const policy = RATE_LIMIT_POLICIES[name];
        return {
          key: `${name}:ip:${ip}`,
          limit: this.config.get(policy.limitFrom, { infer: true }),
          windowSec: policy.windowSec,
        };
      }),
    );
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);
    return true;
  }
}
