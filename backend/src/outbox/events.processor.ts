import { Processor, WorkerHost } from '@nestjs/bullmq';
import { type BeforeApplicationShutdown, Logger } from '@nestjs/common';
import type { Job } from 'bullmq';
import { QUEUES } from '../queues/queues';
import { type DomainEvent, EventHandlersRegistry } from './event-handlers.registry';
import type { OutboxEventType } from './outbox.events';

/** Consume la cola de eventos y llama a los handlers registrados para su tipo. */
@Processor(QUEUES.events)
export class EventsProcessor extends WorkerHost implements BeforeApplicationShutdown {
  private readonly logger = new Logger('EventsProcessor');

  constructor(private readonly registry: EventHandlersRegistry) {
    super();
  }

  /** Termina los eventos en curso antes de que se cierren Postgres y Redis. */
  async beforeApplicationShutdown(): Promise<void> {
    await this.worker.close();
  }

  async process(job: Job<DomainEvent<OutboxEventType>>): Promise<void> {
    const handled = await this.registry.dispatch(job.name, job.data);
    if (handled === 0) this.logger.warn(`Evento ${job.name} sin handlers (job ${job.id ?? '?'})`);
  }
}
