import request from 'supertest';
import type { IncomingRequestDto } from '../src/offers/dto/offer.dto';
import type { JobReviewsDto, UserReviewsDto } from '../src/reviews/dto/review.dto';
import { ReviewPublisher } from '../src/reviews/review-publisher.service';
import { type AssignedJob, assignJob, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';
import { createApprovedWorker, makeAvailable } from './utils/workers';

describe('Calificaciones (e2e, ADR-0032)', () => {
  let t: TestApp;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterAll(async () => {
    await t.close();
  });

  const post = (token: string, path: string, body: Record<string, unknown> = {}) =>
    request(server())
      .post(path)
      .set(...bearer(token))
      .send(body);

  const complete = async (job: AssignedJob) => {
    for (const step of ['on-the-way', 'start', 'finish']) {
      await post(job.worker.accessToken, `/jobs/${job.jobId}/${step}`).expect(200);
    }
    await post(job.employer.accessToken, `/jobs/${job.jobId}/confirm`).expect(200);
  };

  const review = (token: string, jobId: string, body: Record<string, unknown>) =>
    post(token, `/jobs/${jobId}/review`, body);

  const reviewsOf = async (token: string, jobId: string) =>
    (
      await request(server())
        .get(`/jobs/${jobId}/reviews`)
        .set(...bearer(token))
        .expect(200)
    ).body as JobReviewsDto;

  const profile = (userId: string) =>
    t.prisma.workerProfile.findUniqueOrThrow({ where: { userId } });

  it('ciegas hasta que califican los dos; luego se publican y suben los promedios', async () => {
    const job = await assignJob(t);
    // Antes de terminar no se califica.
    expect(
      (await review(job.employer.accessToken, job.jobId, { stars: 5 }).expect(409)).body,
    ).toMatchObject({ code: 'REVIEW_NOT_ALLOWED' });
    await complete(job);

    await review(job.worker.accessToken, job.jobId, { stars: 6 }).expect(400);
    const first = (
      await review(job.worker.accessToken, job.jobId, {
        stars: 4,
        comment: 'Me esperó con todo listo.',
      }).expect(201)
    ).body as JobReviewsDto;
    expect(first).toMatchObject({
      canReview: false,
      mine: { stars: 4, published: false },
      theirs: null,
    });
    await review(job.worker.accessToken, job.jobId, { stars: 5 }).expect(409);
    // El empleador todavía no la ve, y no cuenta en su promedio.
    const blind = await reviewsOf(job.employer.accessToken, job.jobId);
    expect(blind).toMatchObject({ canReview: true, mine: null, theirs: null });
    expect(
      (await t.prisma.user.findUniqueOrThrow({ where: { id: job.employer.user.id } }))
        .employerRatingCount,
    ).toBe(0);
    const stranger = await login(t);
    await review(stranger.accessToken, job.jobId, { stars: 1 }).expect(404);

    await review(job.employer.accessToken, job.jobId, {
      stars: 5,
      comment: 'Muy prolijo.',
    }).expect(201);
    expect(await reviewsOf(job.employer.accessToken, job.jobId)).toMatchObject({
      mine: { stars: 5, published: true },
      theirs: { stars: 4, comment: 'Me esperó con todo listo.' },
    });
    expect(await reviewsOf(job.worker.accessToken, job.jobId)).toMatchObject({
      theirs: { stars: 5, comment: 'Muy prolijo.' },
    });

    const worker = await profile(job.worker.id);
    expect([worker.ratingAvg.toFixed(2), worker.ratingCount]).toEqual(['5.00', 1]);
    const employer = await t.prisma.user.findUniqueOrThrow({ where: { id: job.employer.user.id } });
    expect([employer.employerRatingAvg.toFixed(2), employer.employerRatingCount]).toEqual([
      '4.00',
      1,
    ]);

    const publicList = (
      await request(server())
        .get(`/users/${job.worker.id}/reviews?role=worker`)
        .set(...bearer(stranger.accessToken))
        .expect(200)
    ).body as UserReviewsDto;
    expect(publicList).toMatchObject({ ratingAvg: '5.00', ratingCount: 1 });
    expect(publicList.items.map((r) => [r.stars, r.comment])).toEqual([[5, 'Muy prolijo.']]);

    // El promedio del empleador se ve en las solicitudes que les llegan a los trabajadores.
    const other = await createApprovedWorker(t, {
      categorySlugs: [
        (await t.prisma.category.findUniqueOrThrow({ where: { id: job.categoryId } })).slug,
      ],
    });
    await makeAvailable(t, other, eastOf(CENTRO, 300));
    const again = await publishRequest(t, job.employer.accessToken, { categoryId: job.categoryId });
    await waitNotified(t, again, other.id);
    const incoming = (
      await request(server())
        .get(`/worker/requests/${again}`)
        .set(...bearer(other.accessToken))
        .expect(200)
    ).body as IncomingRequestDto;
    expect(incoming.employer).toEqual({ ratingAvg: '4.00', ratingCount: 1 });
  });

  it('el promedio del trabajador se recalcula con todas sus calificaciones', async () => {
    const first = await assignJob(t);
    await complete(first);
    await review(first.employer.accessToken, first.jobId, { stars: 5 }).expect(201);
    await review(first.worker.accessToken, first.jobId, { stars: 5 }).expect(201);

    const second = await assignJob(t, { worker: first.worker, categoryId: first.categoryId });
    await complete(second);
    // Las dos partes califican a la vez: las dos se publican igual.
    await Promise.all([
      review(second.employer.accessToken, second.jobId, { stars: 4 }).expect(201),
      review(second.worker.accessToken, second.jobId, { stars: 3 }).expect(201),
    ]);
    const published = await t.prisma.review.count({
      where: { jobId: second.jobId, publishedAt: { not: null } },
    });
    expect(published).toBe(2);
    const worker = await profile(first.worker.id);
    expect([worker.ratingAvg.toFixed(2), worker.ratingCount]).toEqual(['4.50', 2]);
  });

  it('un comentario prohibido no se publica, pero las estrellas cuentan', async () => {
    const job = await assignJob(t);
    await complete(job);
    const mine = (
      await review(job.employer.accessToken, job.jobId, {
        stars: 2,
        comment: 'Me ofreció c.o.c.a.i.n.a',
      }).expect(201)
    ).body as JobReviewsDto;
    expect(mine.mine).toMatchObject({ commentHeld: true });
    await review(job.worker.accessToken, job.jobId, { stars: 5 }).expect(201);
    expect(await reviewsOf(job.worker.accessToken, job.jobId)).toMatchObject({
      theirs: { stars: 2, comment: null },
    });
    expect((await profile(job.worker.id)).ratingAvg.toFixed(2)).toBe('2.00');
  });

  it('al vencer el plazo se publica la única calificación y ya no se puede calificar', async () => {
    const job = await assignJob(t);
    await complete(job);
    await review(job.employer.accessToken, job.jobId, { stars: 3 }).expect(201);
    expect((await profile(job.worker.id)).ratingCount).toBe(0);

    // En e2e el plazo es de 3 s (REVIEW_WINDOW_MS); el barrido corre con el reconciliador.
    await new Promise((r) => setTimeout(r, 3100));
    expect(await t.app.get(ReviewPublisher).sweepDue()).toBeGreaterThanOrEqual(1);
    expect(await reviewsOf(job.worker.accessToken, job.jobId)).toMatchObject({
      canReview: false,
      theirs: { stars: 3 },
    });
    expect((await profile(job.worker.id)).ratingCount).toBe(1);
    expect(
      (await review(job.worker.accessToken, job.jobId, { stars: 5 }).expect(409)).body,
    ).toMatchObject({ code: 'REVIEW_WINDOW_CLOSED' });
  });
});
