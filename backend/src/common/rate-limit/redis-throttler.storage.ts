import { Injectable } from '@nestjs/common';
import type { ThrottlerStorage } from '@nestjs/throttler';
import type { ThrottlerStorageRecord } from '@nestjs/throttler/dist/throttler-storage-record.interface';
import { RateLimitStore } from './rate-limit.store';

/**
 * Storage de @nestjs/throttler en Redis (varias instancias comparten contadores).
 * Reemplaza a @nest-lab/throttler-storage-redis, que no soporta NestJS 12 (ADR-0010).
 */
@Injectable()
export class RedisThrottlerStorage implements ThrottlerStorage {
  constructor(private readonly store: RateLimitStore) {}

  async increment(
    key: string,
    ttl: number,
    limit: number,
    blockDuration: number,
    throttlerName: string,
  ): Promise<ThrottlerStorageRecord> {
    const hit = await this.store.hitWithBlock(
      `throttler:${throttlerName}:${key}`,
      ttl,
      limit,
      blockDuration > 0 ? blockDuration : ttl,
    );
    return {
      totalHits: hit.totalHits,
      timeToExpire: hit.ttlSec,
      isBlocked: hit.blocked,
      timeToBlockExpire: hit.blockTtlSec,
    };
  }
}
