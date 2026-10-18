import type { Redis } from 'ioredis';
import request from 'supertest';
import { ADMIN_ACCOUNT_PHONE } from '../src/auth/admin-login.service';
import { base32Decode, totpAt, totpStep } from '../src/auth/admin-totp';
import type { AdminSessionDto } from '../src/auth/dto/auth.dto';
import { TokenService } from '../src/auth/tokens/token.service';
import { REDIS_CLIENT } from '../src/redis/redis.constants';
import { E2E_ADMIN_TOTP_SECRET } from './e2e-env';
import { uniqueIp } from './utils/unique';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';

/**
 * Sesión del panel (ADR-0040) con la cuenta única del panel: usuario fijo y código de una app
 * autenticadora, sin teléfono (ADR-0055). Cookie httpOnly, aud=admin y máximo de 8 h.
 */
describe('Sesión del panel admin (e2e)', () => {
  let t: TestApp;
  let redis: Redis;

  beforeAll(async () => {
    t = await createTestApp();
    redis = t.app.get<Redis>(REDIS_CLIENT);
  });

  afterAll(async () => {
    await t.close();
  });

  const server = () => t.app.getHttpServer();
  const currentCode = (offsetSteps = 0): string =>
    totpAt(base32Decode(E2E_ADMIN_TOTP_SECRET), totpStep(Date.now()) + offsetSteps);

  /** Los códigos sirven una vez y hay un tope de intentos global: cada prueba empieza limpia. */
  async function resetAdminLogin(): Promise<void> {
    const used = await redis.keys('admin:totp:used:*');
    if (used.length > 0) await redis.del(...used);
    await redis.del('rl:adminLogin:all');
  }

  function panelLogin(status: number, body: { username?: string; code?: string } = {}) {
    return request(server())
      .post('/auth/admin/login')
      .set('X-Forwarded-For', uniqueIp())
      .send({ username: body.username ?? 'admin', code: body.code ?? currentCode() })
      .expect(status);
  }

  beforeEach(resetAdminLogin);

  const cookieOf = (res: request.Response): string => {
    const raw = res.headers['set-cookie'] as unknown as string[] | undefined;
    const cookie = raw?.find((c) => c.startsWith('sisi_admin_rt='));
    if (!cookie) throw new Error('No llegó la cookie del refresh admin');
    return cookie;
  };
  const cookiePair = (setCookie: string): string => setCookie.split(';')[0] ?? '';

  it('entra con usuario y código: cuenta del panel sin teléfono, refresh solo en cookie', async () => {
    const res = await panelLogin(200, { username: '  Admin ' });
    const body = res.body as AdminSessionDto & Record<string, unknown>;
    expect(body.expiresIn).toBe(600);
    expect(body.refreshToken).toBeUndefined();
    expect(Date.parse(body.sessionExpiresAt) - Date.now()).toBeGreaterThan(7.9 * 3600_000);
    expect(body.user).toMatchObject({ role: 'admin', name: 'Administrador' });

    const account = await t.prisma.user.findUniqueOrThrow({
      where: { phone: ADMIN_ACCOUNT_PHONE },
    });
    expect(account.id).toBe(body.user.id);
    expect(t.codes.get(ADMIN_ACCOUNT_PHONE)).toBeUndefined();

    const cookie = cookieOf(res);
    expect(cookie).toMatch(/HttpOnly/i);
    expect(cookie).toMatch(/Secure/i);
    expect(cookie).toMatch(/SameSite=Strict/i);
    expect(cookie).toMatch(/Path=\/api\/auth\/admin/);
    expect(res.headers['cache-control']).toBe('no-store');

    // Entra a /admin con el token del panel, pero no a las rutas de la app.
    await request(server())
      .get('/admin/feature-flags')
      .set(...bearer(body.accessToken))
      .expect(200);
    const scope = await request(server())
      .get('/me')
      .set(...bearer(body.accessToken))
      .expect(403);
    expect(scope.body).toMatchObject({ code: 'ADMIN_SESSION_SCOPE' });

    // Ingresar otra vez usa la misma cuenta (no crea otra).
    await resetAdminLogin();
    const again = await panelLogin(200);
    expect((again.body as AdminSessionDto).user.id).toBe(body.user.id);
  });

  it('usuario o código incorrectos: 401 sin cookie; acepta el código anterior y el siguiente', async () => {
    const wrongUser = await panelLogin(401, { username: 'root' });
    expect(wrongUser.body).toMatchObject({ code: 'ADMIN_LOGIN_INVALID' });
    expect(wrongUser.headers['set-cookie']).toBeUndefined();

    const wrongCode = await panelLogin(401, { code: currentCode(-5) });
    expect(wrongCode.body).toMatchObject({ code: 'ADMIN_LOGIN_INVALID' });

    const invalid = await panelLogin(400, { code: '12ab' });
    expect(invalid.body).toMatchObject({ code: 'VALIDATION_ERROR' });

    // Reloj del teléfono algo corrido: un paso de cada lado.
    await panelLogin(200, { code: currentCode(-1) });
    await panelLogin(200, { code: currentCode(1) });
  });

  it('un código sirve una sola vez', async () => {
    const code = currentCode();
    await panelLogin(200, { code });
    const reused = await panelLogin(401, { code });
    expect(reused.body).toMatchObject({ code: 'ADMIN_CODE_USED' });
  });

  it('tope de intentos sumando todas las IP (una sola cuenta)', async () => {
    const limit = 20;
    for (let i = 0; i < limit; i++) await panelLogin(401, { code: currentCode(-5) });
    const blocked = await panelLogin(429);
    expect(blocked.body).toMatchObject({ code: 'RATE_LIMITED' });
    expect(blocked.headers['retry-after']).toBeDefined();
  });

  it('ya no se entra al panel con el teléfono', async () => {
    const session = await login(t);
    await t.prisma.user.update({ where: { id: session.user.id }, data: { role: 'admin' } });
    await request(server())
      .post('/auth/admin/otp/verify')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone: session.user.phone, code: '123456' })
      .expect(404);
  });

  it('el token de la app de un admin no entra a /admin', async () => {
    const session = await login(t);
    const app = await t.app.get(TokenService).issue({ id: session.user.id, role: 'admin' });
    const res = await request(server())
      .get('/admin/feature-flags')
      .set(...bearer(app.accessToken))
      .expect(403);
    expect(res.body).toMatchObject({ code: 'ADMIN_SESSION_REQUIRED' });
  });

  it('refresh con la cookie y el header CSRF; reutilizarlo revoca la sesión', async () => {
    const login1 = await panelLogin(200);
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
    const session = await login(t);
    await request(server())
      .post('/auth/admin/refresh')
      .set('Cookie', `sisi_admin_rt=${session.refreshToken}`)
      .set('X-SISI-Admin', '1')
      .set('X-Forwarded-For', uniqueIp())
      .expect(401);

    const panel = cookiePair(cookieOf(await panelLogin(200)));
    await request(server())
      .post('/auth/refresh')
      .set('X-Forwarded-For', uniqueIp())
      .send({ refreshToken: panel.replace('sisi_admin_rt=', '') })
      .expect(401);
  });

  it('la cuenta del panel no puede dejar de ser admin (restricción de la base)', async () => {
    await panelLogin(200);
    await expect(
      t.prisma.user.update({ where: { phone: ADMIN_ACCOUNT_PHONE }, data: { role: 'user' } }),
    ).rejects.toThrow(/users_phone_e164_check/);
  });

  it('logout revoca el refresh y borra la cookie', async () => {
    const res = await panelLogin(200);
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
