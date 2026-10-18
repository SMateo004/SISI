import request from 'supertest';
import type { AdminSessionDto } from '../src/auth/dto/auth.dto';
import { TokenService } from '../src/auth/tokens/token.service';
import { uniqueIp, uniquePhone } from './utils/unique';
import {
  bearer,
  createTestApp,
  e164,
  login,
  resetPhoneCooldowns,
  type TestApp,
} from './utils/test-app';

/** Sesión del panel (ADR-0040): cookie httpOnly, aud=admin y máximo de 8 h. */
describe('Sesión del panel admin (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  const server = () => t.app.getHttpServer();

  /** Pide el código y entra al panel con él. */
  async function adminLogin(phone: string, status: number) {
    const ip = uniqueIp();
    await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', ip)
      .send({ phone })
      .expect(202);
    const code = t.codes.get(e164(phone));
    return request(server())
      .post('/auth/admin/otp/verify')
      .set('X-Forwarded-For', ip)
      .send({ phone, code })
      .expect(status);
  }

  const cookieOf = (res: request.Response): string => {
    const raw = res.headers['set-cookie'] as unknown as string[] | undefined;
    const cookie = raw?.find((c) => c.startsWith('sisi_admin_rt='));
    if (!cookie) throw new Error('No llegó la cookie del refresh admin');
    return cookie;
  };
  const cookiePair = (setCookie: string): string => setCookie.split(';')[0] ?? '';

  /** Cuenta admin ya existente (el panel no crea cuentas). */
  async function adminAccount() {
    const session = await login(t);
    await t.prisma.user.update({ where: { id: session.user.id }, data: { role: 'admin' } });
    // Segundo pedido de código para el mismo número: se limpia su espera.
    await resetPhoneCooldowns(t);
    return session;
  }

  it('un admin entra: token de acceso de 10 min, refresh solo en cookie httpOnly y Strict', async () => {
    const session = await adminAccount();
    const phone = session.user.phone.replace('+591', '');
    const res = await adminLogin(phone, 200);
    const body = res.body as Record<string, unknown>;
    expect(body.expiresIn).toBe(600);
    expect(body.refreshToken).toBeUndefined();
    expect(Date.parse(body.sessionExpiresAt as string) - Date.now()).toBeGreaterThan(
      7.9 * 3600_000,
    );
    const cookie = cookieOf(res);
    expect(cookie).toMatch(/HttpOnly/i);
    expect(cookie).toMatch(/Secure/i);
    expect(cookie).toMatch(/SameSite=Strict/i);
    expect(cookie).toMatch(/Path=\/api\/auth\/admin/);
    expect(res.headers['cache-control']).toBe('no-store');

    // Entra a /admin con el token del panel, pero no a las rutas de la app.
    const access = body.accessToken as string;
    await request(server())
      .get('/admin/feature-flags')
      .set(...bearer(access))
      .expect(200);
    const scope = await request(server())
      .get('/me')
      .set(...bearer(access))
      .expect(403);
    expect(scope.body).toMatchObject({ code: 'ADMIN_SESSION_SCOPE' });
  });

  it('una cuenta sin rol admin (o inexistente) no entra y no se crea', async () => {
    const session = await login(t);
    await resetPhoneCooldowns(t);
    const res = await adminLogin(session.user.phone.replace('+591', ''), 403);
    expect(res.body).toMatchObject({ code: 'ADMIN_ONLY' });
    expect(res.headers['set-cookie']).toBeUndefined();

    const fresh = uniquePhone();
    await adminLogin(fresh, 403);
    expect(await t.prisma.user.findUnique({ where: { phone: e164(fresh) } })).toBeNull();
  });

  it('el token de la app de un admin no entra a /admin', async () => {
    const session = await adminAccount();
    const app = await t.app.get(TokenService).issue({ id: session.user.id, role: 'admin' });
    const res = await request(server())
      .get('/admin/feature-flags')
      .set(...bearer(app.accessToken))
      .expect(403);
    expect(res.body).toMatchObject({ code: 'ADMIN_SESSION_REQUIRED' });
  });

  it('refresh con la cookie y el header CSRF; reutilizarlo revoca la sesión', async () => {
    const session = await adminAccount();
    const login1 = await adminLogin(session.user.phone.replace('+591', ''), 200);
    const first = cookiePair(cookieOf(login1));

    // Sin el header X-SISI-Admin: 403 (un formulario de otro sitio no puede enviarlo).
    const csrf = await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', first)
      .set('X-Forwarded-For', uniqueIp())
      .expect(403);
    expect(csrf.body).toMatchObject({ code: 'CSRF_HEADER_REQUIRED' });

    const refreshed = await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', first)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(200);
    const second = cookiePair(cookieOf(refreshed));
    expect(second).not.toBe(first);
    // No se extiende: sigue terminando a las 8 h del login.
    expect(
      Math.abs(
        Date.parse((refreshed.body as AdminSessionDto).sessionExpiresAt) -
          Date.parse((login1.body as AdminSessionDto).sessionExpiresAt),
      ),
    ).toBeLessThan(2000);

    // Reutilizar el primero revoca toda la familia: el segundo tampoco sirve.
    await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', first)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(401);
    await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', second)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(401);
  });

  it('un refresh de la app no sirve en el panel, ni uno del panel en la app', async () => {
    const session = await adminAccount();
    await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', `sisi_admin_rt=${session.refreshToken}`)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(401);

    const admin = await t.app
      .get(TokenService)
      .issue({ id: session.user.id, role: 'admin' }, 'admin');
    await request(server())
      .post('/auth/refresh')
      .set('X-Forwarded-For', uniqueIp())
      .send({ refreshToken: admin.refreshToken })
      .expect(401);
  });

  it('si la cuenta deja de ser admin, el siguiente refresh termina la sesión', async () => {
    const session = await adminAccount();
    const res = await adminLogin(session.user.phone.replace('+591', ''), 200);
    await t.prisma.user.update({ where: { id: session.user.id }, data: { role: 'user' } });
    await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', cookiePair(cookieOf(res)))
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(401);
  });

  it('logout revoca el refresh y borra la cookie', async () => {
    const session = await adminAccount();
    const res = await adminLogin(session.user.phone.replace('+591', ''), 200);
    const cookie = cookiePair(cookieOf(res));
    const out = await request(server())
      .post('/auth/admin/logout')
      .set('Cookie', cookie)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(204);
    expect(cookieOf(out)).toMatch(/Expires=Thu, 01 Jan 1970/);
    await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', cookie)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(401);
  });
});
