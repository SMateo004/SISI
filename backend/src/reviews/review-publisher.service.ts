import { AppSettingsService } from '../settings/app-settings.service';
import { Injectable, Logger } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';

/**
 * Publicación de calificaciones ciegas (ADR-0032). Una calificación se hace visible cuando
 * califican las dos partes o cuando vence el plazo. Al publicarse se recalcula el promedio
 * de quien la recibió (como trabajador o como empleador) desde las calificaciones
 * publicadas, con su fila bloqueada: dos publicaciones simultáneas no se pisan.
 */
@Injectable()
export class ReviewPublisher {
  private readonly logger = new Logger('ReviewPublisher');
  constructor(
    private readonly prisma: PrismaService,
    private readonly settings: AppSettingsService,
  ) {}

  /** Plazo vigente para calificar (panel o entorno, ADR-0043). */
  get windowMs(): number {
    return this.settings.value('REVIEW_WINDOW_MS');
  }

  /** Publica las calificaciones pendientes del trabajo y actualiza los promedios. */
  async publishJob(tx: Prisma.TransactionClient, jobId: string): Promise<number> {
    const published = await tx.$queryRaw<{ toUserId: string; reviewerRole: string }[]>`
      UPDATE reviews SET published_at = now()
      WHERE job_id = ${jobId}::uuid AND published_at IS NULL
      RETURNING to_user AS "toUserId", reviewer_role::text AS "reviewerRole"`;
    for (const review of published) {
      if (review.reviewerRole === 'employer') await this.refreshWorker(tx, review.toUserId);
      else await this.refreshEmployer(tx, review.toUserId);
    }
    return published.length;
  }

  /** Respaldo periódico: publica las de trabajos cuyo plazo venció. Devuelve cuántas. */
  async sweepDue(): Promise<number> {
    const due = await this.prisma.review.findMany({
      where: {
        publishedAt: null,
        job: { completedAt: { lte: new Date(Date.now() - this.windowMs) } },
      },
      select: { jobId: true },
      distinct: ['jobId'],
      take: 200,
    });
    let total = 0;
    for (const { jobId } of due) {
      total += await this.prisma.$transaction((tx) => this.publishJob(tx, jobId));
    }
    if (total > 0) this.logger.log(`Calificaciones publicadas al vencer el plazo: ${total}`);
    return total;
  }

  private async refreshWorker(tx: Prisma.TransactionClient, userId: string): Promise<void> {
    await tx.$queryRaw`SELECT user_id FROM worker_profiles WHERE user_id = ${userId}::uuid FOR UPDATE`;
    await tx.$executeRaw`
      UPDATE worker_profiles SET
        rating_avg = COALESCE((
          SELECT ROUND(AVG(stars)::numeric, 2) FROM reviews
          WHERE to_user = ${userId}::uuid AND reviewer_role = 'employer'
            AND published_at IS NOT NULL), 0),
        rating_count = (
          SELECT COUNT(*) FROM reviews
          WHERE to_user = ${userId}::uuid AND reviewer_role = 'employer'
            AND published_at IS NOT NULL)
      WHERE user_id = ${userId}::uuid`;
  }

  private async refreshEmployer(tx: Prisma.TransactionClient, userId: string): Promise<void> {
    await tx.$queryRaw`SELECT id FROM users WHERE id = ${userId}::uuid FOR UPDATE`;
    await tx.$executeRaw`
      UPDATE users SET
        employer_rating_avg = COALESCE((
          SELECT ROUND(AVG(stars)::numeric, 2) FROM reviews
          WHERE to_user = ${userId}::uuid AND reviewer_role = 'worker'
            AND published_at IS NOT NULL), 0),
        employer_rating_count = (
          SELECT COUNT(*) FROM reviews
          WHERE to_user = ${userId}::uuid AND reviewer_role = 'worker'
            AND published_at IS NOT NULL)
      WHERE id = ${userId}::uuid`;
  }
}
