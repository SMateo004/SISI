import { AccountDeletionHandlers } from '../account-deletion/account-deletion.handlers';
import { AuditModule } from '../audit/audit.module';
import { StorageModule } from '../storage/storage.module';
import { ObservabilityModule } from '../observability/observability.module';
import { OpsMonitor } from '../observability/ops-monitor';
import { AdminCountersPublisher } from '../dashboard/admin-counters.publisher';
import { DashboardModule } from '../dashboard/dashboard.module';
import { SettingsModule } from '../settings/settings.module';
import { AccountNotificationsHandlers } from '../notifications/account-notifications.handlers';
import { Module } from '@nestjs/common';
import { BillingCoreModule } from '../billing/billing-core.module';
import { BillingCapModule } from '../billing/billing-cap.module';
import { BillingDebtModule } from '../billing/billing-debt.module';
import { BillingEventsHandlers } from '../billing/billing-events.handlers';
import { ChatEventsHandlers } from '../chat/chat-events.handlers';
import { AppConfigModule } from '../config/config.module';
import { FeatureFlagsModule } from '../feature-flags/feature-flags.module';
import { JobEventsHandlers } from '../jobs/job-events.handlers';
import { JobStatusModule } from '../jobs/job-status.module';
import { MatchingWorkerModule } from '../matching/matching-worker.module';
import { NotificationsCoreModule } from '../notifications/notifications.module';
import { RequestNotificationsHandlers } from '../notifications/request-notifications.handlers';
import { OfferEventsHandlers } from '../offers/offer-events.handlers';
import { OutboxRelayModule } from '../outbox/outbox-relay.module';
import { OutboxModule } from '../outbox/outbox.module';
import { PrismaModule } from '../prisma/prisma.module';
import { QueuesModule } from '../queues/queues.module';
import { RealtimeEmitterModule } from '../realtime/realtime.module';
import { RedisModule } from '../redis/redis.module';
import { RequestEventsHandlers } from '../requests/request-events.handlers';
import { RequestStatusModule } from '../requests/request-status.module';

/**
 * Proceso worker (Render Background Worker): relay del outbox, cola de eventos, jobs de
 * matching con BullMQ y avisos (ADR-0022, ADR-0025, ADR-0027).
 */
@Module({
  imports: [
    AppConfigModule,
    PrismaModule,
    RedisModule,
    // Los módulos compartidos con la API pueden auditar acciones del panel (ADR-0041).
    AuditModule,
    SettingsModule,
    DashboardModule,
    FeatureFlagsModule,
    OutboxModule,
    OutboxRelayModule,
    MatchingWorkerModule,
    RealtimeEmitterModule,
    NotificationsCoreModule,
    QueuesModule,
    RequestStatusModule,
    JobStatusModule,
    BillingCoreModule,
    BillingDebtModule,
    BillingCapModule,
    ObservabilityModule,
    // Borra archivos de cuentas eliminadas y de la retención (ADR-0049, ADR-0050).
    StorageModule,
  ],
  providers: [
    RequestEventsHandlers,
    RequestNotificationsHandlers,
    OfferEventsHandlers,
    JobEventsHandlers,
    ChatEventsHandlers,
    BillingEventsHandlers,
    AccountNotificationsHandlers,
    AdminCountersPublisher,
    // Alertas de outbox, colas, OTP y push, y latido del worker (ADR-0048).
    OpsMonitor,
    AccountDeletionHandlers,
  ],
})
export class WorkerModule {}
