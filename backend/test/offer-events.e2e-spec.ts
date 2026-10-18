import request from 'supertest';
import { offerOn, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { createApprovedWorker, makeAvailable } from './utils/workers';
import { bearer, createCategory, createTestApp, login, type TestApp } from './utils/test-app';

/** Historial de ofertas (ADR-0042): cada monto ofertado queda en offer_events. */
describe('offer_events (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterAll(async () => {
    await t.close();
  });

  const eventsOf = (requestId: string) =>
    t.prisma.offerEvent.findMany({ where: { requestId }, orderBy: { id: 'asc' } });

  it('guarda cada monto: crear, reemplazar, retirar, reenviar, aceptar y cerrar las demás', async () => {
    const category = await createCategory(t);
    const a = await createApprovedWorker(t, { categorySlugs: [category.slug] });
    const b = await createApprovedWorker(t, { categorySlugs: [category.slug] });
    await makeAvailable(t, a, eastOf(CENTRO, 300));
    await makeAvailable(t, b, eastOf(CENTRO, 400));
    const employer = await login(t);
    const requestId = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await waitNotified(t, requestId, a.id);
    await waitNotified(t, requestId, b.id);

    const first = await offerOn(t, a, requestId, { type: 'counter', amountBs: '180.00' });
    await offerOn(t, a, requestId, { type: 'counter', amountBs: '170.00' });
    await offerOn(t, b, requestId, { type: 'accept' });
    await request(t.app.getHttpServer())
      .delete(`/requests/${requestId}/offers/mine`)
      .set(...bearer(b.accessToken))
      .expect(200);
    const resent = await offerOn(t, b, requestId, { type: 'counter', amountBs: '160.00' });
    await request(t.app.getHttpServer())
      .post(`/requests/${requestId}/offers/${first.id}/accept`)
      .set(...bearer(employer.accessToken))
      .expect(200);

    const events = await eventsOf(requestId);
    expect(
      events.map((e) => [
        e.offerId === first.id ? 'a' : 'b',
        e.kind,
        e.revision,
        e.amountBs.toFixed(2),
      ]),
    ).toEqual([
      ['a', 'creada', 1, '180.00'],
      ['a', 'reemplazada', 2, '170.00'],
      ['b', 'creada', 1, '150.00'],
      ['b', 'retirada', 1, '150.00'],
      ['b', 'reemplazada', 2, '160.00'],
      ['a', 'aceptada', 2, '170.00'],
      ['b', 'cerrada', 2, '160.00'],
    ]);
    expect(events.every((e) => e.cityId && e.workerId)).toBe(true);
    expect(resent.id).not.toBe(first.id);
  });

  it('es append-only: UPDATE y DELETE fallan', async () => {
    const [row] = await t.prisma.offerEvent.findMany({ take: 1 });
    if (!row) throw new Error('Sin eventos de oferta');
    await expect(
      t.prisma.offerEvent.update({ where: { id: row.id }, data: { amountBs: '1.00' } }),
    ).rejects.toThrow(/append-only/);
    await expect(t.prisma.offerEvent.delete({ where: { id: row.id } })).rejects.toThrow(
      /append-only/,
    );
  });
});
