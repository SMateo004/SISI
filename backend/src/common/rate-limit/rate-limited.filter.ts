import { type ArgumentsHost, Catch, type ExceptionFilter } from '@nestjs/common';
import type { Response } from 'express';
import { RateLimitedException } from './rate-limited.exception';

/** Agrega Retry-After a todo 429 propio, venga de un guard o de un servicio. */
@Catch(RateLimitedException)
export class RateLimitedFilter implements ExceptionFilter<RateLimitedException> {
  catch(exception: RateLimitedException, host: ArgumentsHost): void {
    const res = host.switchToHttp().getResponse<Response>();
    res
      .status(exception.getStatus())
      .setHeader('Retry-After', String(exception.retryAfterSec))
      .json(exception.getResponse());
  }
}
