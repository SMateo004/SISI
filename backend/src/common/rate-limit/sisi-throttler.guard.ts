import { type ExecutionContext, Injectable } from '@nestjs/common';
import { ThrottlerGuard, type ThrottlerLimitDetail } from '@nestjs/throttler';
import type { Request } from 'express';
import { clientIp } from './client-ip';
import { RateLimitedException } from './rate-limited.exception';

/** Límite global por IP con mensaje en español (la respuesta incluye Retry-After). */
@Injectable()
export class SisiThrottlerGuard extends ThrottlerGuard {
  protected override getTracker(req: Record<string, unknown>): Promise<string> {
    return Promise.resolve(clientIp(req as unknown as Request));
  }

  protected override throwThrottlingException(
    _context: ExecutionContext,
    detail: ThrottlerLimitDetail,
  ): Promise<void> {
    throw new RateLimitedException(Math.max(1, detail.timeToBlockExpire));
  }
}
