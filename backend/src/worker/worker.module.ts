import { Module } from '@nestjs/common';
import { AppConfigModule } from '../config/config.module';
import { MatchingWorkerModule } from '../matching/matching-worker.module';
import { NotificationsCoreModule } from '../notifications/notifications.module';
import { RequestNotificationsHandlers } from '../notifications/request-notifications.handlers';
import { OutboxRelayModule } from '../outbox/outbox-relay.module';
import { OutboxModule } from '../outbox/outbox.module';
import { PrismaModule } from '../prisma/prisma.module';
import { RealtimeEmitterModule } from '../realtime/realtime.module';
import { RedisModule } from '../redis/redis.module';
import { RequestEventsHandlers } from '../requests/request-events.handlers';

/**
 * Proceso worker (Render Background Worker): relay del outbox, cola de eventos y
 * jobs de matching con BullMQ (ADR-0022).
 */
@Module({
  imports: [
    AppConfigModule,
    PrismaModule,
    RedisModule,
    OutboxModule,
    OutboxRelayModule,
    MatchingWorkerModule,
    RealtimeEmitterModule,
    NotificationsCoreModule,
  ],
  providers: [RequestEventsHandlers, RequestNotificationsHandlers],
})
export class WorkerModule {}
