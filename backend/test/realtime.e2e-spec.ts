import { io } from 'socket.io-client';
import { JwtService } from '@nestjs/jwt';
import { RealtimeEmitter } from '../src/realtime/realtime.emitter';
import { connectSocket, type TestSocket } from './utils/socket';
import { createTestApp, login, type TestApp, waitFor } from './utils/test-app';

describe('Tiempo real: Socket.IO (e2e, ADR-0023)', () => {
  let t: TestApp;
  let emitter: RealtimeEmitter;
  const sockets: TestSocket[] = [];

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    emitter = t.app.get(RealtimeEmitter);
  });

  afterEach(() => {
    for (const s of sockets.splice(0)) s.close();
  });

  afterAll(async () => {
    await t.close();
  });

  const connect = async (token: string | undefined) => {
    const s = await connectSocket(t, token);
    sockets.push(s);
    return s;
  };

  it('rechaza el handshake sin token o con un token inválido', async () => {
    await expect(connect(undefined)).rejects.toMatchObject({ code: 'UNAUTHENTICATED' });
    await expect(connect('no-es-un-jwt')).rejects.toMatchObject({ code: 'TOKEN_INVALID' });
  });

  it('solo acepta websocket: un cliente con long-polling no se conecta', async () => {
    const a = await login(t);
    const polling = io(t.url, {
      auth: { token: a.accessToken },
      transports: ['polling'],
      reconnection: false,
      forceNew: true,
    });
    const result = await new Promise<string>((resolve) => {
      polling.once('connect', () => {
        resolve('connected');
      });
      polling.once('connect_error', () => {
        resolve('rejected');
      });
    });
    polling.close();
    expect(result).toBe('rejected');
  });

  it('con token válido entra a su sala y recibe lo que emite el worker (redis-emitter)', async () => {
    const a = await login(t);
    const b = await login(t);
    const sa = await connect(a.accessToken);
    const sb = await connect(b.accessToken);

    emitter.toUser(a.user.id, 'request:expired', { requestId: 'r-a' });
    expect(await sa.next('request:expired')).toEqual({ requestId: 'r-a' });

    // Solo a su sala: el otro usuario no lo recibe.
    await new Promise((r) => setTimeout(r, 150));
    expect(sb.received).toHaveLength(0);
  });

  it('el servidor une sockets a la sala de una solicitud y la vacía al cerrarla', async () => {
    const a = await login(t);
    const b = await login(t);
    const c = await login(t);
    const [sa, sb, sc] = await Promise.all([a, b, c].map((u) => connect(u.accessToken)));
    if (!sa || !sb || !sc) throw new Error('sin sockets');

    emitter.joinRequest([a.user.id, b.user.id], 'r-sala');
    // El join viaja por Redis: se reintenta hasta que el aviso llegue.
    await waitFor(
      async () => {
        emitter.toRequest('r-sala', 'offer:closed', { requestId: 'r-sala', reason: 'cancelada' });
        await new Promise((r) => setTimeout(r, 50));
        return sa.received.length > 0 ? true : undefined;
      },
      { what: 'el aviso a la sala' },
    );
    await sb.next('offer:closed');
    expect(sc.received).toHaveLength(0);

    // El leave también viaja por Redis: se reintenta hasta que un aviso a la sala ya no llegue.
    emitter.leaveRequest('r-sala');
    const expiredCount = () => sa.received.filter((r) => r.event === 'request:expired').length;
    await waitFor(
      async () => {
        const before = expiredCount();
        emitter.toRequest('r-sala', 'request:expired', { requestId: 'r-sala' });
        await new Promise((r) => setTimeout(r, 150));
        return expiredCount() === before ? true : undefined;
      },
      { what: 'que la sala quede vacía' },
    );
  });

  it('corta el socket cuando vence el token de acceso', async () => {
    const a = await login(t);
    const shortLived = await t.app
      .get(JwtService)
      .signAsync({ sub: a.user.id, role: 'user', typ: 'access' }, { expiresIn: 1 });
    const s = await connect(shortLived);

    const reason = await new Promise<string>((resolve) => s.socket.once('disconnect', resolve));
    expect(reason).toBe('io server disconnect');
  });
});
