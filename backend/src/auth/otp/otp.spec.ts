import type { RateLimitStore } from '../../common/rate-limit/rate-limit.store';
import type { AppConfigService } from '../../config/app-config';
import { BirdOtpProvider } from './bird-otp.provider';
import { ConsoleOtpProvider } from './console-otp.provider';
import { OtpHasher } from './otp-hasher';
import { createOtpProvider } from './otp-provider.factory';
import type { OtpProvider } from './otp-provider';
import { OtpService } from './otp.service';
import type { OtpCheck, OtpStore } from './otp.store';

/** Misma semántica que el Lua de RedisOtpStore, con reloj controlable. */
class MemoryOtpStore implements OtpStore {
  now = 0;
  readonly entries = new Map<string, { hash: string; attempts: number; expiresAt: number }>();

  save(phoneKey: string, codeHash: string, ttlSec: number): Promise<void> {
    this.entries.set(phoneKey, {
      hash: codeHash,
      attempts: 0,
      expiresAt: this.now + ttlSec * 1000,
    });
    return Promise.resolve();
  }

  check(phoneKey: string, codeHash: string, maxAttempts: number): Promise<OtpCheck> {
    const entry = this.entries.get(phoneKey);
    if (!entry || entry.expiresAt <= this.now) return Promise.resolve('expired');
    if (entry.hash === codeHash) {
      this.entries.delete(phoneKey);
      return Promise.resolve('ok');
    }
    entry.attempts += 1;
    if (entry.attempts >= maxAttempts) {
      this.entries.delete(phoneKey);
      return Promise.resolve('exhausted');
    }
    return Promise.resolve('invalid');
  }

  delete(phoneKey: string): Promise<void> {
    this.entries.delete(phoneKey);
    return Promise.resolve();
  }
}

const SECRET = 'secreto-de-pruebas-de-32-caracteres!!';
const ENV: Record<string, unknown> = {
  JWT_SECRET: SECRET,
  PHONE_ALLOWED_COUNTRY_CODES: ['591'],
  OTP_TTL_SEC: 300,
  OTP_MAX_ATTEMPTS: 5,
  RATE_OTP_PHONE_COOLDOWN_SEC: 60,
  RATE_OTP_PHONE_PER_HOUR: 5,
  RATE_OTP_PHONE_PER_DAY: 10,
};

function setup(code = '123456') {
  const store = new MemoryOtpStore();
  const sent: { phone: string; code: string }[] = [];
  const provider: OtpProvider = {
    name: 'console',
    send: (phone, c) => {
      sent.push({ phone, code: c });
      return Promise.resolve();
    },
  };
  const rateLimits = { consume: jest.fn().mockResolvedValue({ allowed: true }) };
  const config = { get: (key: string) => ENV[key] } as unknown as AppConfigService;
  const service = new OtpService(
    config,
    store,
    provider,
    () => code,
    rateLimits as unknown as RateLimitStore,
  );
  return { service, store, sent, rateLimits };
}

describe('OtpService', () => {
  it('envía el código y guarda solo su hash', async () => {
    const { service, store, sent } = setup('482913');
    await expect(service.request('70012345')).resolves.toEqual({
      expiresInSec: 300,
      resendInSec: 60,
    });
    expect(sent).toEqual([{ phone: '+59170012345', code: '482913' }]);
    const [stored] = [...store.entries.values()];
    expect(stored?.hash).toMatch(/^[0-9a-f]{64}$/);
    expect(stored?.hash).not.toContain('482913');
    expect([...store.entries.keys()][0]).not.toContain('70012345');
  });

  it('aplica los límites por teléfono antes de enviar', async () => {
    const { service, sent, rateLimits } = setup();
    rateLimits.consume.mockResolvedValueOnce({ allowed: false, retryAfterSec: 42 });
    await expect(service.request('70012345')).rejects.toMatchObject({ retryAfterSec: 42 });
    expect(sent).toHaveLength(0);
    const calls = rateLimits.consume.mock.calls as [{ limit: number; windowSec: number }[]][];
    const rules = calls[0]?.[0] ?? [];
    expect(rules.map((r) => [r.limit, r.windowSec])).toEqual([
      [1, 60],
      [5, 3600],
      [10, 86_400],
    ]);
  });

  it('acepta el código correcto una sola vez (formato libre del teléfono)', async () => {
    const { service } = setup('111222');
    await service.request('+591 700 12345');
    await expect(service.verify('70012345', '111222')).resolves.toBe('+59170012345');
    await expect(service.verify('70012345', '111222')).rejects.toMatchObject({
      code: 'OTP_INVALID',
    });
  });

  it('rechaza el código vencido después de 5 minutos', async () => {
    const { service, store } = setup('111222');
    await service.request('70012345');
    store.now += 300_000;
    await expect(service.verify('70012345', '111222')).rejects.toMatchObject({
      code: 'OTP_INVALID',
      message: 'Código incorrecto o vencido.',
    });
  });

  it('invalida el código al 5.º intento fallido, aunque después llegue el correcto', async () => {
    const { service } = setup('111222');
    await service.request('70012345');
    for (let i = 0; i < 4; i++) {
      await expect(service.verify('70012345', '000000')).rejects.toMatchObject({
        code: 'OTP_INVALID',
      });
    }
    await expect(service.verify('70012345', '000000')).rejects.toMatchObject({
      code: 'OTP_TOO_MANY_ATTEMPTS',
    });
    await expect(service.verify('70012345', '111222')).rejects.toMatchObject({
      code: 'OTP_INVALID',
    });
  });

  it('no deja un código usable si el envío falla', async () => {
    const { service, store } = setup();
    const failing = new OtpService(
      { get: (key: string) => ENV[key] } as unknown as AppConfigService,
      store,
      { name: 'bird', send: () => Promise.reject(new Error('caído')) },
      () => '123456',
      { consume: () => Promise.resolve({ allowed: true }) } as unknown as RateLimitStore,
    );
    await expect(failing.request('70012345')).rejects.toThrow('caído');
    expect(store.entries.size).toBe(0);
    await expect(service.verify('70012345', '123456')).rejects.toMatchObject({
      code: 'OTP_INVALID',
    });
  });

  it('responde 400 en español si el número no es de Bolivia', async () => {
    const { service } = setup();
    await expect(service.request('+5491123456789')).rejects.toMatchObject({
      code: 'PHONE_COUNTRY_NOT_ALLOWED',
    });
  });
});

