import { Module } from '@nestjs/common';
import { QueuesModule } from '../queues/queues.module';
import { EventHandlersRegistry } from './event-handlers.registry';
import { EventsProcessor } from './events.processor';
import { OutboxCleanupService } from './outbox-cleanup.service';
import { OutboxRelay } from './outbox.relay';
import { PrismaOutboxStore } from './prisma-outbox.store';

/** Relay del outbox y cola de eventos: solo en el proceso worker (ADR-0022). */
@Module({
  imports: [QueuesModule],
  providers: [
    PrismaOutboxStore,
    OutboxRelay,
    EventHandlersRegistry,
    EventsProcessor,
    OutboxCleanupService,
  ],
  exports: [OutboxRelay, EventHandlersRegistry, OutboxCleanupService],
})
export class OutboxRelayModule {}
