import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { ADMIN_PERMISSIONS } from '../src/common/admin/admin-permissions';
import { type RegisteredRoute, registeredRoutes } from './utils/routes';
import { bearer, createTestApp, login, loginAsAdmin, type TestApp } from './utils/test-app';
import { uniqueIp } from './utils/unique';

type AdminRoute = RegisteredRoute;

/** Las rutas /admin registradas en Nest (una ruta nueva entra sola al barrido). */
const adminRoutes = (t: TestApp): AdminRoute[] =>
  registeredRoutes(t).filter((r) => r.path.startsWith('/admin'));

/** Parámetros de ruta con valores válidos de forma (uuid), para pasar los pipes. */
const concrete = (path: string): string => path.replace(/:[A-Za-z]+/g, () => randomUUID());

describe('Barrido de rutas /admin (e2e, ADR-0040)', () => {
  let t: TestApp;
  let routes: AdminRoute[];

  beforeAll(async () => {
    t = await createTestApp();
    routes = adminRoutes(t);
  });

  afterAll(async () => {
    await t.close();
  });

  it('encuentra las rutas del panel', () => {
    // Las 26 de las fases 1 a 5; el umbral sube con cada ruta nueva del panel.
    expect(routes.length).toBeGreaterThanOrEqual(26);
    expect(routes.map((r) => `${r.method} ${r.path}`)).toContain('post /admin/billing/payments');
  });

  it('toda ruta /admin exige rol admin y declara un permiso válido', () => {
    const problems = routes
      .filter(
        (r) =>
          !r.roles?.includes('admin') ||
          !(ADMIN_PERMISSIONS as readonly string[]).includes(r.permission ?? ''),
      )
      .map(
        (r) =>
          `${r.method.toUpperCase()} ${r.path} (roles=${String(r.roles)}, permiso=${String(r.permission)})`,
      );
    expect(problems).toEqual([]);
  });

  it('sin token: 401 en todas', async () => {
    const server = t.app.getHttpServer();
    const wrong: string[] = [];
    for (const r of routes) {
      const res = await request(server)
        [r.method as 'get'](concrete(r.path))
        .set('X-Forwarded-For', uniqueIp())
        .send({});
      if (res.status !== 401) wrong.push(`${r.method.toUpperCase()} ${r.path} → ${res.status}`);
    }
    expect(wrong).toEqual([]);
  });

  it('con un usuario sin rol admin: 403 en todas', async () => {
    const server = t.app.getHttpServer();
    const user = await login(t);
    const wrong: string[] = [];
    for (const r of routes) {
      const res = await request(server)
        [r.method as 'get'](concrete(r.path))
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(user.accessToken))
        .send({});
      if (res.status !== 403) wrong.push(`${r.method.toUpperCase()} ${r.path} → ${res.status}`);
    }
    expect(wrong).toEqual([]);
  });

  it('con la sesión de la app de un admin: 403 ADMIN_SESSION_REQUIRED en todas', async () => {
    const server = t.app.getHttpServer();
    const admin = await loginAsAdmin(t);
    const wrong: string[] = [];
    for (const r of routes) {
      const res = await request(server)
        [r.method as 'get'](concrete(r.path))
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(admin.appAccessToken))
        .send({});
      const code = (res.body as { code?: string }).code;
      if (res.status !== 403 || code !== 'ADMIN_SESSION_REQUIRED') {
        wrong.push(`${r.method.toUpperCase()} ${r.path} → ${res.status} ${String(code)}`);
      }
    }
    expect(wrong).toEqual([]);
  });
});
