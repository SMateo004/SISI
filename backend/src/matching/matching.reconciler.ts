import { Inject, Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { BullJobPublisher } from '../queues/bull-job.publisher';
import { QUEUES } from '../queues/queues';
import { expectedMatchingJob, type OpenRequestState } from './expected-job';
import type { MatchingConfig } from './matching.config';
import { MATCHING_CONFIG } from './matching-config.provider';

/**
 * Reconciliador (ADR-0022): busca solicitudes abiertas sin su job de matching y lo vuelve
 * a encolar desde el estado de la base. Cubre lo que el outbox no puede: un job borrado
 * de Redis, un Redis restaurado o un fallo entre la transacción y el encolado.
 */
@Injectable()
export class MatchingReconciler {
  private readonly logger = new Logger('MatchingReconciler');

  constructor(
    private readonly prisma: PrismaService,
    private readonly publisher: BullJobPublisher,
    @Inject(MATCHING_CONFIG) private readonly config: MatchingConfig,
  ) {}

  /** Devuelve cuántos jobs volvió a encolar. */
  async runOnce(): Promise<number> {
    const open = await this.prisma.serviceRequest.findMany({
      where: { status: { in: ['buscando', 'con_ofertas'] } },
      select: { id: true, status: true, ring: true, ringStartedAt: true, expiresAt: true },
      take: 1000,
      orderBy: { publishedAt: 'asc' },
    });
    const queue = this.publisher.queue(QUEUES.matching);
    const ctx = {
      totalRings: this.config.rings.length,
      ringWaitMs: this.config.ringWaitMs,
      now: Date.now(),
    };
    let requeued = 0;
    for (const request of open as OpenRequestState[]) {
      const route = expectedMatchingJob(request, ctx);
      // Un job esperando, demorado, activo o ya completado (y guardado) cuenta como presente:
      // los handlers revisan el estado de la base, así que no hace falta repetirlo.
      const existing = await queue.getJob(route.jobId);
      if (existing) {
        const state = await existing.getState();
        if (state !== 'failed' && state !== 'unknown') continue;
        await existing.remove();
      }
      await this.publisher.publish(route);
      requeued++;
      this.logger.warn(`Reencolado ${route.name} de la solicitud ${request.id} (${route.jobId})`);
    }
    return requeued;
  }
}
