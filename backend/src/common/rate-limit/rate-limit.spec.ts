import type { ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { AppConfigService } from '../../config/app-config';
import { RateLimitGuard, UserRateLimitGuard } from './rate-limit.guard';
import { RATE_LIMIT_POLICIES } from './rate-limit.policies';
import type { RateLimitStore } from './rate-limit.store';
import { RateLimitedException } from './rate-limited.exception';
import { RedisThrottlerStorage } from './redis-throttler.storage';

const contextFor = (
  ip: string,
  policies: string[] | undefined,
  user?: { id: string },
): ExecutionContext => {
  const handler = (): void => undefined;
  if (policies) Reflect.defineMetadata('sisi:rate-limit', policies, handler);
  return {
    getHandler: () => handler,
    getClass: () => Object,
    switchToHttp: () => ({ getRequest: () => ({ ip, user }) }),
  } as unknown as ExecutionContext;
};

describe('RateLimitedException', () => {
  it('arma el mensaje en español según el tiempo de espera', () => {
    expect(new RateLimitedException(1).message).toContain('1 segundo');
    expect(new RateLimitedException(45).getResponse()).toMatchObject({
      statusCode: 429,
      code: 'RATE_LIMITED',
      message: 'Demasiados intentos. Intenta de nuevo en 45 segundos.',
      retryAfterSec: 45,
    });
    expect(new RateLimitedException(3600).message).toContain('60 minutos');
  });
});

describe('RateLimitGuard', () => {
  const config = { get: jest.fn((key: string) => ({ RATE_OTP_IP_PER_HOUR: 20 })[key]) };
  const store = { consume: jest.fn() };
  const guard = new RateLimitGuard(
    new Reflector(),
    store as unknown as RateLimitStore,
    config as unknown as AppConfigService,
  );

  beforeEach(() => {
    store.consume.mockReset();
  });

  it('no consulta Redis si el endpoint no declara políticas', async () => {
    await expect(guard.canActivate(contextFor('1.1.1.1', undefined))).resolves.toBe(true);
    expect(store.consume).not.toHaveBeenCalled();
  });

  it('arma la regla por IP con el límite de la configuración', async () => {
    store.consume.mockResolvedValue({ allowed: true });
    await guard.canActivate(contextFor('1.1.1.1', ['otpRequestIp']));
    expect(store.consume).toHaveBeenCalledWith([
      { key: 'otpRequestIp:ip:1.1.1.1', limit: 20, windowSec: 3600 },
    ]);
  });

  it('lanza 429 con el tiempo de espera cuando se agota', async () => {
    store.consume.mockResolvedValue({ allowed: false, retryAfterSec: 120, rule: {} });
    await expect(guard.canActivate(contextFor('1.1.1.1', ['otpRequestIp']))).rejects.toMatchObject({
      retryAfterSec: 120,
    });
  });
});

describe('UserRateLimitGuard (ADR-0047)', () => {
  const config = { get: jest.fn((key: string) => ({ RATE_REPORT_PER_HOUR: 10 })[key]) };
  const store = { consume: jest.fn() };
  const ipGuard = new RateLimitGuard(
    new Reflector(),
    store as unknown as RateLimitStore,
    config as unknown as AppConfigService,
  );
  const userGuard = new UserRateLimitGuard(
    new Reflector(),
    store as unknown as RateLimitStore,
    config as unknown as AppConfigService,
  );

  beforeEach(() => {
    store.consume.mockReset();
    store.consume.mockResolvedValue({ allowed: true });
  });

  it('cuenta por usuario y no por IP', async () => {
    const ctx = contextFor('1.1.1.1', ['reportUser'], { id: 'u1' });
    await ipGuard.canActivate(ctx);
    expect(store.consume).not.toHaveBeenCalled();
    await userGuard.canActivate(ctx);
    expect(store.consume).toHaveBeenCalledWith([
      { key: 'reportUser:user:u1', limit: 10, windowSec: 3600 },
    ]);
  });

  it('sin sesión no aplica (la ruta pública la cuida el límite por IP)', async () => {
    await userGuard.canActivate(contextFor('1.1.1.1', ['reportUser']));
    expect(store.consume).not.toHaveBeenCalled();
  });

  it('las políticas revisadas tienen su variable y su alcance', () => {
    expect(RATE_LIMIT_POLICIES.reportUser).toMatchObject({ per: 'user', windowSec: 3600 });
    expect(RATE_LIMIT_POLICIES.uploadUrlUser).toMatchObject({ per: 'user', windowSec: 3600 });
    expect(RATE_LIMIT_POLICIES.deviceUser).toMatchObject({ per: 'user', windowSec: 3600 });
    expect(RATE_LIMIT_POLICIES.otpRequestIp).not.toHaveProperty('per');
  });
});

describe('RedisThrottlerStorage', () => {
  it('traduce el resultado del store al formato de @nestjs/throttler', async () => {
    const store = {
      hitWithBlock: jest
        .fn()
        .mockResolvedValue({ totalHits: 4, ttlSec: 30, blocked: true, blockTtlSec: 60 }),
    };
    const storage = new RedisThrottlerStorage(store as unknown as RateLimitStore);
    await expect(storage.increment('abc', 60_000, 3, 0, 'global')).resolves.toEqual({
      totalHits: 4,
      timeToExpire: 30,
      isBlocked: true,
      timeToBlockExpire: 60,
    });
    // Sin blockDuration explícito se bloquea por el mismo ttl.
    expect(store.hitWithBlock).toHaveBeenCalledWith('throttler:global:abc', 60_000, 3, 60_000);
  });
});
