import type { Redis } from 'ioredis';
import request from 'supertest';
import type { TokensDto } from '../src/auth/dto/auth.dto';
import { REDIS_CLIENT } from '../src/redis/redis.constants';
import {
  bearer,
  createTestApp,
  e164,
  login,
  resetPhoneCooldowns,
  type TestApp,
  uniqueIp,
  uniquePhone,
} from './utils/test-app';

describe('Autenticación (e2e)', () => {
  let t: TestApp;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  it('login completo con el ConsoleOtpProvider crea la cuenta en modo employer', async () => {
    const phone = uniquePhone();
    const body = await login(t, phone);
    expect(body.isNewUser).toBe(true);
    expect(body.user).toMatchObject({ phone: e164(phone), activeMode: 'employer', role: 'user' });
    expect(body.expiresIn).toBe(900);

    const city = await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } });
    expect(body.user.cityId).toBe(city.id);

    // Segundo login: misma cuenta (R1.1). Se limpia el cooldown de 60 s del número.
    await resetPhoneCooldowns(t);
    const again = await login(t, phone);
    expect(again.isNewUser).toBe(false);
    expect(again.user.id).toBe(body.user.id);
  });

  it('el código se guarda hasheado: Redis no contiene ni el teléfono ni el código', async () => {
    const phone = uniquePhone();
    await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone })
      .expect(202);
    const code = t.codes.get(e164(phone)) ?? '';
    const client = t.app.get<Redis>(REDIS_CLIENT);
    const keys = await client.keys('otp:*');
    expect(keys.length).toBeGreaterThan(0);
    expect(keys.some((k) => k.includes(phone))).toBe(false);
    for (const key of keys) {
      expect(JSON.stringify(await client.hgetall(key))).not.toContain(code);
    }
  });

  it('rechaza un código incorrecto con un mensaje genérico', async () => {
    const phone = uniquePhone();
    const ip = uniqueIp();
    await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', ip)
      .send({ phone })
      .expect(202);
    const wrong = t.codes.get(e164(phone)) === '000000' ? '111111' : '000000';
    const res = await request(server())
      .post('/auth/otp/verify')
      .set('X-Forwarded-For', ip)
      .send({ phone, code: wrong })
      .expect(400);
    expect(res.body).toMatchObject({
      code: 'OTP_INVALID',
      message: 'Código incorrecto o vencido.',
    });
  });

  it('pedir código responde igual exista o no la cuenta', async () => {
    const withAccount = uniquePhone();
    const city = await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } });
    await t.prisma.user.create({ data: { phone: e164(withAccount), cityId: city.id } });
    const withoutAccount = uniquePhone();

    const a = await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone: withAccount });
    const b = await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone: withoutAccount });
    expect(a.status).toBe(202);
    expect(b.status).toBe(202);
    expect(b.body).toEqual(a.body);
  });

  it('refresh rota los tokens y la sesión sigue funcionando', async () => {
    const session = await login(t);
    const res = await request(server())
      .post('/auth/refresh')
      .set('X-Forwarded-For', uniqueIp())
      .send({ refreshToken: session.refreshToken })
      .expect(200);
    const tokens = res.body as TokensDto;
    expect(tokens.refreshToken).not.toBe(session.refreshToken);
    await request(server())
      .get('/me')
      .set(...bearer(tokens.accessToken))
      .expect(200);
  });

  it('reutilizar un refresh ya usado revoca toda la familia', async () => {
    const session = await login(t);
    const ip = uniqueIp();
    const rotated = (
      await request(server())
        .post('/auth/refresh')
        .set('X-Forwarded-For', ip)
        .send({ refreshToken: session.refreshToken })
        .expect(200)
    ).body as TokensDto;

    const reuse = await request(server())
      .post('/auth/refresh')
      .set('X-Forwarded-For', ip)
      .send({ refreshToken: session.refreshToken })
      .expect(401);
    expect(reuse.body).toMatchObject({ code: 'SESSION_REUSED' });

    await request(server())
      .post('/auth/refresh')
      .set('X-Forwarded-For', ip)
      .send({ refreshToken: rotated.refreshToken })
      .expect(401);
  });

  it('logout revoca la sesión', async () => {
    const session = await login(t);
    const ip = uniqueIp();
    await request(server())
      .post('/auth/logout')
      .set('X-Forwarded-For', ip)
      .send({ refreshToken: session.refreshToken })
      .expect(204);
    const res = await request(server())
      .post('/auth/refresh')
      .set('X-Forwarded-For', ip)
      .send({ refreshToken: session.refreshToken })
      .expect(401);
    expect(res.body).toMatchObject({ code: 'SESSION_REVOKED' });
  });

  it('los endpoints protegidos exigen token; /health y /docs no', async () => {
    const res = await request(server()).get('/me').expect(401);
    expect(res.body).toMatchObject({
      code: 'UNAUTHENTICATED',
      message: 'Inicia sesión para continuar.',
    });
    await request(server()).get('/me').set('Authorization', 'Bearer basura').expect(401);
    await request(server()).get('/health').expect(200);
  });

  it('valida los datos con mensajes en español', async () => {
    const res = await request(server())
      .post('/auth/otp/verify')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone: '70012345', code: '12' })
      .expect(400);
    expect(res.body).toMatchObject({
      code: 'VALIDATION_ERROR',
      message: 'El código tiene 6 dígitos.',
    });
    const foreign = await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone: '+5491123456789' })
      .expect(400);
    expect(foreign.body).toMatchObject({ code: 'PHONE_COUNTRY_NOT_ALLOWED' });
  });

  describe('rate limiting', () => {
    it('por teléfono: un código cada 60 s, con Retry-After', async () => {
      const phone = uniquePhone();
      await request(server())
        .post('/auth/otp/request')
        .set('X-Forwarded-For', uniqueIp())
        .send({ phone })
        .expect(202);
      const res = await request(server())
        .post('/auth/otp/request')
        .set('X-Forwarded-For', uniqueIp())
        .send({ phone })
        .expect(429);
      expect(res.body).toMatchObject({ code: 'RATE_LIMITED' });
      expect((res.body as { message: string }).message).toMatch(
        /^Demasiados intentos\. Intenta de nuevo en (\d+ segundos|1 minuto)\.$/,
      );
      expect(Number(res.headers['retry-after'])).toBeGreaterThan(0);
      expect(Number(res.headers['retry-after'])).toBeLessThanOrEqual(60);
    });

    it('por IP: 20 pedidos de código por hora', async () => {
      const ip = uniqueIp();
      for (let i = 0; i < 20; i++) {
        await request(server())
          .post('/auth/otp/request')
          .set('X-Forwarded-For', ip)
          .send({ phone: uniquePhone() })
          .expect(202);
      }
      const res = await request(server())
        .post('/auth/otp/request')
        .set('X-Forwarded-For', ip)
        .send({ phone: uniquePhone() })
        .expect(429);
      expect(res.headers['retry-after']).toBeDefined();
      // Otra IP no se ve afectada.
      await request(server())
        .post('/auth/otp/request')
        .set('X-Forwarded-For', uniqueIp())
        .send({ phone: uniquePhone() })
        .expect(202);
    });

    it('5 intentos fallidos invalidan el código', async () => {
      const phone = uniquePhone();
      const ip = uniqueIp();
      await request(server())
        .post('/auth/otp/request')
        .set('X-Forwarded-For', ip)
        .send({ phone })
        .expect(202);
      const good = t.codes.get(e164(phone)) ?? '';
      const bad = good === '999999' ? '888888' : '999999';
      for (let i = 0; i < 4; i++) {
        await request(server())
          .post('/auth/otp/verify')
          .set('X-Forwarded-For', ip)
          .send({ phone, code: bad })
          .expect(400);
      }
      const fifth = await request(server())
        .post('/auth/otp/verify')
        .set('X-Forwarded-For', ip)
        .send({ phone, code: bad })
        .expect(400);
      expect(fifth.body).toMatchObject({ code: 'OTP_TOO_MANY_ATTEMPTS' });
      await request(server())
        .post('/auth/otp/verify')
        .set('X-Forwarded-For', ip)
        .send({ phone, code: good })
        .expect(400);
    });
  });
});
