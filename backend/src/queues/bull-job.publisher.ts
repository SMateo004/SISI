import { InjectQueue } from '@nestjs/bullmq';
import { Injectable } from '@nestjs/common';
import type { Queue } from 'bullmq';
import type { JobPublisher } from '../outbox/outbox-relay.core';
import { type JobRoute, QUEUES, type QueueName } from './queues';

/**
 * Encola jobs con jobId determinístico. BullMQ ignora un `add` cuyo jobId ya existe
 * (esperando, demorado, activo o completado y aún guardado): publicar dos veces es seguro.
 */
@Injectable()
export class BullJobPublisher implements JobPublisher {
  private readonly queues: Record<QueueName, Queue>;

  constructor(
    @InjectQueue(QUEUES.matching) matching: Queue,
    @InjectQueue(QUEUES.events) events: Queue,
  ) {
    this.queues = { [QUEUES.matching]: matching, [QUEUES.events]: events };
  }

  async publish(route: JobRoute): Promise<void> {
    await this.queues[route.queue].add(route.name, route.data, {
      jobId: route.jobId,
      ...(route.delayMs !== undefined ? { delay: route.delayMs } : {}),
    });
  }

  queue(name: QueueName): Queue {
    return this.queues[name];
  }
}
