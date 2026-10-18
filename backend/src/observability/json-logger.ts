import type { LoggerService, LogLevel } from '@nestjs/common';
import { redactText, redactValue } from '../common/logging/redact';
import { currentRequestId, currentUserId } from './request-context';

/**
 * Logs estructurados para staging y producción (ADR-0048): una línea JSON por mensaje, con el
 * id de correlación y los datos personales redactados. Render los muestra y se pueden filtrar
 * por requestId.
 */
export class JsonLogger implements LoggerService {
  constructor(
    private readonly base: { service: string; env: string; release: string },
    private readonly write: (line: string) => void = (line) => {
      process.stdout.write(`${line}\n`);
    },
  ) {}

  log(message: unknown, ...rest: unknown[]): void {
    this.emit('log', message, rest);
  }
  error(message: unknown, ...rest: unknown[]): void {
    this.emit('error', message, rest);
  }
  warn(message: unknown, ...rest: unknown[]): void {
    this.emit('warn', message, rest);
  }
  debug(message: unknown, ...rest: unknown[]): void {
    this.emit('debug', message, rest);
  }
  verbose(message: unknown, ...rest: unknown[]): void {
    this.emit('verbose', message, rest);
  }
  fatal(message: unknown, ...rest: unknown[]): void {
    this.emit('fatal', message, rest);
  }

  private emit(level: LogLevel, message: unknown, rest: unknown[]): void {
    // Convención de Nest: el último argumento de texto es el contexto; en error, el anterior
    // puede ser el stack.
    const args = [...rest];
    const context = typeof args.at(-1) === 'string' ? (args.pop() as string) : undefined;
    const stack =
      level === 'error' && typeof args.at(-1) === 'string' ? (args.pop() as string) : undefined;
    const entry: Record<string, unknown> = {
      time: new Date().toISOString(),
      level,
      ...this.base,
      context,
      requestId: currentRequestId(),
      userId: currentUserId(),
    };
    if (message instanceof Error) {
      entry.msg = redactText(message.message);
      entry.stack = message.stack;
    } else if (typeof message === 'string') {
      entry.msg = redactText(message);
    } else {
      entry.msg = redactValue(message);
    }
    if (stack) entry.stack = stack;
    if (args.length > 0) entry.extra = redactValue(args);
    this.write(JSON.stringify(entry));
  }
}
