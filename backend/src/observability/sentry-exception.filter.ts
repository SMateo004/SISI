import { type ArgumentsHost, Catch, HttpException } from '@nestjs/common';
import { BaseExceptionFilter } from '@nestjs/core';
import type { Request } from 'express';
import { reportError } from './sentry';

/**
 * Los 5xx (errores inesperados) van a Sentry; los 4xx no (son respuestas esperadas). La
 * respuesta sale igual que siempre (BaseExceptionFilter). Se registra antes que los filtros
 * específicos: Nest prueba los globales en orden inverso, así RateLimitedFilter gana su 429.
 */
@Catch()
export class SentryExceptionFilter extends BaseExceptionFilter {
  override catch(exception: unknown, host: ArgumentsHost): void {
    const status = exception instanceof HttpException ? exception.getStatus() : 500;
    if (status >= 500 && host.getType() === 'http') {
      const req = host.switchToHttp().getRequest<Request>();
      const route = (req.route as { path?: string } | undefined)?.path ?? req.path;
      reportError(exception, { route: `${req.method} ${route}` });
    }
    super.catch(exception, host);
  }
}
