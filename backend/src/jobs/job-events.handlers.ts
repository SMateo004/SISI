import { Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { NotificationsService } from '../notifications/notifications.service';
import { shortName } from '../offers/offer.rules';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { BullJobPublisher } from '../queues/bull-job.publisher';
import { jobIds, MATCHING_JOBS, QUEUES } from '../queues/queues';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { netOf } from './commission';
import { JobAutoConfirmService } from './job-autoconfirm.service';

/**
 * Efectos de los cambios de un trabajo en el worker (ADR-0029): job:status a las dos
 * partes, aviso a la contraparte de quien actuó y la autoconfirmación demorada.
 * Idempotente: los avisos se deduplican por outboxId y los jobs por jobId.
 */
@Injectable()
export class JobEventsHandlers implements OnModuleInit {
  private readonly logger = new Logger('JobEvents');

  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly prisma: PrismaService,
    private readonly realtime: RealtimeEmitter,
    private readonly notifications: NotificationsService,
    private readonly publisher: BullJobPublisher,
    private readonly autoConfirm: JobAutoConfirmService,
  ) {}

  onModuleInit(): void {
    this.registry.on('job.status_changed', async ({ outboxId, payload }) => {
      const job = await this.prisma.job.findUniqueOrThrow({
        where: { id: payload.jobId },
        include: { worker: { select: { name: true } } },
      });
      this.realtime.toUsers([job.employerId, job.workerId], 'job:status', {
        jobId: job.id,
        requestId: job.requestId,
        status: job.status,
        action: payload.action,
      });

      const queue = this.publisher.queue(QUEUES.matching);
      if (payload.action === 'FINISH') {
        await this.publisher.publish({
          queue: QUEUES.matching,
          name: MATCHING_JOBS.autoconfirm,
          jobId: jobIds.autoconfirm(job.id),
          data: { jobId: job.id },
          delayMs: this.autoConfirm.delayMs,
        });
      } else if (payload.action === 'DISPUTE' || payload.to !== 'en_curso') {
        // Con disputa o ya cerrado no hay nada que autoconfirmar (el job lo ignoraría igual).
        await queue.remove(jobIds.autoconfirm(job.id)).catch((err: unknown) => {
          this.logger.warn(`No se pudo quitar la autoconfirmación de ${job.id}: ${String(err)}`);
        });
      }

      const worker = shortName(job.worker.name);
      const toEmployer = { userId: job.employerId, cityId: job.cityId };
      const toWorker = { userId: job.workerId, cityId: job.cityId };
      const key = (userId: string): string => `${outboxId}:${userId}`;
      switch (payload.action) {
        case 'START_TRIP':
          await this.notifications.notify({
            ...toEmployer,
            type: 'job_on_the_way',
            data: { jobId: job.id, workerShortName: worker },
            dedupeKey: key(job.employerId),
          });
          break;
        case 'START_WORK':
          await this.notifications.notify({
            ...toEmployer,
            type: 'job_started',
            data: { jobId: job.id, workerShortName: worker },
            dedupeKey: key(job.employerId),
          });
          break;
        case 'FINISH':
          await this.notifications.notify({
            ...toEmployer,
            type: 'job_finished',
            data: { jobId: job.id, workerShortName: worker },
            dedupeKey: key(job.employerId),
          });
          break;
        case 'CONFIRM':
        case 'AUTO_CONFIRM': {
          const commission = job.commissionBs;
          if (!commission) break;
          await this.notifications.notify({
            ...toWorker,
            type: 'job_completed',
            data: {
              jobId: job.id,
              netBs: netOf(job.finalPriceBs, commission).toFixed(2),
              commissionBs: commission.toFixed(2),
              auto: payload.action === 'AUTO_CONFIRM',
            },
            dedupeKey: key(job.workerId),
          });
          break;
        }
        case 'DISPUTE':
          await this.notifications.notify({
            ...toWorker,
            type: 'job_disputed',
            data: { jobId: job.id },
            dedupeKey: key(job.workerId),
          });
          break;
        case 'RESOLVE_CONFIRM':
        case 'RESOLVE_CANCEL':
          for (const party of [toEmployer, toWorker]) {
            await this.notifications.notify({
              ...party,
              type: 'job_resolved',
              data: { jobId: job.id, status: job.status },
              dedupeKey: key(party.userId),
            });
          }
          break;
      }
    });
  }
}
