import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import type { Redis } from 'ioredis';
import request from 'supertest';
import type { App } from 'supertest/types';
import { AppModule } from '../../src/app.module';
import { setupApp } from '../../src/app.setup';
import type { LoginResponseDto } from '../../src/auth/dto/auth.dto';
import { OTP_PROVIDER, type OtpProvider } from '../../src/auth/otp/otp-provider';
import { PrismaService } from '../../src/prisma/prisma.service';
import { REDIS_CLIENT } from '../../src/redis/redis.constants';
import { uniqueIp, uniquePhone, uniqueSuffix } from './unique';

export interface TestApp {
  app: INestApplication<App>;
  prisma: PrismaService;
  /** Último código que el ConsoleOtpProvider "envió" a cada teléfono. */
  codes: Map<string, string>;
  close(): Promise<void>;
}

/** Levanta la API completa contra Postgres, Redis y S3 reales, espiando el proveedor de consola. */
export async function createTestApp(): Promise<TestApp> {
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
  const app = moduleRef.createNestApplication<INestApplication<App>>({ logger: ['error'] });
  setupApp(app);
  await app.init();

  const codes = new Map<string, string>();
  const provider = app.get<OtpProvider>(OTP_PROVIDER);
  if (provider.name !== 'console') throw new Error('Los e2e deben usar el ConsoleOtpProvider');
  const send = provider.send.bind(provider);
  jest.spyOn(provider, 'send').mockImplementation(async (phone, code) => {
    codes.set(phone, code);
    await send(phone, code);
  });

  return { app, prisma: app.get(PrismaService), codes, close: () => app.close() };
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

/** Sesión con rol admin: el rol viaja en el token, así que se renueva tras asignarlo. */
export async function loginAsAdmin(t: TestApp): Promise<LoginResponseDto> {
  const session = await login(t);
  await t.prisma.user.update({ where: { id: session.user.id }, data: { role: 'admin' } });
  const res = await request(t.app.getHttpServer())
    .post('/auth/refresh')
    .set('X-Forwarded-For', uniqueIp())
    .send({ refreshToken: session.refreshToken })
    .expect(200);
  const tokens = res.body as { accessToken: string; refreshToken: string };
  session.accessToken = tokens.accessToken;
  session.refreshToken = tokens.refreshToken;
  session.user.role = 'admin';
  return session;
}

export const bearer = (token: string): [string, string] => ['Authorization', `Bearer ${token}`];
