import { Inject, Injectable } from '@nestjs/common';
import type { Redis } from 'ioredis';
import { REDIS_CLIENT } from '../../redis/redis.constants';

/** Una regla de ventana fija: como máximo `limit` eventos cada `windowSec` segundos. */
export interface RateRule {
  key: string;
  limit: number;
  windowSec: number;
}

export type RateDecision =
  { allowed: true } | { allowed: false; rule: RateRule; retryAfterSec: number };

export interface BlockingHit {
  totalHits: number;
  ttlSec: number;
  blocked: boolean;
  blockTtlSec: number;
}

const KEY_PREFIX = 'rl:';

/**
 * Revisa todas las reglas y, solo si ninguna está agotada, incrementa todos los
 * contadores. Atómico: un intento rechazado no consume cupo de las demás reglas.
 * Devuelve {1} si pasa o {0, índice de la regla, pttl} si no.
 */
const CONSUME_LUA = `
for i = 1, #KEYS do
  local limit = tonumber(ARGV[(i - 1) * 2 + 1])
  local current = tonumber(redis.call('GET', KEYS[i]) or '0')
  if current >= limit then
    return {0, i, redis.call('PTTL', KEYS[i])}
  end
end
for i = 1, #KEYS do
  local windowMs = tonumber(ARGV[(i - 1) * 2 + 2])
  if redis.call('INCR', KEYS[i]) == 1 then
    redis.call('PEXPIRE', KEYS[i], windowMs)
  end
end
return {1, 0, 0}
`;

/**
 * Contador con bloqueo (semántica de @nestjs/throttler): al pasar el límite se
 * crea una clave de bloqueo que dura blockMs. Devuelve {hits, pttl, bloqueado, pttlBloqueo}.
 */
const HIT_WITH_BLOCK_LUA = `
local blockTtl = redis.call('PTTL', KEYS[2])
if blockTtl > 0 then
  local hits = tonumber(redis.call('GET', KEYS[1]) or '0')
  return {hits, redis.call('PTTL', KEYS[1]), 1, blockTtl}
end
local hits = redis.call('INCR', KEYS[1])
if hits == 1 then
  redis.call('PEXPIRE', KEYS[1], ARGV[1])
end
local ttl = redis.call('PTTL', KEYS[1])
if hits > tonumber(ARGV[2]) then
  redis.call('SET', KEYS[2], '1', 'PX', ARGV[3])
  return {hits, ttl, 1, tonumber(ARGV[3])}
end
return {hits, ttl, 0, 0}
`;

const toSec = (ms: number): number => Math.max(1, Math.ceil(ms / 1000));

/**
 * Almacenamiento de límites en Redis, compartido por todas las instancias (ADR-0010).
 * Base de RedisThrottlerStorage, de @RateLimit y de límites por clave de dominio
 * (p. ej. por teléfono). Reutilizable en fases siguientes: solo se agregan reglas.
 */
@Injectable()
export class RateLimitStore {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async consume(rules: readonly RateRule[]): Promise<RateDecision> {
    if (rules.length === 0) return { allowed: true };
    const keys = rules.map((r) => KEY_PREFIX + r.key);
    const args = rules.flatMap((r) => [r.limit, r.windowSec * 1000]);
    const [ok, index, pttl] = (await this.redis.eval(
      CONSUME_LUA,
      keys.length,
      ...keys,
      ...args,
    )) as [number, number, number];
    if (ok === 1) return { allowed: true };
    const rule = rules[index - 1];
    if (!rule) throw new Error('RateLimitStore: índice de regla inesperado');
    return { allowed: false, rule, retryAfterSec: toSec(pttl > 0 ? pttl : rule.windowSec * 1000) };
  }

  async hitWithBlock(
    key: string,
    ttlMs: number,
    limit: number,
    blockMs: number,
  ): Promise<BlockingHit> {
    const [hits, pttl, blocked, blockPttl] = (await this.redis.eval(
      HIT_WITH_BLOCK_LUA,
      2,
      `${KEY_PREFIX}${key}`,
      `${KEY_PREFIX}${key}:block`,
      ttlMs,
      limit,
      blockMs,
    )) as [number, number, number, number];
    return {
      totalHits: hits,
      ttlSec: toSec(pttl),
      blocked: blocked === 1,
      blockTtlSec: blocked === 1 ? toSec(blockPttl) : 0,
    };
  }

  /** Borra los contadores de una clave (p. ej. tras un login exitoso). */
  async reset(...keys: string[]): Promise<void> {
    if (keys.length > 0) await this.redis.del(...keys.map((k) => KEY_PREFIX + k));
  }
}
