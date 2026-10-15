import { BullModule } from '@nestjs/bullmq';
import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { BullJobPublisher } from './bull-job.publisher';
import { QUEUES } from './queues';

/**
 * Colas BullMQ (ADR-0022). Solo las importa el proceso worker (y los e2e que lo levantan
 * en el mismo proceso): la API escribe en el outbox y no encola directamente.
 */
@Module({
  imports: [
    BullModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: AppConfigService) => {
        // Opciones (no una instancia) para que BullMQ abra y cierre sus conexiones.
        // maxRetriesPerRequest: null lo exige BullMQ para los workers.
        const connection: { url: string; maxRetriesPerRequest: null } = {
          url: config.get('REDIS_URL', { infer: true }),
          maxRetriesPerRequest: null,
        };
        return {
          connection,
          prefix: config.get('QUEUE_PREFIX', { infer: true }),
          defaultJobOptions: {
            // Se guardan para que un jobId repetido no vuelva a correr (idempotencia).
            removeOnComplete: { age: config.get('QUEUE_KEEP_COMPLETED_SEC', { infer: true }) },
            removeOnFail: { age: 7 * 24 * 3600 },
            attempts: 5,
            backoff: { type: 'exponential', delay: 1000 },
          },
        };
      },
    }),
    BullModule.registerQueue({ name: QUEUES.matching }, { name: QUEUES.events }),
  ],
  providers: [BullJobPublisher],
  exports: [BullModule, BullJobPublisher],
})
export class QueuesModule {}
