import { EventHandlersRegistry } from '../src/outbox/event-handlers.registry';
import { assignJob, completeJob } from './utils/jobs';
import { createTestApp, type TestApp, waitFor } from './utils/test-app';

/**
 * Recordatorio de calificar (ADR-0032): uno por trabajo y parte, aunque el worker procese
 * tarde varios job.status_changed del mismo trabajo (todos verían el trabajo ya terminado).
 * Regresión encontrada en la prueba manual de la Fase 6: salían cuatro.
 */
describe('Recordatorio de calificar (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterAll(async () => {
    await t.close();
  });

  const reminders = (userId: string) =>
    t.prisma.notification.count({ where: { userId, type: 'review_request' } });

  it('eventos procesados tarde no repiten el recordatorio', async () => {
    const job = await assignJob(t);
    await completeJob(t, job);
    await waitFor(
      () =>
        t.prisma.notification
          .findFirst({ where: { userId: job.worker.id, type: 'job_completed' } })
          .then((n) => n ?? undefined),
      { what: 'el aviso de trabajo terminado' },
    );

    // El worker vuelve a recibir los cuatro cambios (al menos una vez), ya con el trabajo
    // terminado: el recordatorio no se repite.
    const events = await t.prisma.outboxEvent.findMany({
      where: { aggregateId: job.jobId, type: 'job.status_changed' },
      orderBy: { id: 'asc' },
    });
    expect(events.length).toBeGreaterThanOrEqual(4);
    const registry = t.app.get(EventHandlersRegistry);
    for (const event of events) {
      await registry.dispatch('job.status_changed', {
        outboxId: event.id.toString(),
        aggregateId: job.jobId,
        payload: event.payload as never,
      });
    }
    expect(await reminders(job.worker.id)).toBe(1);
    expect(await reminders(job.employer.user.id)).toBe(1);
  });
});
