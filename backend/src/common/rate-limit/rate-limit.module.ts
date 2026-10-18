import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import type { AppConfigService } from '../../config/app-config';
import { RateLimitGuard, UserRateLimitGuard } from './rate-limit.guard';
import { RateLimitStore } from './rate-limit.store';
import { RedisThrottlerStorage } from './redis-throttler.storage';

@Module({
  providers: [RateLimitStore, RedisThrottlerStorage],
  exports: [RateLimitStore, RedisThrottlerStorage],
})
class RateLimitStorageModule {}

/**
 * Límites en Redis (ADR-0010):
 * - Límite global por IP para toda la API (@nestjs/throttler + RedisThrottlerStorage).
 * - Políticas por endpoint con @RateLimit() (RateLimitGuard).
 * - Límites por clave de dominio (p. ej. teléfono) inyectando RateLimitStore.
 * Los guards se registran como APP_GUARD en AppModule.
 */
@Global()
@Module({
  imports: [
    RateLimitStorageModule,
    ThrottlerModule.forRootAsync({
      imports: [RateLimitStorageModule],
      inject: [ConfigService, RedisThrottlerStorage],
      useFactory: (config: AppConfigService, storage: RedisThrottlerStorage) => ({
        throttlers: [
          {
            name: 'global',
            ttl: 60_000,
            limit: config.get('RATE_GLOBAL_IP_PER_MIN', { infer: true }),
          },
        ],
        storage,
      }),
    }),
  ],
  providers: [RateLimitGuard, UserRateLimitGuard],
  exports: [RateLimitStorageModule, RateLimitGuard, UserRateLimitGuard, ThrottlerModule],
})
export class RateLimitModule {}
