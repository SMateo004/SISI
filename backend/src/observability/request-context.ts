import { AsyncLocalStorage } from 'node:async_hooks';
import { randomUUID } from 'node:crypto';
import type { NextFunction, Request, Response } from 'express';

/**
 * Contexto de cada petición (ADR-0048): un id de correlación que viaja a los logs, a Sentry,
 * al outbox y, desde ahí, a los handlers del worker.
 */
interface RequestContext {
  requestId: string;
  userId?: string;
}

const storage = new AsyncLocalStorage<RequestContext>();

export const currentRequestId = (): string | undefined => storage.getStore()?.requestId;
export const currentUserId = (): string | undefined => storage.getStore()?.userId;

/** Lo llama la autenticación cuando ya sabe quién es. */
export function setContextUser(userId: string): void {
  const store = storage.getStore();
  if (store) store.userId = userId;
}

export function runWithRequestId<T>(requestId: string, fn: () => T): T {
  return storage.run({ requestId }, fn);
}

/** Un X-Request-Id entrante se respeta solo si tiene forma razonable (no se registra basura). */
const VALID = /^[\w.-]{8,64}$/;

export function requestIdMiddleware(req: Request, res: Response, next: NextFunction): void {
  const incoming = req.headers['x-request-id'];
  const requestId = typeof incoming === 'string' && VALID.test(incoming) ? incoming : randomUUID();
  res.setHeader('X-Request-Id', requestId);
  storage.run({ requestId }, next);
}
