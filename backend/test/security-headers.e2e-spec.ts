import { io } from 'socket.io-client';
import request from 'supertest';
import { createTestApp, login, type TestApp } from './utils/test-app';

/** Headers de seguridad y origen del socket (ADR-0047). */
describe('Headers de seguridad (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  it('toda respuesta lleva nosniff, DENY, CSP vacía y no-store; sin X-Powered-By', async () => {
    const res = await request(t.url).get('/health').expect(200);
    expect(res.headers['x-content-type-options']).toBe('nosniff');
    expect(res.headers['x-frame-options']).toBe('DENY');
    expect(res.headers['referrer-policy']).toBe('no-referrer');
    expect(res.headers['content-security-policy']).toBe(
      "default-src 'none'; frame-ancestors 'none'",
    );
    expect(res.headers['cache-control']).toBe('no-store');
    expect(res.headers['x-powered-by']).toBeUndefined();
    // En test (http) no se envía HSTS.
    expect(res.headers['strict-transport-security']).toBeUndefined();
  });

  it('CORS: un origen desconocido no recibe Access-Control-Allow-Origin', async () => {
    const res = await request(t.url).get('/health').set('Origin', 'https://malicioso.example');
    expect(res.headers['access-control-allow-origin']).toBeUndefined();
    const ok = await request(t.url).get('/health').set('Origin', 'http://localhost:8080');
    expect(ok.headers['access-control-allow-origin']).toBe('http://localhost:8080');
  });

  const handshake = (origin: string | undefined, token: string) =>
    new Promise<'ok' | 'rechazado'>((resolve) => {
      const socket = io(t.url, {
        auth: { token },
        transports: ['websocket'],
        reconnection: false,
        forceNew: true,
        extraHeaders: origin ? { Origin: origin } : {},
      });
      socket.on('connect', () => {
        socket.close();
        resolve('ok');
      });
      socket.on('connect_error', () => {
        socket.close();
        resolve('rechazado');
      });
    });

  it('socket: rechaza un navegador de otro origen; acepta la app nativa y los orígenes de CORS', async () => {
    const { accessToken } = await login(t);
    expect(await handshake('https://malicioso.example', accessToken)).toBe('rechazado');
    expect(await handshake(undefined, accessToken)).toBe('ok');
    expect(await handshake('http://localhost:8080', accessToken)).toBe('ok');
  });
});
