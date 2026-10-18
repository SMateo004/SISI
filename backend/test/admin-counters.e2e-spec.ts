import request from 'supertest';
import type { CreatedRequestDto } from '../src/requests/dto/request.dto';
import { CENTRO } from './utils/requests';
import { connectSocket, type TestSocket } from './utils/socket';
import {
  bearer,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueIp,
} from './utils/test-app';

/** Colas del panel en vivo por socket (ADR-0044). */
describe('admin:counters (e2e)', () => {
  let t: TestApp;
  const sockets: TestSocket[] = [];

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterAll(async () => {
    for (const s of sockets) s.close();
    await t.close();
  });

  it('una solicitud retenida llega como admin:counters a la sesión del panel, no a la app', async () => {
    const admin = await loginAsAdmin(t);
    const panel = await connectSocket(t, admin.accessToken);
    const appOfAdmin = await connectSocket(t, admin.appAccessToken);
    const user = await login(t);
    const userSocket = await connectSocket(t, user.accessToken);
    sockets.push(panel, appOfAdmin, userSocket);

    const before = await request(t.app.getHttpServer())
      .get('/admin/counters')
      .set(...bearer(admin.accessToken))
      .expect(200)
      .then((r) => r.body as { heldRequests: number });

    const categoryId = (await t.prisma.category.findUniqueOrThrow({ where: { slug: 'limpieza' } }))
      .id;
    const created = (
      await request(t.app.getHttpServer())
        .post('/requests')
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(user.accessToken))
        .send({
          categoryId,
          description: 'Limpieza de la casa y de paso que me traigan marihuana para la fiesta.',
          ...CENTRO,
          address: 'Calle Junín 150',
          proposedPriceBs: '150.00',
        })
        .expect(201)
    ).body as CreatedRequestDto;
    await request(t.app.getHttpServer())
      .post(`/requests/${created.request.id}/publish`)
      .set(...bearer(user.accessToken))
      .expect(200);

    const live = await panel.next(
      'admin:counters',
      (p) => p.heldRequests > before.heldRequests,
      10_000,
    );
    expect(live.heldRequests).toBe(before.heldRequests + 1);
    expect(live.at).toEqual(expect.any(String));
    // La app (aunque sea de un admin) y los usuarios no reciben las colas.
    expect(appOfAdmin.received.some((r) => r.event === 'admin:counters')).toBe(false);
    expect(userSocket.received.some((r) => r.event === 'admin:counters')).toBe(false);
  });
});
