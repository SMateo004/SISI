import request from 'supertest';
import type { LoginResponseDto } from '../../src/auth/dto/auth.dto';
import type { AcceptOfferResultDto, MyOfferDto } from '../../src/offers/dto/offer.dto';
import { CENTRO, eastOf, publishRequest } from './requests';
import { bearer, createCategory, login, type TestApp, uniqueIp, waitFor } from './test-app';
import { createApprovedWorker, makeAvailable, type TestWorker } from './workers';

/** Espera a que el matching le avise a ese trabajador de la solicitud. */
export async function waitNotified(t: TestApp, requestId: string, workerId: string): Promise<void> {
  await waitFor(
    async () =>
      (await t.prisma.requestNotification.findUnique({
        where: { requestId_workerId: { requestId, workerId } },
      })) ?? undefined,
    { what: 'el aviso al trabajador' },
  );
}

export async function offerOn(
  t: TestApp,
  worker: TestWorker,
  requestId: string,
  body: Record<string, unknown> = { type: 'accept' },
): Promise<MyOfferDto> {
  return (
    (
      await request(t.app.getHttpServer())
        .post(`/requests/${requestId}/offers`)
        // IP propia por oferta, como publishRequest: el límite por IP (60/min) es global a la
        // corrida y las suites que crean muchos trabajos no deben agotarlo para las demás.
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(worker.accessToken))
        .send(body)
        .expect(200)
    ).body as MyOfferDto
  );
}

export interface AssignedJob {
  jobId: string;
  requestId: string;
  worker: TestWorker;
  employer: LoginResponseDto;
  categoryId: string;
}

/**
 * Lleva una solicitud hasta un trabajo asignado: categoría propia, trabajador disponible
 * cerca, publicación, aviso, oferta (150 Bs por defecto) y elección.
 */
export async function assignJob(
  t: TestApp,
  opts: { amountBs?: string; worker?: TestWorker; categoryId?: string } = {},
): Promise<AssignedJob> {
  const categoryId = opts.categoryId ?? (await createCategory(t)).id;
  const slug = (await t.prisma.category.findUniqueOrThrow({ where: { id: categoryId } })).slug;
  const worker = opts.worker ?? (await createApprovedWorker(t, { categorySlugs: [slug] }));
  if (!opts.worker) await makeAvailable(t, worker, eastOf(CENTRO, 300));
  const employer = await login(t);
  const requestId = await publishRequest(t, employer.accessToken, { categoryId });
  await waitNotified(t, requestId, worker.id);
  const offer = await offerOn(
    t,
    worker,
    requestId,
    opts.amountBs ? { type: 'counter', amountBs: opts.amountBs } : { type: 'accept' },
  );
  const result = (
    await request(t.app.getHttpServer())
      .post(`/requests/${requestId}/offers/${offer.id}/accept`)
      .set(...bearer(employer.accessToken))
      .expect(200)
  ).body as AcceptOfferResultDto;
  return { jobId: result.jobId, requestId, worker, employer, categoryId };
}

/** Lleva un trabajo asignado hasta terminado: en camino, empecé, terminé y confirmar. */
export async function completeJob(t: TestApp, job: AssignedJob): Promise<void> {
  const server = t.app.getHttpServer();
  for (const step of ['on-the-way', 'start', 'finish']) {
    await request(server)
      .post(`/jobs/${job.jobId}/${step}`)
      .set(...bearer(job.worker.accessToken))
      .expect(200);
  }
  await request(server)
    .post(`/jobs/${job.jobId}/confirm`)
    .set(...bearer(job.employer.accessToken))
    .expect(200);
}
