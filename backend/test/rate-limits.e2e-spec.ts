import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';

/**
 * Límites por usuario revisados en la Fase 7 (ADR-0047): reportes, URLs de subida y
 * dispositivos. Cuentan aunque la petición falle después (el guard corre antes del handler).
 */
describe('Límites por usuario (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  const flood = async (times: number, send: () => Promise<request.Response>): Promise<number[]> => {
    const statuses: number[] = [];
    for (let i = 0; i < times; i++) statuses.push((await send()).status);
    return statuses;
  };

  it('reportes: 10 por hora por usuario, luego 429; otro usuario no se ve afectado', async () => {
    const a = await login(t);
    const b = await login(t);
    const report = (token: string) =>
      request(t.url)
        .post('/reports')
        .set(...bearer(token))
        .send({ targetType: 'user', targetId: randomUUID(), reason: 'otro', note: 'prueba' });
    const statuses = await flood(11, () => report(a.accessToken));
    expect(statuses.slice(0, 10).every((s) => s !== 429)).toBe(true);
    expect(statuses[10]).toBe(429);
    expect((await report(b.accessToken)).status).not.toBe(429);
  });

  it('URLs de subida: 60 por hora por usuario', async () => {
    const a = await login(t);
    const statuses = await flood(61, () =>
      request(t.url)
        .post('/me/photo/upload-url')
        .set(...bearer(a.accessToken))
        .send({ contentType: 'image/jpeg', sizeBytes: 1000 }),
    );
    expect(statuses.slice(0, 60).every((s) => s === 201)).toBe(true);
    expect(statuses[60]).toBe(429);
  });

  it('dispositivos: 20 registros por hora por usuario', async () => {
    const a = await login(t);
    const statuses = await flood(21, () =>
      request(t.url)
        .post('/me/devices')
        .set(...bearer(a.accessToken))
        .send({ token: `tok-${randomUUID()}`, platform: 'android' }),
    );
    expect(statuses.slice(0, 20).every((s) => s < 300)).toBe(true);
    expect(statuses[20]).toBe(429);
  });
});
