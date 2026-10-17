import { Module } from '@nestjs/common';
import { BillingCoreModule } from '../billing/billing-core.module';
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
  ],
  providers: [
    RequestEventsHandlers,
    RequestNotificationsHandlers,
    OfferEventsHandlers,
    JobEventsHandlers,
    ChatEventsHandlers,
    BillingEventsHandlers,
  ],
})
export class WorkerModule {}
