import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { Review } from '../generated/prisma/client';
import { jobNotFound, lockJob } from '../jobs/job-status.service';
import { ModerationService } from '../moderation/moderation.service';
import { shortName } from '../offers/offer.rules';
import { PrismaService } from '../prisma/prisma.service';
import type { JobReviewsDto, UserReviewsDto } from './dto/review.dto';
import { ReviewPublisher } from './review-publisher.service';
import { canReview, reviewDeadline } from './review.rules';

const PAGE = 20;

/**
 * Calificaciones (R6.2, ADR-0032): una por parte y por trabajo, solo terminado y dentro del
 * plazo. Ciegas: la de la contraparte se ve recién cuando califican las dos o vence el
 * plazo. El comentario se modera; si coincide, no se publica (las estrellas cuentan).
 */
@Injectable()
export class ReviewsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly moderation: ModerationService,
    private readonly publisher: ReviewPublisher,
  ) {}

  async submit(
    userId: string,
    jobId: string,
    stars: number,
    rawComment: string | undefined,
  ): Promise<JobReviewsDto> {
    const trimmed = rawComment?.trim();
    const comment = trimmed === '' ? undefined : trimmed;
    const held = comment ? (await this.moderation.check(comment)).held : false;

    await this.prisma.$transaction(async (tx) => {
      // El trabajo bloqueado: si las dos partes califican a la vez, la segunda ve la primera.
      const job = await lockJob(tx, jobId);
      if (!job || (job.workerId !== userId && job.employerId !== userId)) throw jobNotFound();
      const full = await tx.job.findUniqueOrThrow({
        where: { id: jobId },
        select: { completedAt: true },
      });
      const existing = await tx.review.findUnique({
        where: { jobId_fromUserId: { jobId, fromUserId: userId } },
        select: { id: true },
      });
      if (existing) {
        throw new ApiError(HttpStatus.CONFLICT, 'ALREADY_REVIEWED', 'Ya calificaste este trabajo.');
      }
      const state = { status: job.status, completedAt: full.completedAt };
      if (!canReview(state, false, Date.now(), this.publisher.windowMs)) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          job.status === 'terminado' ? 'REVIEW_WINDOW_CLOSED' : 'REVIEW_NOT_ALLOWED',
          job.status === 'terminado'
            ? 'Pasó el plazo para calificar este trabajo.'
            : 'Solo puedes calificar un trabajo terminado.',
        );
      }
      const iAmWorker = job.workerId === userId;
      await tx.review.create({
        data: {
          jobId,
          cityId: job.cityId,
          fromUserId: userId,
          toUserId: iAmWorker ? job.employerId : job.workerId,
          reviewerRole: iAmWorker ? 'worker' : 'employer',
          stars,
          comment: comment ?? null,
          commentHeld: held,
        },
      });
      if ((await tx.review.count({ where: { jobId } })) === 2) {
        await this.publisher.publishJob(tx, jobId);
      }
    });
    return this.forJob(userId, jobId);
  }

  /** Lo que ve una de las partes del trabajo. */
  async forJob(userId: string, jobId: string): Promise<JobReviewsDto> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      select: { workerId: true, employerId: true, status: true, completedAt: true, reviews: true },
    });
    if (!job || (job.workerId !== userId && job.employerId !== userId)) throw jobNotFound();
    return jobReviews(job, userId, this.publisher.windowMs);
  }

  /** Calificaciones publicadas que recibió un usuario, como trabajador o como empleador. */
  async forUser(
    userId: string,
    role: 'worker' | 'employer',
    cursor: string | undefined,
  ): Promise<UserReviewsDto> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: {
        employerRatingAvg: true,
        employerRatingCount: true,
        workerProfile: { select: { ratingAvg: true, ratingCount: true } },
      },
    });
    if (!user) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'USER_NOT_FOUND', 'El usuario no existe.');
    }
    // Las recibidas como trabajador las escriben empleadores, y al revés.
    const rows = await this.prisma.review.findMany({
      where: {
        toUserId: userId,
        reviewerRole: role === 'worker' ? 'employer' : 'worker',
        publishedAt: { not: null },
      },
      orderBy: [{ publishedAt: 'desc' }, { id: 'desc' }],
      take: PAGE + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, PAGE);
    const reviewers = await this.prisma.user.findMany({
      where: { id: { in: page.map((r) => r.fromUserId) } },
      select: { id: true, name: true },
    });
    const names = new Map(reviewers.map((u) => [u.id, u.name]));
    const avg =
      role === 'worker'
        ? (user.workerProfile?.ratingAvg.toFixed(2) ?? '0.00')
        : user.employerRatingAvg.toFixed(2);
    return {
      ratingAvg: avg,
      ratingCount:
        role === 'worker' ? (user.workerProfile?.ratingCount ?? 0) : user.employerRatingCount,
      items: page.map((r) => ({
        id: r.id,
        stars: r.stars,
        comment: r.commentHeld ? null : r.comment,
        reviewerShortName: shortName(names.get(r.fromUserId) ?? null),
        publishedAt: r.publishedAt?.toISOString() ?? '',
      })),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }
}

/** Calificaciones del trabajo vistas por una parte (la de la contraparte, solo publicada). */
export function jobReviews(
  job: { status: string; completedAt: Date | null; reviews: Review[] },
  userId: string,
  windowMs: number,
): JobReviewsDto {
  const mine = job.reviews.find((r) => r.fromUserId === userId);
  const theirs = job.reviews.find((r) => r.fromUserId !== userId && r.publishedAt !== null);
  return {
    canReview: canReview(job, !!mine, Date.now(), windowMs),
    deadline: reviewDeadline(job.completedAt, windowMs)?.toISOString() ?? null,
    mine: mine
      ? {
          stars: mine.stars,
          comment: mine.comment,
          commentHeld: mine.commentHeld,
          published: mine.publishedAt !== null,
        }
      : null,
    theirs: theirs
      ? { stars: theirs.stars, comment: theirs.commentHeld ? null : theirs.comment }
      : null,
  };
}
