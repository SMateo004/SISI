import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { REDIS_CLIENT } from '../redis/redis.constants';

export type OpsMetric = 'otp_fail' | 'push_sent' | 'push_fail';

/**
 * Contadores de fallos para las alertas (ADR-0048): ventanas fijas en Redis, compartidas por
 * todas las instancias de la API y del worker. El monitor suma la ventana actual y la anterior.
 */
@Injectable()
export class OpsMetrics {
  private readonly windowMs: number;

  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.windowMs = config.get('OPS_WINDOW_MS', { infer: true });
  }

  private key(metric: OpsMetric, bucket: number): string {
    return `ops:${metric}:${String(bucket)}`;
  }

  /** Nunca falla hacia afuera: una métrica no debe romper un login ni un aviso. */
  async count(metric: OpsMetric, n = 1, now = Date.now()): Promise<void> {
    if (n <= 0) return;
    const key = this.key(metric, Math.floor(now / this.windowMs));
    try {
      await this.redis
        .multi()
        .incrby(key, n)
        .pexpire(key, this.windowMs * 3)
        .exec();
    } catch {
      // Redis caído: lo detecta /health.
    }
  }

  async recent(metric: OpsMetric, now = Date.now()): Promise<number> {
    const bucket = Math.floor(now / this.windowMs);
    const values = await this.redis.mget(this.key(metric, bucket), this.key(metric, bucket - 1));
    return values.reduce((sum, v) => sum + Number(v ?? 0), 0);
  }
}
