import type { Server } from 'node:http';
import type { AddressInfo } from 'node:net';
import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import type { Redis } from 'ioredis';
import request from 'supertest';
import type { App } from 'supertest/types';
import { AppModule } from '../../src/app.module';
import { setupApp } from '../../src/app.setup';
import type { LoginResponseDto } from '../../src/auth/dto/auth.dto';
import { OTP_PROVIDER, type OtpProvider } from '../../src/auth/otp/otp-provider';
import { TokenService } from '../../src/auth/tokens/token.service';
import { PrismaService } from '../../src/prisma/prisma.service';
import { REDIS_CLIENT } from '../../src/redis/redis.constants';
import { WorkerModule } from '../../src/worker/worker.module';
import { uniqueIp, uniquePhone, uniqueSuffix } from './unique';

export interface TestApp {
  app: INestApplication<App>;
  prisma: PrismaService;
  /** Último código que el ConsoleOtpProvider "envió" a cada teléfono. */
  codes: Map<string, string>;
  /** URL base del servidor HTTP (para clientes Socket.IO). */
  url: string;
  close(): Promise<void>;
}

/**
 * Levanta la API completa contra Postgres, Redis y S3 reales, espiando el proveedor de consola.
 * Con `worker: true` también levanta en el mismo proceso lo que corre en el worker de Render
 * (relay del outbox y colas BullMQ con prefijo de e2e), con tiempos en milisegundos.
 */
export async function createTestApp(opts: { worker?: boolean } = {}): Promise<TestApp> {
  const imports = opts.worker ? [AppModule, WorkerModule] : [AppModule];
  const moduleRef = await Test.createTestingModule({ imports }).compile();
  const app = moduleRef.createNestApplication<INestApplication<App>>({ logger: ['error'] });
  setupApp(app);
  // Escucha en un puerto libre: los tests de tiempo real conectan clientes Socket.IO.
  await app.listen(0, '127.0.0.1');
  const address = (app.getHttpServer() as unknown as Server).address() as AddressInfo;

  const codes = new Map<string, string>();
  const provider = app.get<OtpProvider>(OTP_PROVIDER);
  if (provider.name !== 'console') throw new Error('Los e2e deben usar el ConsoleOtpProvider');
  const send = provider.send.bind(provider);
  jest.spyOn(provider, 'send').mockImplementation(async (phone, code) => {
    codes.set(phone, code);
    await send(phone, code);
  });

  return {
    app,
    prisma: app.get(PrismaService),
    codes,
    url: `http://127.0.0.1:${address.port}`,
    close: () => app.close(),
  };
}

export { uniqueIp, uniquePhone, uniqueSuffix } from './unique';

export const e164 = (local: string): string => `+591${local}`;

/** Login completo: pide el código, lo lee del ConsoleOtpProvider y lo verifica. */
export async function login(t: TestApp, phone = uniquePhone()): Promise<LoginResponseDto> {
  const ip = uniqueIp();
  const server = t.app.getHttpServer();
  await request(server)
    .post('/auth/otp/request')
    .set('X-Forwarded-For', ip)
    .send({ phone })
    .expect(202);
  const code = t.codes.get(e164(phone));
  if (!code) throw new Error('El ConsoleOtpProvider no recibió el código');
  const res = await request(server)
    .post('/auth/otp/verify')
    .set('X-Forwarded-For', ip)
    .send({ phone, code })
    .expect(200);
  return res.body as LoginResponseDto;
}

/** Borra los cooldowns de pedido de código (para un segundo login del mismo número). */
export async function resetPhoneCooldowns(t: TestApp): Promise<void> {
  const redis = t.app.get<Redis>(REDIS_CLIENT);
  const keys = await redis.keys('rl:otp:phone:*:cooldown');
  if (keys.length > 0) await redis.del(...keys);
}

/** Categoría de prueba (slug único) habilitada en Santa Cruz, salvo que se indique otra cosa. */
export async function createCategory(
  t: TestApp,
  opts: { active?: boolean; activeInCity?: boolean; cityId?: string; priceMinBs?: string } = {},
): Promise<{ id: string; slug: string }> {
  const cityId =
    opts.cityId ?? (await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } })).id;
  const slug = `e2e-${uniqueSuffix()}`;
  return t.prisma.category.create({
    data: {
      slug,
      name: `Categoría ${slug}`,
      priceMinBs: opts.priceMinBs ?? '80.00',
      priceMaxBs: '300.00',
      active: opts.active ?? true,
      cities: { create: { cityId, active: opts.activeInCity ?? true } },
    },
    select: { id: true, slug: true },
  });
}

export type AdminSession = LoginResponseDto & {
  /** Token de la app de la misma cuenta (rutas de usuario: un admin también puede ser trabajador). */
  appAccessToken: string;
};

/**
 * Cuenta con rol admin. `accessToken` es de una sesión del panel (`aud=admin`, ADR-0040), la
 * única que entra a /admin; `appAccessToken` es la de la app. El rol viaja en el token, así
 * que la de la app se renueva tras asignarlo. El login del panel por HTTP (cookie) se prueba
 * en admin-auth.e2e-spec.ts.
 */
export async function loginAsAdmin(t: TestApp): Promise<AdminSession> {
  const session = await login(t);
  await t.prisma.user.update({ where: { id: session.user.id }, data: { role: 'admin' } });
  const res = await request(t.app.getHttpServer())
    .post('/auth/refresh')
    .set('X-Forwarded-For', uniqueIp())
    .send({ refreshToken: session.refreshToken })
    .expect(200);
  const tokens = res.body as { accessToken: string; refreshToken: string };
  const admin = await t.app
    .get(TokenService)
    .issue({ id: session.user.id, role: 'admin' }, 'admin');
  session.user.role = 'admin';
  return Object.assign(session, {
    accessToken: admin.accessToken,
    refreshToken: tokens.refreshToken,
    appAccessToken: tokens.accessToken,
  });
}

/**
 * Hace admin a una cuenta existente (p. ej. el empleador o el trabajador de un trabajo) y
 * devuelve un token del panel para ella: sirve para probar la autorrevisión.
 */
export async function promoteToAdmin(t: TestApp, userId: string): Promise<string> {
  await t.prisma.user.update({ where: { id: userId }, data: { role: 'admin' } });
  return (await t.app.get(TokenService).issue({ id: userId, role: 'admin' }, 'admin')).accessToken;
}

export const bearer = (token: string): [string, string] => ['Authorization', `Bearer ${token}`];

/** Espera hasta que `check` devuelva un valor distinto de undefined (o falla al vencer). */
export async function waitFor<T>(
  check: () => Promise<T | undefined>,
  { timeoutMs = 5000, everyMs = 25, what = 'la condición' } = {},
): Promise<T> {
  const deadline = Date.now() + timeoutMs;
  for (;;) {
    const value = await check();
    if (value !== undefined) return value;
    if (Date.now() > deadline) throw new Error(`Se agotó la espera de ${what} (${timeoutMs} ms)`);
    await new Promise((r) => setTimeout(r, everyMs));
  }
}
