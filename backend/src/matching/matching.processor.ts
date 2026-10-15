import { InjectQueue, Processor, WorkerHost } from '@nestjs/bullmq';
import { Inject, Logger, type OnApplicationBootstrap } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Job, Queue } from 'bullmq';
import type { AppConfigService } from '../config/app-config';
import { MATCHING_JOBS, QUEUES } from '../queues/queues';
import { MatchingReconciler } from './matching.reconciler';

/** Cola de matching (ADR-0022, ADR-0025): anillos y reconciliador. */
@Processor(QUEUES.matching)
export class MatchingProcessor extends WorkerHost implements OnApplicationBootstrap {
  private readonly logger = new Logger('Matching');

  constructor(
    private readonly reconciler: MatchingReconciler,
    @InjectQueue(QUEUES.matching) private readonly queue: Queue,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {
    super();
  }

  /** Programa el reconciliador como job repetible (uno solo aunque haya varias instancias). */
  async onApplicationBootstrap(): Promise<void> {
    await this.queue.upsertJobScheduler(
      MATCHING_JOBS.reconcile,
      { every: this.config.get('MATCHING_RECONCILE_MS', { infer: true }) },
      { name: MATCHING_JOBS.reconcile },
    );
  }

  async process(job: Job<{ requestId?: string; ring?: number }>): Promise<unknown> {
    switch (job.name) {
      case MATCHING_JOBS.reconcile:
        return this.reconciler.runOnce();
      case MATCHING_JOBS.ring:
        // Los anillos llegan en el commit de matching; hasta entonces solo se registra.
        this.logger.log(`Solicitud ${job.data.requestId ?? '?'}: anillo ${job.data.ring ?? '?'}`);
        return undefined;
      default:
        this.logger.warn(`Job de matching desconocido: ${job.name}`);
        return undefined;
    }
  }
}
