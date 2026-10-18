import { randomUUID } from 'node:crypto';
import { RequestMethod } from '@nestjs/common';
import { METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { DiscoveryService, MetadataScanner, ModulesContainer, Reflector } from '@nestjs/core';
import request from 'supertest';
import { ROLES_KEY } from '../src/auth/decorators/auth.decorators';
import { ADMIN_PERMISSION_KEY, ADMIN_PERMISSIONS } from '../src/common/admin/admin-permissions';
import { bearer, createTestApp, login, loginAsAdmin, type TestApp } from './utils/test-app';
import { uniqueIp } from './utils/unique';

interface AdminRoute {
  method: string;
  path: string;
  roles: string[] | undefined;
  permission: string | undefined;
}

const METHODS: Partial<Record<RequestMethod, string>> = {
  [RequestMethod.GET]: 'get',
  [RequestMethod.POST]: 'post',
  [RequestMethod.PUT]: 'put',
  [RequestMethod.PATCH]: 'patch',
  [RequestMethod.DELETE]: 'delete',
};

const join = (...parts: string[]): string =>
  `/${parts
    .flatMap((p) => p.split('/'))
    .filter(Boolean)
    .join('/')}`;

/**
 * Todas las rutas /admin que Nest registró, leídas de los metadatos de los controladores
 * (así una ruta nueva entra sola al barrido).
 */
function adminRoutes(t: TestApp): AdminRoute[] {
  const discovery = new DiscoveryService(t.app.get(ModulesContainer));
  const scanner = new MetadataScanner();
  const reflector = new Reflector();
  const routes: AdminRoute[] = [];
  for (const wrapper of discovery.getControllers()) {
    const instance = wrapper.instance as object | undefined;
    const metatype = wrapper.metatype as (abstract new (...args: never[]) => unknown) | null;
    if (!instance || !metatype) continue;
    const prefixes = [
      reflector.get<string | string[] | undefined>(PATH_METADATA, metatype) ?? '',
    ].flat();
    const proto = Object.getPrototypeOf(instance) as Record<string, unknown>;
    for (const name of scanner.getAllMethodNames(proto)) {
      const handler = proto[name] as (...args: unknown[]) => unknown;
      const method = reflector.get<RequestMethod | undefined>(METHOD_METADATA, handler);
      const verb = method === undefined ? undefined : METHODS[method];
      if (!verb) continue;
      const paths = [
        reflector.get<string | string[] | undefined>(PATH_METADATA, handler) ?? '',
      ].flat();
      for (const prefix of prefixes) {
        for (const path of paths) {
          const full = join(prefix, path);
          if (!full.startsWith('/admin')) continue;
          routes.push({
            method: verb,
            path: full,
            roles: reflector.getAllAndOverride<string[] | undefined>(ROLES_KEY, [
              handler,
              metatype,
            ]),
            permission: reflector.getAllAndOverride<string | undefined>(ADMIN_PERMISSION_KEY, [
              handler,
              metatype,
            ]),
          });
        }
      }
    }
  }
  return routes;
}

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
