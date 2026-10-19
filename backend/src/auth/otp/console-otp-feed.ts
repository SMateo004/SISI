import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../../config/app-config';
import { REDIS_CLIENT } from '../../redis/redis.constants';

/**
 * Fuera del espacio `otp:*` del OTP real, que solo guarda hashes (ADR-0009): esta es la única
 * copia en claro, y solo existe con el proveedor de consola (ADR-0056).
 */
export const CONSOLE_OTP_FEED_KEY = 'console-otp:feed';
const FEED_KEY = CONSOLE_OTP_FEED_KEY;

export interface ConsoleOtpEntry {
  phone: string;
  code: string;
  sentAt: string;
  expiresAt: string;
  usedAt: string | null;
}

/**
 * Códigos del OTP por consola visibles en el panel (ADR-0056), para probar staging sin SMS.
 * Solo existe mientras OTP_PROVIDER=console y nunca con APP_ENV=production: en ese caso no
 * guarda ni devuelve nada. Cada código queda hasta que vence (OTP_TTL_SEC); al usarse se marca.
 */
@Injectable()
export class ConsoleOtpFeed {
  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  get enabled(): boolean {
    return (
      this.config.get('OTP_PROVIDER', { infer: true }) === 'console' &&
      this.config.get('APP_ENV', { infer: true }) !== 'production'
    );
  }

  async record(phone: string, code: string, ttlSec: number, now = new Date()): Promise<void> {
    if (!this.enabled) return;
    const entry: ConsoleOtpEntry = {
      phone,
      code,
      sentAt: now.toISOString(),
      expiresAt: new Date(now.getTime() + ttlSec * 1000).toISOString(),
      usedAt: null,
    };
    await this.redis
      .multi()
      .hset(FEED_KEY, phone, JSON.stringify(entry))
      .expire(FEED_KEY, Math.max(ttlSec, 60) * 2)
      .exec();
  }

  async markUsed(phone: string, now = new Date()): Promise<void> {
    if (!this.enabled) return;
    const raw = await this.redis.hget(FEED_KEY, phone);
    if (!raw) return;
    const entry = JSON.parse(raw) as ConsoleOtpEntry;
    await this.redis.hset(FEED_KEY, phone, JSON.stringify({ ...entry, usedAt: now.toISOString() }));
  }

  /** Vigentes, el más reciente primero. Los vencidos se borran al leer. */
  async list(now = new Date()): Promise<ConsoleOtpEntry[]> {
    if (!this.enabled) return [];
    const all = await this.redis.hgetall(FEED_KEY);
    const live: ConsoleOtpEntry[] = [];
    const expired: string[] = [];
    for (const [phone, raw] of Object.entries(all)) {
      const entry = JSON.parse(raw) as ConsoleOtpEntry;
      if (Date.parse(entry.expiresAt) <= now.getTime()) expired.push(phone);
      else live.push(entry);
    }
    if (expired.length > 0) await this.redis.hdel(FEED_KEY, ...expired);
    return live.sort((a, b) => b.sentAt.localeCompare(a.sentAt));
  }
}
