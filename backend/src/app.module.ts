import { Module } from '@nestjs/common';
import { APP_FILTER, APP_GUARD } from '@nestjs/core';
import { AdminUsersModule } from './admin-users/admin-users.module';
import { AuditModule } from './audit/audit.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { SettingsAdminModule } from './settings/settings-admin.module';
import { SettingsModule } from './settings/settings.module';
import { ModerationAdminModule } from './moderation/moderation-admin.module';
import { VerificationsModule } from './verifications/verifications.module';
import { AuthModule } from './auth/auth.module';
import { AdminGuard } from './common/admin/admin.guard';
import { BillingModule } from './billing/billing.module';
import { ChatModule } from './chat/chat.module';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { RolesGuard } from './auth/guards/roles.guard';
import { RateLimitGuard, UserRateLimitGuard } from './common/rate-limit/rate-limit.guard';
import { RateLimitModule } from './common/rate-limit/rate-limit.module';
import { RateLimitedFilter } from './common/rate-limit/rate-limited.filter';
import { SisiThrottlerGuard } from './common/rate-limit/sisi-throttler.guard';
import { SentryExceptionFilter } from './observability/sentry-exception.filter';
import { AppConfigModule } from './config/config.module';
import { FeatureFlagsModule } from './feature-flags/feature-flags.module';
import { HealthModule } from './health/health.module';
import { JobsModule } from './jobs/jobs.module';
import { LocationsModule } from './locations/locations.module';
import { MapsModule } from './maps/maps.module';
import { ModerationModule } from './moderation/moderation.module';
import { NotificationsModule } from './notifications/notifications.module';
import { OffersModule } from './offers/offers.module';
import { OutboxModule } from './outbox/outbox.module';
import { PrismaModule } from './prisma/prisma.module';
import { RealtimeEmitterModule, RealtimeModule } from './realtime/realtime.module';
import { RedisModule } from './redis/redis.module';
import { ReportsModule } from './reports/reports.module';
import { RequestsModule } from './requests/requests.module';
import { ReviewsModule } from './reviews/reviews.module';
import { StorageModule } from './storage/storage.module';
import { UsersModule } from './users/users.module';
import { WorkersModule } from './workers/workers.module';

@Module({
  imports: [
    AppConfigModule,
    // Eventos de dominio por outbox transaccional (ADR-0022).
    OutboxModule,
    PrismaModule,
    RedisModule,
    RateLimitModule,
    // Auditoría del panel (global, ADR-0041).
    AuditModule,
    // Parámetros de negocio (global, ADR-0043).
    SettingsModule,
    SettingsAdminModule,
    StorageModule,
    FeatureFlagsModule,
    HealthModule,
    UsersModule,
    AuthModule,
    WorkersModule,
    ModerationModule,
    ModerationAdminModule,
    RequestsModule,
    MapsModule,
    LocationsModule,
    NotificationsModule,
    OffersModule,
    JobsModule,
    ChatModule,
    ReviewsModule,
    ReportsModule,
    BillingModule,
    AdminUsersModule,
    VerificationsModule,
    DashboardModule,
    RealtimeModule,
    RealtimeEmitterModule,
  ],
  providers: [
    // Orden: límites por IP antes que la autenticación (frena fuerza bruta sin tocar la BD).
    { provide: APP_GUARD, useClass: SisiThrottlerGuard },
    { provide: APP_GUARD, useExisting: RateLimitGuard },
    { provide: APP_GUARD, useExisting: JwtAuthGuard },
    { provide: APP_GUARD, useExisting: RolesGuard },
    // Límites por usuario (@RateLimit con per: 'user'), ya con la sesión resuelta (ADR-0047).
    { provide: APP_GUARD, useExisting: UserRateLimitGuard },
    // Permiso del área y límites por admin en las rutas del panel (ADR-0040).
    { provide: APP_GUARD, useClass: AdminGuard },
    // Orden: Nest prueba los filtros globales del último al primero; el de Sentry (todo) va
    // antes para que RateLimitedFilter conserve su 429 con Retry-After (ADR-0048).
    { provide: APP_FILTER, useClass: SentryExceptionFilter },
    { provide: APP_FILTER, useClass: RateLimitedFilter },
  ],
})
export class AppModule {}
