import { Module } from '@nestjs/common';
import { APP_FILTER, APP_GUARD } from '@nestjs/core';
import { AuthModule } from './auth/auth.module';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { RolesGuard } from './auth/guards/roles.guard';
import { RateLimitGuard } from './common/rate-limit/rate-limit.guard';
import { RateLimitModule } from './common/rate-limit/rate-limit.module';
import { RateLimitedFilter } from './common/rate-limit/rate-limited.filter';
import { SisiThrottlerGuard } from './common/rate-limit/sisi-throttler.guard';
import { AppConfigModule } from './config/config.module';
import { HealthModule } from './health/health.module';
import { PrismaModule } from './prisma/prisma.module';
import { RedisModule } from './redis/redis.module';
import { StorageModule } from './storage/storage.module';
import { UsersModule } from './users/users.module';
import { WorkersModule } from './workers/workers.module';

@Module({
  imports: [
    AppConfigModule,
    PrismaModule,
    RedisModule,
    RateLimitModule,
    StorageModule,
    HealthModule,
    UsersModule,
    AuthModule,
    WorkersModule,
  ],
  providers: [
    // Orden: límites por IP antes que la autenticación (frena fuerza bruta sin tocar la BD).
    { provide: APP_GUARD, useClass: SisiThrottlerGuard },
    { provide: APP_GUARD, useExisting: RateLimitGuard },
    { provide: APP_GUARD, useExisting: JwtAuthGuard },
    { provide: APP_GUARD, useExisting: RolesGuard },
    { provide: APP_FILTER, useClass: RateLimitedFilter },
  ],
})
export class AppModule {}