describe('OtpHasher', () => {
  it('es determinista, depende del teléfono y del secreto', () => {
    const a = new OtpHasher(SECRET);
    const b = new OtpHasher(`${SECRET}-otro`);
    expect(a.hash('+59170012345', '123456')).toBe(a.hash('+59170012345', '123456'));
    expect(a.hash('+59170012345', '123456')).not.toBe(a.hash('+59170012346', '123456'));
    expect(a.hash('+59170012345', '123456')).not.toBe(b.hash('+59170012345', '123456'));
  });

  it('genera códigos de 6 dígitos', () => {
    for (let i = 0; i < 200; i++) expect(OtpHasher.generateCode()).toMatch(/^\d{6}$/);
  });
});

describe('createOtpProvider', () => {
  const base = { OTP_TTL_SEC: 300, OTP_PROVIDER_KEY: undefined, OTP_SENDER: undefined };

  it('usa la consola en local, test y staging', () => {
    for (const APP_ENV of ['local', 'test', 'staging'] as const) {
      expect(createOtpProvider({ ...base, APP_ENV, OTP_PROVIDER: 'console' })).toBeInstanceOf(
        ConsoleOtpProvider,
      );
    }
  });

  it('nunca activa la consola en producción', () => {
    expect(() =>
      createOtpProvider({ ...base, APP_ENV: 'production', OTP_PROVIDER: 'console' }),
    ).toThrow(/no está permitido/);
  });

  it('exige clave y remitente para Bird', () => {
    expect(() =>
      createOtpProvider({ ...base, APP_ENV: 'production', OTP_PROVIDER: 'bird' }),
    ).toThrow(/OTP_PROVIDER_KEY/);
    expect(
      createOtpProvider({
        ...base,
        APP_ENV: 'production',
        OTP_PROVIDER: 'bird',
        OTP_PROVIDER_KEY: 'bk_us1_Ab3xKq9mP2wR5tY8uI1oL4n3A3aww',
        OTP_SENDER: 'SISI',
      }),
    ).toBeInstanceOf(BirdOtpProvider);
  });
});

describe('BirdOtpProvider', () => {
  it('llama al host de la región con el SMS de autenticación', async () => {
    const fetchFn = jest.fn().mockResolvedValue(new Response('{}', { status: 202 }));
    const bird = new BirdOtpProvider({
      apiKey: 'bk_eu1_Ab3xKq9mP2wR5tY8uI1oL4n3A3aww',
      sender: 'SISI',
      ttlMinutes: 5,
      fetchFn: fetchFn,
    });
    await bird.send('+59170012345', '123456');
    const [url, init] = fetchFn.mock.calls[0] as [string, RequestInit];
    expect(url).toBe('https://eu1.platform.bird.com/v1/sms/messages');
    expect((init.headers as Record<string, string>).Authorization).toBe(
      'Bearer bk_eu1_Ab3xKq9mP2wR5tY8uI1oL4n3A3aww',
    );
    expect(JSON.parse(init.body as string)).toEqual({
      to: '+59170012345',
      from: 'SISI',
      text: 'Tu código de SISI es 123456. Vence en 5 minutos. No lo compartas con nadie.',
      category: 'authentication',
    });
  });

  it('traduce un rechazo de Bird a 503 sin detalles internos', async () => {
    const bird = new BirdOtpProvider({
      apiKey: 'bk_us1_Ab3xKq9mP2wR5tY8uI1oL4n3A3aww',
      sender: 'SISI',
      ttlMinutes: 5,
      fetchFn: () => Promise.resolve(new Response('SMSDestinationNotEnabled', { status: 422 })),
    });
    await expect(bird.send('+59170012345', '123456')).rejects.toMatchObject({
      code: 'OTP_SEND_FAILED',
    });
  });

  it('rechaza claves con formato inválido', () => {
    expect(() => new BirdOtpProvider({ apiKey: 'xyz', sender: 'SISI', ttlMinutes: 5 })).toThrow(
      /formato/,
    );
  });
});
