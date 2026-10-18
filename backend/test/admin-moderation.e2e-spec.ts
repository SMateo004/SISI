import request from 'supertest';
import type {
  AdminHeldMessagePageDto,
  ChatPageDto,
  SentMessageDto,
} from '../src/chat/dto/chat.dto';
import type {
  AdminRequestPageDto,
  CreatedRequestDto,
  PublishResultDto,
} from '../src/requests/dto/request.dto';
import { auditRows, expectAudited } from './utils/audit';
import { assignJob, waitNotified } from './utils/jobs';
import { CENTRO, eastOf } from './utils/requests';
import { createApprovedWorker, makeAvailable } from './utils/workers';
import {
  type AdminSession,
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  promoteToAdmin,
  type TestApp,
  uniqueIp,
} from './utils/test-app';

/** Moderación en el panel (R3.3, R9.2): solicitudes y mensajes retenidos. */
describe('Moderación en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const server = () => t.app.getHttpServer();
  const post = (path: string, body: Record<string, unknown>, token = admin.accessToken) =>
    request(server())
      .post(path)
      .set(...bearer(token))
      .send(body);

  /** Solicitud que queda retenida por moderación en la categoría dada. */
  async function heldRequest(token: string, categoryId: string): Promise<string> {
    const created = (
      await request(server())
        .post('/requests')
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(token))
        .send({
          categoryId,
          description: 'Arreglo de la ducha y de paso que me consigan marihuana para la fiesta.',
          ...CENTRO,
          address: 'Calle Junín 150',
          proposedPriceBs: '150.00',
        })
        .expect(201)
    ).body as CreatedRequestDto;
    const published = (
      await request(server())
        .post(`/requests/${created.request.id}/publish`)
        .set(...bearer(token))
        .expect(200)
    ).body as PublishResultDto;
    expect(published.held).toBe(true);
    return created.request.id;
  }

  describe('solicitudes retenidas', () => {
    it('la lista muestra los términos que coincidieron; liberar exige motivo y entra al matching', async () => {
      const category = await createCategory(t);
      const worker = await createApprovedWorker(t, { categorySlugs: [category.slug] });
      await makeAvailable(t, worker, eastOf(CENTRO, 300));
      const employer = await login(t);
      const id = await heldRequest(employer.accessToken, category.id);

      const page = (
        await request(server())
          .get('/admin/requests')
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as AdminRequestPageDto;
      const mine = page.items.find((r) => r.id === id);
      expect(JSON.stringify(mine?.matches)).toContain('marihuan*');

      await post(`/admin/requests/${id}/release`, {}).expect(400);
      await post(`/admin/requests/${id}/release`, {
        reason: 'Revisada: el resto del pedido es válido.',
      }).expect(200);
      // Entra al matching: le llega al trabajador cercano.
      await waitNotified(t, id, worker.id);
      const row = await expectAudited(t, {
        action: 'moderation.request_release',
        targetType: 'request',
        targetId: id,
        adminId: admin.user.id,
      });
      expect(row).toMatchObject({
        before: { status: 'retenida' },
        after: { status: 'buscando' },
        reason: 'Revisada: el resto del pedido es válido.',
      });
      // Liberarla otra vez no se puede.
      await post(`/admin/requests/${id}/release`, { reason: 'Otra vez.' }).expect(409);
    });

    it('rechazar la deja cancelada por moderación y queda auditado', async () => {
      const category = await createCategory(t);
      const employer = await login(t);
      const id = await heldRequest(employer.accessToken, category.id);
      await post(`/admin/requests/${id}/reject`, {
        reason: 'Pide sustancias prohibidas.',
      }).expect(200);
      const req = await t.prisma.serviceRequest.findUniqueOrThrow({ where: { id } });
      expect(req).toMatchObject({ status: 'cancelada', cancelReason: 'moderacion' });
      await expectAudited(t, {
        action: 'moderation.request_reject',
        targetType: 'request',
        targetId: id,
        adminId: admin.user.id,
      });
    });

    it('un admin no modera su propia solicitud', async () => {
      const category = await createCategory(t);
      const employer = await login(t);
      const id = await heldRequest(employer.accessToken, category.id);
      const self = await promoteToAdmin(t, employer.user.id);
      const res = await post(`/admin/requests/${id}/release`, { reason: 'Es mía.' }, self).expect(
        403,
      );
      expect(res.body).toMatchObject({ code: 'SELF_REVIEW_FORBIDDEN' });
      expect(await auditRows(t, 'request', id)).toHaveLength(0);
    });
  });

  describe('mensajes de chat retenidos', () => {
    const send = (token: string, jobId: string, body: string) =>
      request(server())
        .post(`/jobs/${jobId}/messages`)
        .set(...bearer(token))
        .send({ body });
    const messages = (token: string, jobId: string) =>
      request(server())
        .get(`/jobs/${jobId}/messages`)
        .set(...bearer(token))
        .expect(200)
        .then((r) => r.body as ChatPageDto);

    it('liberar lo entrega al destinatario (outbox chat.message_sent) y queda auditado', async () => {
      const { jobId, worker, employer } = await assignJob(t);
      const held = (
        await send(worker.accessToken, jobId, 'Te consigo c.o.c.a.i.n.a barata').expect(201)
      ).body as SentMessageDto;
      expect((await messages(employer.accessToken, jobId)).items).toHaveLength(0);

      const list = (
        await request(server())
          .get('/admin/chat/held')
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as AdminHeldMessagePageDto;
      expect(list.items.map((m) => m.id)).toContain(held.id);

      await post(`/admin/chat/${held.id}/release`, {
        reason: 'Era una broma entre conocidos; sin oferta real.',
      }).expect(200);
      const seen = await messages(employer.accessToken, jobId);
      expect(seen.items).toEqual([
        expect.objectContaining({ id: held.id, status: 'entregado', mine: false }),
      ]);
      expect(
        await t.prisma.outboxEvent.count({
          where: { aggregateId: jobId, type: 'chat.message_sent' },
        }),
      ).toBe(1);
      await expectAudited(t, {
        action: 'moderation.chat_release',
        targetType: 'chat_message',
        targetId: held.id,
        adminId: admin.user.id,
      });
      // Ya revisado: 409.
      const again = await post(`/admin/chat/${held.id}/discard`, { reason: 'Otra vez.' }).expect(
        409,
      );
      expect(again.body).toMatchObject({ code: 'MESSAGE_ALREADY_REVIEWED' });
    });

    it('descartar no lo entrega nunca; para quien lo envió sigue como no enviado', async () => {
      const { jobId, worker, employer } = await assignJob(t);
      const held = (
        await send(worker.accessToken, jobId, 'Te consigo c.o.c.a.i.n.a barata').expect(201)
      ).body as SentMessageDto;
      await post(`/admin/chat/${held.id}/discard`, {
        reason: 'Ofrece sustancias prohibidas.',
      }).expect(200);
      expect((await messages(employer.accessToken, jobId)).items).toHaveLength(0);
      expect((await messages(worker.accessToken, jobId)).items).toEqual([
        expect.objectContaining({ id: held.id, status: 'retenido', mine: true }),
      ]);
      const row = await t.prisma.chatMessage.findUniqueOrThrow({ where: { id: held.id } });
      expect(row.status).toBe('descartado');
      const list = (
        await request(server())
          .get('/admin/chat/held')
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as AdminHeldMessagePageDto;
      expect(list.items.map((m) => m.id)).not.toContain(held.id);
      await expectAudited(t, {
        action: 'moderation.chat_discard',
        targetType: 'chat_message',
        targetId: held.id,
        adminId: admin.user.id,
      });
    });

    it('un admin no modera mensajes de un trabajo suyo', async () => {
      const { jobId, worker, employer } = await assignJob(t);
      const held = (
        await send(worker.accessToken, jobId, 'Te consigo c.o.c.a.i.n.a barata').expect(201)
      ).body as SentMessageDto;
      const self = await promoteToAdmin(t, employer.user.id);
      await post(`/admin/chat/${held.id}/release`, { reason: 'Me lo mandaron a mí.' }, self).expect(
        403,
      );
    });
  });
});
