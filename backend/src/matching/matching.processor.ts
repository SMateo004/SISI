import { InjectQueue, Processor, WorkerHost } from '@nestjs/bullmq';
import {
  type BeforeApplicationShutdown,
  Inject,
  Logger,
  type OnApplicationBootstrap,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Job, Queue } from 'bullmq';
import type { AppConfigService } from '../config/app-config';
import { WorkerAvailabilityService } from '../locations/worker-availability.service';
import { MATCHING_JOBS, QUEUES } from '../queues/queues';
import { JobAutoConfirmService } from '../jobs/job-autoconfirm.service';
import { OutboxCleanupService } from '../outbox/outbox-cleanup.service';
import { MatchingReconciler } from './matching.reconciler';
import { MatchingService } from './matching.service';

interface MatchingJobData {
  requestId?: string;
  ring?: number;
  /** Número de cierre/expiración (ADR-0025). */
  seq?: number;
  jobId?: string;
}

/** Cola de matching (ADR-0022, ADR-0025): anillos, cierre, expiración y mantenimiento. */
@Processor(QUEUES.matching)
export class MatchingProcessor
  extends WorkerHost
  implements OnApplicationBootstrap, BeforeApplicationShutdown
{
  private readonly logger = new Logger('Matching');

  constructor(
    private readonly matching: MatchingService,
    private readonly reconciler: MatchingReconciler,
    private readonly availability: WorkerAvailabilityService,
    private readonly outboxCleanup: OutboxCleanupService,
    private readonly autoConfirm: JobAutoConfirmService,
    @InjectQueue(QUEUES.matching) private readonly queue: Queue,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {
    super();
  }

  /** Jobs repetibles (uno solo aunque haya varias instancias del worker). */
  async onApplicationBootstrap(): Promise<void> {
    await this.queue.upsertJobScheduler(
      MATCHING_JOBS.reconcile,
      { every: this.config.get('MATCHING_RECONCILE_MS', { infer: true }) },
      { name: MATCHING_JOBS.reconcile },
    );
    await this.queue.upsertJobScheduler(
      MATCHING_JOBS.sweepLocations,
      { every: this.config.get('LOCATION_SWEEP_MS', { infer: true }) },
      { name: MATCHING_JOBS.sweepLocations },
    );
    await this.queue.upsertJobScheduler(
      MATCHING_JOBS.outboxCleanup,
      { every: this.config.get('OUTBOX_CLEANUP_MS', { infer: true }) },
      { name: MATCHING_JOBS.outboxCleanup },
    );
  }

  /** Termina los jobs en curso antes de que se cierren Postgres y Redis. */
  async beforeApplicationShutdown(): Promise<void> {
    await this.worker.close();
  }

  async process(job: Job<MatchingJobData>): Promise<unknown> {
    const { requestId, ring, seq = 0, jobId } = job.data;
    switch (job.name) {
      case MATCHING_JOBS.ring:
        if (!requestId || !ring) break;
        return (await this.matching.runRing(requestId, ring)).kind;
      case MATCHING_JOBS.close:
        if (!requestId) break;
        return (await this.matching.close(requestId, seq)).kind;
      case MATCHING_JOBS.expire:
        if (!requestId) break;
        return this.matching.expire(requestId, seq);
      case MATCHING_JOBS.reconcile:
        await this.autoConfirm.sweepDue();
        return this.reconciler.runOnce();
      case MATCHING_JOBS.sweepLocations:
        return this.availability.sweepStale();
      case MATCHING_JOBS.outboxCleanup:
        return this.outboxCleanup.runOnce();
      case MATCHING_JOBS.autoconfirm:
        if (!jobId) break;
        return this.autoConfirm.confirmIfDue(jobId);
    }
    this.logger.warn(`Job de matching inválido: ${job.name} ${JSON.stringify(job.data)}`);
    return undefined;
  }
}
