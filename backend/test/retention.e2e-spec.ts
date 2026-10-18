import { getQueueToken } from '@nestjs/bullmq';
import type { Queue } from 'bullmq';
import request from 'supertest';
import { MATCHING_JOBS, QUEUES } from '../src/queues/queues';
import type { CreatedRequestDto } from '../src/requests/dto/request.dto';
import { EXPIRED_MESSAGE, RetentionService } from '../src/retention/retention.service';
import { WorkerStatusService } from '../src/workers/worker-status.service';
import { assignJob, completeJob } from './utils/jobs';
import { CENTRO } from './utils/requests';
import { bearer, createTestApp, login, type TestApp, uniqueIp } from './utils/test-app';
import { uniqueSuffix } from './utils/unique';
import { createPendingWorker } from './utils/workers';

const DAY = 86_400_000;

/** Retención y jobs de limpieza (e2e, ADR-0050). Las fechas viejas se simulan en la base. */
describe('Retención de datos (e2e)', () => {
  let t: TestApp;
  let retention: RetentionService;
  const ago = (days: number) => new Date(Date.now() - days * DAY);
  const http = () => request(t.app.getHttpServer());

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    retention = t.app.get(RetentionService);
  });

  afterAll(async () => {
    await t.close();
  });

  it('borra lo vencido, respeta lo vigente y las excepciones, y es idempotente', async () => {
    // Documentos de un rechazado hace 100 días; los de un pendiente se quedan.
    const rejected = await createPendingWorker(t);
    await t.app
      .get(WorkerStatusService)
      .apply(rejected.id, { type: 'REJECT', reason: 'documento_ilegible: borroso' }, null);
    await t.prisma.workerProfile.update({
      where: { userId: rejected.id },
      data: { reviewedAt: ago(100) },
    });
    const pending = await createPendingWorker(t);

    // Chat de un trabajo terminado hace 200 días y de otro con un reporte pendiente.
    const oldJob = await assignJob(t);
    await http()
      .post(`/jobs/${oldJob.jobId}/messages`)
      .set(...bearer(oldJob.worker.accessToken))
      .send({ body: 'Llego en 10 minutos.' })
      .expect(201);
    await completeJob(t, oldJob);
    const reportedJob = await assignJob(t);
    await http()
      .post(`/jobs/${reportedJob.jobId}/messages`)
      .set(...bearer(reportedJob.worker.accessToken))
      .send({ body: 'Mensaje que está en revisión.' })
      .expect(201);
    await completeJob(t, reportedJob);
    await http()
      .post('/reports')
      .set(...bearer(reportedJob.employer.accessToken))
      .send({
        targetType: 'job',
        targetId: reportedJob.jobId,
        reason: 'fraude',
        note: 'Cobró de más.',
      })
      .expect(201);
    await t.prisma.job.updateMany({
      where: { id: { in: [oldJob.jobId, reportedJob.jobId] } },
      data: { completedAt: ago(200) },
    });

    // Borrador abandonado hace 10 días y uno de ayer.
    const employer = await login(t);
    const category = await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } });
    const draft = async () =>
      (
        (
          await http()
            .post('/requests')
            .set('X-Forwarded-For', uniqueIp())
            .set(...bearer(employer.accessToken))
            .send({
              categoryId: category.id,
              description: 'Hay que cambiar el flotador del tanque de agua del baño.',
              ...CENTRO,
              address: 'Calle Junín 150',
              proposedPriceBs: '120.00',
            })
            .expect(201)
        ).body as CreatedRequestDto
      ).request.id;
    const oldDraft = await draft();
    const newDraft = await draft();
    await t.prisma.serviceRequest.update({ where: { id: oldDraft }, data: { createdAt: ago(10) } });

    // Comprobante rechazado hace 400 días, avisos leídos viejos, tokens y claves viejas.
    const submission = await t.prisma.paymentSubmission.create({
      data: {
        workerId: oldJob.worker.id,
        cityId: (await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } })).id,
        receiptKey: `receipts/${oldJob.worker.id}/viejo-${uniqueSuffix()}.jpg`,
        status: 'rechazado',
        reviewedAt: ago(400),
      },
    });
    const notification = await t.prisma.notification.create({
      data: {
        userId: employer.user.id,
        cityId: submission.cityId,
        type: 'request_new',
        title: 'Aviso viejo',
        body: 'Ya leído',
        dedupeKey: `retencion-${uniqueSuffix()}`,
        readAt: ago(100),
      },
    });
    await t.prisma.refreshToken.updateMany({
      where: { userId: employer.user.id },
      data: { expiresAt: ago(40) },
    });
    const key = `retencion-${uniqueSuffix()}`;
    await t.prisma.idempotencyKey.create({
      data: { scope: 'e2e', key, actorId: employer.user.id, requestHash: 'x', createdAt: ago(40) },
    });

    // Prueba sin borrar: cuenta y no toca nada.
    const dry = await retention.run({ dryRun: true });
    expect(dry.rejected_documents).toBeGreaterThanOrEqual(3);
    expect(dry.old_chat).toBeGreaterThanOrEqual(1);
    expect(dry.abandoned_drafts).toBeGreaterThanOrEqual(1);
    expect(await t.prisma.workerDocument.count({ where: { workerId: rejected.id } })).toBe(3);

    const first = await retention.run();
    expect(first.rejected_documents).toBeGreaterThanOrEqual(3);

    expect(await t.prisma.workerDocument.count({ where: { workerId: rejected.id } })).toBe(0);
    expect(await t.prisma.workerDocument.count({ where: { workerId: pending.id } })).toBe(3);
    const oldMessages = await t.prisma.chatMessage.findMany({ where: { jobId: oldJob.jobId } });
    expect(oldMessages.every((m) => m.body === EXPIRED_MESSAGE)).toBe(true);
    const keptMessages = await t.prisma.chatMessage.findMany({
      where: { jobId: reportedJob.jobId },
    });
    expect(keptMessages.map((m) => m.body)).toEqual(['Mensaje que está en revisión.']);
    expect(await t.prisma.serviceRequest.count({ where: { id: oldDraft } })).toBe(0);
    expect(await t.prisma.serviceRequest.count({ where: { id: newDraft } })).toBe(1);
    const purged = await t.prisma.paymentSubmission.findUniqueOrThrow({
      where: { id: submission.id },
    });
    expect(purged.receiptPurgedAt).not.toBeNull();
    expect(await t.prisma.notification.count({ where: { id: notification.id } })).toBe(0);
    expect(await t.prisma.refreshToken.count({ where: { userId: employer.user.id } })).toBe(0);
    expect(await t.prisma.idempotencyKey.count({ where: { key } })).toBe(0);
    // El ledger no se toca nunca.
    expect(
      await t.prisma.ledgerEntry.count({ where: { workerId: oldJob.worker.id } }),
    ).toBeGreaterThan(0);

    // Una segunda corrida no encuentra nada de lo de esta prueba.
    const second = await retention.run();
    expect(second.rejected_documents).toBe(0);
    expect(second.old_chat).toBe(0);
    expect(second.abandoned_drafts).toBe(0);
    expect(second.rejected_receipts).toBe(0);
  });

  it('apagada por defecto: el worker no la programa', async () => {
    const queue = t.app.get<Queue>(getQueueToken(QUEUES.matching));
    expect(await queue.getJobScheduler(MATCHING_JOBS.retention)).toBeUndefined();
    expect(await queue.getJobScheduler(MATCHING_JOBS.outboxCleanup)).toBeDefined();
  });
});
