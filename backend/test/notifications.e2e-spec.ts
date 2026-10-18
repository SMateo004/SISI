import request from 'supertest';
import type { NotificationPageDto } from '../src/notifications/dto/notification.dto';
import type { FakePushProvider } from '../src/notifications/push/fake-push.provider';
import { PUSH_PROVIDER } from '../src/notifications/push/push-provider';
import { EventHandlersRegistry } from '../src/outbox/event-handlers.registry';
import type { CreatedRequestDto } from '../src/requests/dto/request.dto';
import { CENTRO } from './utils/requests';
import {
  bearer,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueIp,
  waitFor,
} from './utils/test-app';

describe('Notificaciones y push (e2e, ADR-0027)', () => {
  let t: TestApp;
  let push: FakePushProvider;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    push = t.app.get<FakePushProvider>(PUSH_PROVIDER);
  });

  afterAll(async () => {
    await t.close();
  });

  const register = (token: string, deviceToken: string, platform = 'android') =>
    request(server())
      .post('/me/devices')
      .set(...bearer(token))
      .send({ token: deviceToken, platform });

  const notifications = async (token: string) =>
    (
      await request(server())
        .get('/me/notifications')
        .set(...bearer(token))
        .expect(200)
    ).body as NotificationPageDto;

  /** Publica una solicitud que queda retenida por moderación. */
  const heldRequest = async (token: string) => {
    const categoryId = (await t.prisma.category.findUniqueOrThrow({ where: { slug: 'limpieza' } }))
      .id;
    const created = (
      await request(server())
        .post('/requests')
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(token))
        .send({
          categoryId,
          description: 'Limpieza de la casa y de paso que me traigan marihuana para la fiesta.',
          ...CENTRO,
          address: 'Calle Junín 150',
          proposedPriceBs: '150.00',
        })
        .expect(201)
    ).body as CreatedRequestDto;
    await request(server())
      .post(`/requests/${created.request.id}/publish`)
      .set(...bearer(token))
      .expect(200);
    return created.request.id;
  };

  it('registra y da de baja tokens de dispositivo (el token pasa a la cuenta que lo registra)', async () => {
    const a = await login(t);
    const b = await login(t);
    await register(a.accessToken, 'tok-compartido-0000000001').expect(204);
    await register(b.accessToken, 'tok-compartido-0000000001', 'web').expect(204);

    const row = await t.prisma.deviceToken.findUniqueOrThrow({
      where: { token: 'tok-compartido-0000000001' },
    });
    expect(row).toMatchObject({ userId: b.user.id, platform: 'web' });

    await request(server())
      .delete('/me/devices/tok-compartido-0000000001')
      .set(...bearer(b.accessToken))
      .expect(204);
    expect(
      await t.prisma.deviceToken.findUnique({ where: { token: 'tok-compartido-0000000001' } }),
    ).toBeNull();

    await register(a.accessToken, 'corto').expect(400);
  });

  it('al liberar una retenida avisa al empleador (aviso guardado + push) y borra tokens inválidos', async () => {
    const employer = await login(t);
    await register(employer.accessToken, 'tok-empleador-valido-0001').expect(204);
    await register(employer.accessToken, 'invalid-tok-empleador-0001').expect(204);
    const id = await heldRequest(employer.accessToken);

    const admin = await loginAsAdmin(t);
    await request(server())
      .post(`/admin/requests/${id}/release`)
      .set(...bearer(admin.accessToken))
      .send({ reason: 'Revisada: no infringe las normas.' })
      .expect(200);

    const page = await waitFor(
      async () => {
        const p = await notifications(employer.accessToken);
        return p.items.length > 0 ? p : undefined;
      },
      { what: 'el aviso de solicitud liberada' },
    );
    expect(page.items[0]).toMatchObject({
      type: 'request_released',
      title: 'Tu solicitud fue publicada',
      route: `/solicitudes/${id}`,
      readAt: null,
    });

    // El push sale después de guardar el aviso: se espera a que se envíe.
    const sent = await waitFor(
      () => Promise.resolve(push.sent.find((s) => s.message.data.requestId === id)),
      { what: 'el push al empleador' },
    );
    expect(sent.tokens.sort()).toEqual(['invalid-tok-empleador-0001', 'tok-empleador-valido-0001']);
    expect(sent.message.data.route).toBe(`/solicitudes/${id}`);
    await waitFor(
      async () =>
        (await t.prisma.deviceToken.findUnique({ where: { token: 'invalid-tok-empleador-0001' } }))
          ? undefined
          : true,
      { what: 'que se borre el token inválido' },
    );

    const first = page.items[0];
    if (!first) throw new Error('sin aviso');
    await request(server())
      .post(`/me/notifications/${first.id}/read`)
      .set(...bearer(employer.accessToken))
      .expect(204);
    expect((await notifications(employer.accessToken)).items[0]?.readAt).not.toBeNull();
  });

  it('al rechazar una retenida avisa al empleador', async () => {
    const employer = await login(t);
    const id = await heldRequest(employer.accessToken);
    const admin = await loginAsAdmin(t);
    await request(server())
      .post(`/admin/requests/${id}/reject`)
      .set(...bearer(admin.accessToken))
      .send({ reason: 'Ofrece sustancias prohibidas' })
      .expect(200);

    const page = await waitFor(
      async () => {
        const p = await notifications(employer.accessToken);
        return p.items.length > 0 ? p : undefined;
      },
      { what: 'el aviso de rechazo' },
    );
    expect(page.items[0]).toMatchObject({ type: 'request_rejected' });
  });

  it('un evento repetido no duplica el aviso ni el push (idempotente)', async () => {
    const employer = await login(t);
    await register(employer.accessToken, 'tok-idempotente-00000001').expect(204);
    const id = await heldRequest(employer.accessToken);
    const admin = await loginAsAdmin(t);
    await request(server())
      .post(`/admin/requests/${id}/release`)
      .set(...bearer(admin.accessToken))
      .send({ reason: 'Revisada: no infringe las normas.' })
      .expect(200);
    await waitFor(
      async () => ((await notifications(employer.accessToken)).items.length > 0 ? true : undefined),
      { what: 'el primer aviso' },
    );

    const event = await t.prisma.outboxEvent.findFirstOrThrow({
      where: { aggregateId: id, type: 'request.released' },
    });
    await t.app.get(EventHandlersRegistry).dispatch('request.released', {
      outboxId: event.id.toString(),
      aggregateId: id,
      payload: { requestId: id },
    });

    expect((await notifications(employer.accessToken)).items).toHaveLength(1);
    expect(push.sent.filter((s) => s.message.data.requestId === id)).toHaveLength(1);
  });

  it('contador de no leídos, marcar uno y marcar todos', async () => {
    const employer = await login(t);
    const admin = await loginAsAdmin(t);
    for (let i = 0; i < 3; i++) {
      const id = await heldRequest(employer.accessToken);
      await request(server())
        .post(`/admin/requests/${id}/release`)
        .set(...bearer(admin.accessToken))
        .send({ reason: 'Revisada: no infringe las normas.' })
        .expect(200);
    }
    const unread = async () =>
      (
        (
          await request(server())
            .get('/me/notifications/unread-count')
            .set(...bearer(employer.accessToken))
            .expect(200)
        ).body as { count: number }
      ).count;
    await waitFor(async () => ((await unread()) === 3 ? true : undefined), {
      what: 'los 3 avisos',
    });

    const [first] = (await notifications(employer.accessToken)).items;
    await request(server())
      .post(`/me/notifications/${first?.id ?? ''}/read`)
      .set(...bearer(employer.accessToken))
      .expect(204);
    expect(await unread()).toBe(2);

    const all = await request(server())
      .post('/me/notifications/read-all')
      .set(...bearer(employer.accessToken))
      .expect(200);
    expect(all.body).toEqual({ updated: 2 });
    expect(await unread()).toBe(0);
    expect((await notifications(employer.accessToken)).items.every((n) => n.readAt)).toBe(true);
  });
});
