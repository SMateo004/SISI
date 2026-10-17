import { createHash } from 'node:crypto';
import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../errors/api-error';
import type { Prisma } from '../../generated/prisma/client';

const KEY_FORMAT = /^[A-Za-z0-9_-]{8,100}$/;

/** Valida el header Idempotency-Key (obligatorio en las operaciones de dinero del admin). */
export function requireIdempotencyKey(value: string | undefined): string {
  if (!value) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'IDEMPOTENCY_KEY_REQUIRED',
      'Falta el header Idempotency-Key.',
    );
  }
  if (!KEY_FORMAT.test(value)) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'IDEMPOTENCY_KEY_INVALID',
      'Idempotency-Key debe tener de 8 a 100 caracteres: letras, números, "-" o "_".',
    );
  }
  return value;
}

/** JSON con las claves ordenadas: la misma petición da siempre la misma huella. */
function stableJson(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(stableJson).join(',')}]`;
  if (value && typeof value === 'object') {
    const entries = Object.entries(value as Record<string, unknown>)
      .filter(([, v]) => v !== undefined)
      .sort(([a], [b]) => a.localeCompare(b));
    return `{${entries.map(([k, v]) => `${JSON.stringify(k)}:${stableJson(v)}`).join(',')}}`;
  }
  return JSON.stringify(value);
}

/**
 * Ejecuta `work` una sola vez por (scope, clave), dentro de la misma transacción.
 * - La clave se inserta al empezar: un envío simultáneo con la misma clave espera en el
 *   índice único hasta que el primero confirma, y entonces recibe su respuesta.
 * - Si `work` falla, la transacción se revierte con la clave: se puede reintentar.
 * - La misma clave con otro cuerpo, o de otra persona, es un error (409).
 */
export async function withIdempotency<T>(
  tx: Prisma.TransactionClient,
  input: { scope: string; key: string; actorId: string; body: unknown },
  work: () => Promise<T>,
): Promise<{ result: T; replayed: boolean }> {
  const hash = createHash('sha256').update(stableJson(input.body)).digest('hex');
  const inserted = await tx.$executeRaw`
    INSERT INTO idempotency_keys (scope, key, actor_id, request_hash)
    VALUES (${input.scope}, ${input.key}, ${input.actorId}::uuid, ${hash})
    ON CONFLICT DO NOTHING`;
  if (inserted === 0) {
    const previous = await tx.idempotencyKey.findUniqueOrThrow({
      where: { scope_key: { scope: input.scope, key: input.key } },
    });
    if (previous.requestHash !== hash || previous.actorId !== input.actorId) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'IDEMPOTENCY_KEY_REUSED',
        'Esa Idempotency-Key ya se usó con otros datos.',
      );
    }
    if (previous.response === null) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'IDEMPOTENCY_IN_PROGRESS',
        'La operación con esa Idempotency-Key todavía se está procesando.',
      );
    }
    return { result: previous.response as T, replayed: true };
  }
  const result = await work();
  await tx.idempotencyKey.update({
    where: { scope_key: { scope: input.scope, key: input.key } },
    data: { response: result as Prisma.InputJsonValue },
  });
  return { result, replayed: false };
}
