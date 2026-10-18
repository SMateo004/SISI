import type { ErrorEvent } from '@sentry/node';
import { JsonLogger } from './json-logger';
import { createLogger } from './logger.factory';
import { currentRequestId, runWithRequestId, setContextUser } from './request-context';
import { initSentry, scrub } from './sentry';

describe('JsonLogger (ADR-0048)', () => {
  const lines: string[] = [];
  const logger = new JsonLogger({ service: 'api', env: 'production', release: 'r' }, (l) => {
    lines.push(l);
  });
  const last = () => JSON.parse(lines.at(-1) ?? '{}') as Record<string, unknown>;

  beforeEach(() => {
    lines.length = 0;
  });

  it('una línea JSON con nivel, contexto, requestId y usuario', () => {
    runWithRequestId('req-12345678', () => {
      setContextUser('user-1');
      logger.log('Publicada', 'RequestsService');
    });
    expect(last()).toMatchObject({
      level: 'log',
      service: 'api',
      env: 'production',
      context: 'RequestsService',
      msg: 'Publicada',
      requestId: 'req-12345678',
      userId: 'user-1',
    });
  });

  it('nunca escribe un teléfono completo ni un token', () => {
    logger.warn('Login de +59170012345 con Bearer abc.def', 'Auth');
    const out = lines.join('\n');
    expect(out).not.toContain('70012345');
    expect(out).not.toContain('abc.def');
    logger.log({ phone: '+59170012345', code: '123456' }, 'Auth');
    expect(lines.at(-1)).not.toContain('123456');
  });

  it('separa el stack de un error', () => {
    logger.error('Falló', 'Error: x\n    at y', 'Worker');
    expect(last()).toMatchObject({
      level: 'error',
      context: 'Worker',
      stack: 'Error: x\n    at y',
    });
  });

  it('JSON solo en staging y producción', () => {
    expect(createLogger('api', { APP_ENV: 'production' })).toBeInstanceOf(JsonLogger);
    expect(createLogger('api', { APP_ENV: 'staging' })).toBeInstanceOf(JsonLogger);
    expect(createLogger('api', { APP_ENV: 'local' })).not.toBeInstanceOf(JsonLogger);
  });
});

describe('request-context', () => {
  it('el id solo existe dentro de su ejecución', () => {
    expect(currentRequestId()).toBeUndefined();
    runWithRequestId('abc-12345678', () => {
      expect(currentRequestId()).toBe('abc-12345678');
    });
  });
});

describe('Sentry (ADR-0048)', () => {
  it('sin SENTRY_DSN no se activa', () => {
    expect(initSentry('api', {})).toBe(false);
  });

  it('scrub quita cookies, cuerpo, query, datos del usuario y PII del mensaje', () => {
    const event = scrub({
      type: undefined,
      message: 'Falló para +59170012345',
      request: {
        cookies: { sisi_admin_rt: 'x' },
        data: { code: '123456' },
        query_string: 'phone=70012345',
        headers: { authorization: 'Bearer y', 'user-agent': 'ok' },
      },
      user: { id: 'u1', ip_address: '1.2.3.4', email: 'a@b.c' },
      exception: { values: [{ type: 'Error', value: 'token eyJhbGciOi.eyJzdWIiOi.c2lnbmF0dXJl' }] },
    } as ErrorEvent);
    expect(event.request?.cookies).toBeUndefined();
    expect(event.request?.data).toBeUndefined();
    expect(event.request?.query_string).toBeUndefined();
    expect(event.request?.headers?.authorization).toBe('[redactado]');
    expect(event.user).toEqual({ id: 'u1' });
    expect(event.message).not.toContain('70012345');
    expect(event.exception?.values?.[0]?.value).toContain('[jwt]');
  });
});
