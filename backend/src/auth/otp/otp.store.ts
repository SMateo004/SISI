import { Inject, Injectable } from '@nestjs/common';
import type { Redis } from 'ioredis';
import { REDIS_CLIENT } from '../../redis/redis.constants';

export type OtpCheck = 'ok' | 'expired' | 'invalid' | 'exhausted';

/** Persistencia del código pendiente de un teléfono (solo el hash y los intentos). */
export interface OtpStore {
  save(phoneKey: string, codeHash: string, ttlSec: number): Promise<void>;
  /** Compara y cuenta el intento de forma atómica; borra el código si acierta o se agota. */
  check(phoneKey: string, codeHash: string, maxAttempts: number): Promise<OtpCheck>;
  delete(phoneKey: string): Promise<void>;
}

export const OTP_STORE = Symbol('OTP_STORE');

const CHECK_LUA = `
local stored = redis.call('HGET', KEYS[1], 'hash')
if not stored then return 0 end
if stored == ARGV[1] then
  redis.call('DEL', KEYS[1])
  return 1
end
local attempts = redis.call('HINCRBY', KEYS[1], 'attempts', 1)
if attempts >= tonumber(ARGV[2]) then
  redis.call('DEL', KEYS[1])
  return -2
end
return -1
`;

const RESULTS: Record<number, OtpCheck> = {
  1: 'ok',
  0: 'expired',
  [-1]: 'invalid',
  [-2]: 'exhausted',
};

@Injectable()
export class RedisOtpStore implements OtpStore {
  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async save(phoneKey: string, codeHash: string, ttlSec: number): Promise<void> {
    const key = this.key(phoneKey);
    // Un código nuevo reemplaza al anterior y reinicia los intentos.
    await this.redis
      .multi()
      .del(key)
      .hset(key, { hash: codeHash, attempts: 0 })
      .expire(key, ttlSec)
      .exec();
  }

  async check(phoneKey: string, codeHash: string, maxAttempts: number): Promise<OtpCheck> {
    const result = (await this.redis.eval(
      CHECK_LUA,
      1,
      this.key(phoneKey),
      codeHash,
      maxAttempts,
    )) as number;
    return RESULTS[result] ?? 'invalid';
  }

  async delete(phoneKey: string): Promise<void> {
    await this.redis.del(this.key(phoneKey));
  }

  private key(phoneKey: string): string {
    return `otp:${phoneKey}`;
  }
}
