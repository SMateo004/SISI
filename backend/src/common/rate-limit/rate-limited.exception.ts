import { HttpException, HttpStatus } from '@nestjs/common';

export interface RateLimitedBody {
  statusCode: 429;
  code: 'RATE_LIMITED';
  message: string;
  retryAfterSec: number;
}

/** 429 con mensaje en español. El filtro HTTP agrega el header Retry-After. */
export class RateLimitedException extends HttpException {
  constructor(readonly retryAfterSec: number) {
    const body: RateLimitedBody = {
      statusCode: 429,
      code: 'RATE_LIMITED',
      message: `Demasiados intentos. Intenta de nuevo en ${formatWait(retryAfterSec)}.`,
      retryAfterSec,
    };
    super(body, HttpStatus.TOO_MANY_REQUESTS);
  }
}

function formatWait(seconds: number): string {
  if (seconds < 60) return `${seconds} ${seconds === 1 ? 'segundo' : 'segundos'}`;
  const minutes = Math.ceil(seconds / 60);
  return `${minutes} ${minutes === 1 ? 'minuto' : 'minutos'}`;
}
