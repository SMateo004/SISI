import request from 'supertest';
import type { CreatedRequestDto } from '../src/requests/dto/request.dto';
import { CENTRO } from './utils/requests';
import { bearer, createTestApp, login, type TestApp, uniqueIp } from './utils/test-app';
import { uniqueSuffix } from './utils/unique';

/** Id de correlación por petición (ADR-0048): respuesta, outbox y worker. */
describe('Id de correlación (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  it('genera un X-Request-Id si no viene y respeta uno válido', async () => {
    const generated = await request(t.url).get('/health');
    expect(generated.headers['x-request-id']).toMatch(/^[0-9a-f-]{36}$/);
    const given = await request(t.url).get('/health').set('X-Request-Id', 'app-req-00000001');
    expect(given.headers['x-request-id']).toBe('app-req-00000001');
    const junk = await request(t.url).get('/health').set('X-Request-Id', 'x y <script>');
    expect(junk.headers['x-request-id']).not.toBe('x y <script>');
  });

  it('el evento del outbox guarda el id de la petición que lo generó', async () => {
    const employer = await login(t);
    const requestId = `e2e-req-${uniqueSuffix()}`;
    const categoryId = (await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } }))
      .id;
    const created = (
      await request(t.url)
        .post('/requests')
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(employer.accessToken))
        .send({
          categoryId,
          description: 'Se tapó el desagüe del lavamanos y no baja el agua.',
          ...CENTRO,
          address: 'Calle Junín 150',
          proposedPriceBs: '120.00',
        })
        .expect(201)
    ).body as CreatedRequestDto;
    await request(t.url)
      .post(`/requests/${created.request.id}/publish`)
      .set('X-Request-Id', requestId)
      .set(...bearer(employer.accessToken))
      .expect(200);
    const events = await t.prisma.outboxEvent.findMany({
      where: { aggregateId: created.request.id },
    });
    expect(events.length).toBeGreaterThan(0);
    expect(events.every((e) => e.requestId === requestId)).toBe(true);
  });
});
