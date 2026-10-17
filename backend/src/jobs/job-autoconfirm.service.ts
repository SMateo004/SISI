import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { JobTransitionError } from './job-status.machine';
import { JobStatusService } from './job-status.service';

/**
 * Autoconfirmación (ADR-0029): pasado JOB_AUTOCONFIRM_MS desde que el trabajador marcó
 * "Terminé", sin confirmación ni disputa, el sistema confirma. La dispara un job demorado
 * de BullMQ (`autoconfirm_{jobId}`) y, como respaldo, el reconciliador barre los vencidos.
 * Idempotente: un trabajo ya terminado o en disputa se ignora.
 */
@Injectable()
export class JobAutoConfirmService {
  private readonly logger = new Logger('JobAutoConfirm');
  readonly delayMs: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly status: JobStatusService,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.delayMs = config.get('JOB_AUTOCONFIRM_MS', { infer: true });
  }

  async confirmIfDue(jobId: string): Promise<'confirmed' | 'skipped' | 'not_due'> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      select: { workerFinishedAt: true },
    });
    if (!job?.workerFinishedAt) return 'skipped';
    if (job.workerFinishedAt.getTime() + this.delayMs > Date.now()) return 'not_due';
    try {
      await this.status.apply(jobId, 'AUTO_CONFIRM', { role: 'system', id: null });
      return 'confirmed';
    } catch (err) {
      if (err instanceof JobTransitionError) return 'skipped';
      throw err;
    }
  }

  /** Respaldo: confirma los vencidos cuyo job demorado se perdió. Devuelve cuántos. */
  async sweepDue(): Promise<number> {
    const due = await this.prisma.job.findMany({
      where: {
        status: 'en_curso',
        disputedAt: null,
        workerFinishedAt: { lte: new Date(Date.now() - this.delayMs) },
      },
      select: { id: true },
      take: 100,
    });
    let confirmed = 0;
    for (const { id } of due) {
      if ((await this.confirmIfDue(id)) === 'confirmed') confirmed += 1;
    }
    if (confirmed > 0) this.logger.log(`Autoconfirmados por barrido: ${confirmed}`);
    return confirmed;
  }
}
