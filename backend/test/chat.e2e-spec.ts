import request from 'supertest';
import type { AdminHeldMessageDto, ChatPageDto, SentMessageDto } from '../src/chat/dto/chat.dto';
import { assignJob } from './utils/jobs';
import { connectSocket, type TestSocket } from './utils/socket';
import {
  bearer,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  waitFor,
} from './utils/test-app';

describe('Chat del trabajo (e2e, ADR-0031)', () => {
  let t: TestApp;
  const sockets: TestSocket[] = [];
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
  });

  afterEach(() => {
    for (const s of sockets.splice(0)) s.close();
  });

  afterAll(async () => {
    await t.close();
  });

  const send = (token: string, jobId: string, body: string) =>
    request(server())
      .post(`/jobs/${jobId}/messages`)
      .set(...bearer(token))
      .send({ body });

  const history = async (token: string, jobId: string, query = '') =>
    (
      await request(server())
        .get(`/jobs/${jobId}/messages${query}`)
        .set(...bearer(token))
        .expect(200)
    ).body as ChatPageDto;

  const chatNotices = (userId: string, jobId: string) =>
    t.prisma.notification.findMany({
      where: { userId, type: 'chat_message', payload: { path: ['jobId'], equals: jobId } },
    });

  it('las dos partes conversan en vivo; push solo a quien no está conectado', async () => {
    const { jobId, worker, employer } = await assignJob(t);
    const employerLive = await connectSocket(t, employer.accessToken);
    sockets.push(employerLive);

    // El trabajador escribe; el empleador está conectado: lo recibe en vivo y sin aviso.
    const sent = (
      await send(worker.accessToken, jobId, '  Hola, llego en 10 minutos.  ').expect(201)
    ).body as SentMessageDto;
    expect(sent).toMatchObject({
      body: 'Hola, llego en 10 minutos.',
      status: 'entregado',
      mine: true,
      notice: null,
    });
    expect(await employerLive.next('chat:message', (p) => p.jobId === jobId)).toEqual({
      jobId,
      messageId: sent.id,
      senderId: worker.id,
      body: 'Hola, llego en 10 minutos.',
      createdAt: sent.createdAt,
    });

    // El empleador responde; el trabajador no está conectado: le llega el aviso con push.
    const reply = (await send(employer.accessToken, jobId, 'Perfecto, te espero.').expect(201))
      .body as SentMessageDto;
    const [notice] = await waitFor(
      async () => {
        const n = await chatNotices(worker.id, jobId);
        return n.length > 0 ? n : undefined;
      },
      { what: 'el aviso del chat' },
    );
    expect(notice).toMatchObject({ body: 'Perfecto, te espero.' });
    expect(await chatNotices(employer.user.id, jobId)).toHaveLength(0);

    const forWorker = await history(worker.accessToken, jobId);
    expect(forWorker.items.map((m) => [m.body, m.mine])).toEqual([
      ['Perfecto, te espero.', false],
      ['Hola, llego en 10 minutos.', true],
    ]);
    expect(forWorker).toMatchObject({ open: true, closesAt: null, unread: 1 });

    // Marcas de lectura.
    const read = await request(server())
      .post(`/jobs/${jobId}/messages/read`)
      .set(...bearer(worker.accessToken))
      .send({ upToId: reply.id })
      .expect(200);
    expect(read.body).toEqual({ updated: 1 });
    expect((await history(worker.accessToken, jobId)).unread).toBe(0);
    const forEmployer = await history(employer.accessToken, jobId);
    expect(forEmployer.items.find((m) => m.id === reply.id)?.readAt).not.toBeNull();

    // Paginación.
    const firstPage = await history(worker.accessToken, jobId, '?limit=1');
    expect(firstPage.items).toHaveLength(1);
    const next = await history(
      worker.accessToken,
      jobId,
      `?limit=1&cursor=${firstPage.nextCursor ?? ''}`,
    );
    expect(next.items[0]?.id).toBe(sent.id);
    expect(next.nextCursor).toBeNull();
  });

  it('un mensaje prohibido queda retenido: no se entrega y quien lo envió ve un aviso neutral', async () => {
    const { jobId, worker, employer } = await assignJob(t);
    const employerLive = await connectSocket(t, employer.accessToken);
    sockets.push(employerLive);

    const held = (
      await send(worker.accessToken, jobId, 'Te consigo c.o.c.a.i.n.a barata').expect(201)
    ).body as SentMessageDto;
    expect(held).toMatchObject({
      status: 'retenido',
      notice: 'Tu mensaje no se envió porque no cumple las normas de uso de SISI.',
    });
    await send(worker.accessToken, jobId, 'Disculpa, ya voy.').expect(201);
    await employerLive.next('chat:message', (p) => p.body === 'Disculpa, ya voy.');
    expect(
      employerLive.received.some(
        (e) =>
          e.event === 'chat:message' && (e.payload as { messageId: string }).messageId === held.id,
      ),
    ).toBe(false);

    expect((await history(employer.accessToken, jobId)).items.map((m) => m.body)).toEqual([
      'Disculpa, ya voy.',
    ]);
    const mine = await history(worker.accessToken, jobId);
    expect(mine.items.find((m) => m.id === held.id)?.status).toBe('retenido');
    expect(
      await t.prisma.outboxEvent.count({
        where: { type: 'chat.message_sent', payload: { path: ['messageId'], equals: held.id } },
      }),
    ).toBe(0);

    const admin = await loginAsAdmin(t);
    const list = (
      await request(server())
        .get('/admin/chat/held')
        .set(...bearer(admin.accessToken))
        .expect(200)
    ).body as AdminHeldMessageDto[];
    expect(list.find((m) => m.id === held.id)).toMatchObject({ jobId, senderId: worker.id });
    await request(server())
      .get('/admin/chat/held')
      .set(...bearer(worker.accessToken))
      .expect(403);
  });

  it('un tercero no lee ni escribe; un mensaje vacío se rechaza', async () => {
    const { jobId, worker } = await assignJob(t);
    const stranger = await login(t);
    await request(server())
      .get(`/jobs/${jobId}/messages`)
      .set(...bearer(stranger.accessToken))
      .expect(404);
    await send(stranger.accessToken, jobId, 'hola').expect(404);
    const empty = await send(worker.accessToken, jobId, '   ').expect(400);
    expect(empty.body).toMatchObject({ code: 'MESSAGE_EMPTY' });
    await send(worker.accessToken, jobId, 'x'.repeat(1001)).expect(400);
  });

  it('después de terminado queda abierto un rato y luego en solo lectura', async () => {
    const { jobId, worker, employer } = await assignJob(t);
    for (const step of ['on-the-way', 'start', 'finish']) {
      await request(server())
        .post(`/jobs/${jobId}/${step}`)
        .set(...bearer(worker.accessToken))
        .expect(200);
    }
    await request(server())
      .post(`/jobs/${jobId}/confirm`)
      .set(...bearer(employer.accessToken))
      .expect(200);
    await send(employer.accessToken, jobId, '¡Gracias!').expect(201);
    expect((await history(employer.accessToken, jobId)).closesAt).not.toBeNull();

    // En e2e la ventana es de 2 s (JOB_CHAT_OPEN_AFTER_MS).
    await new Promise((r) => setTimeout(r, 2100));
    const closed = await send(worker.accessToken, jobId, 'De nada').expect(409);
    expect(closed.body).toMatchObject({ code: 'CHAT_CLOSED' });
    const after = await history(worker.accessToken, jobId);
    expect(after).toMatchObject({ open: false });
    expect(after.items.map((m) => m.body)).toEqual(['¡Gracias!']);
  });
});
