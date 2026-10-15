import { renderNotification } from './notification-texts';
import { FakePushProvider } from './push/fake-push.provider';
import { createPushProvider, parseServiceAccount } from './push/push-provider.factory';

const account = {
  project_id: 'sisi-test',
  client_email: 'push@sisi-test.iam.gserviceaccount.com',
  private_key: '-----BEGIN PRIVATE KEY-----\nabc\n-----END PRIVATE KEY-----\n',
};

describe('Push (ADR-0027)', () => {
  it('production no acepta el push falso', () => {
    expect(() =>
      createPushProvider({
        APP_ENV: 'production',
        PUSH_PROVIDER: 'fake',
        FIREBASE_SERVICE_ACCOUNT: undefined,
      }),
    ).toThrow(/PUSH_PROVIDER=fake no está permitido/);
  });

  it('fcm exige la cuenta de servicio', () => {
    expect(() =>
      createPushProvider({
        APP_ENV: 'staging',
        PUSH_PROVIDER: 'fcm',
        FIREBASE_SERVICE_ACCOUNT: undefined,
      }),
    ).toThrow(/requiere FIREBASE_SERVICE_ACCOUNT/);
  });

  it('local y test usan el falso', () => {
    const provider = createPushProvider({
      APP_ENV: 'local',
      PUSH_PROVIDER: 'fake',
      FIREBASE_SERVICE_ACCOUNT: undefined,
    });
    expect(provider).toBeInstanceOf(FakePushProvider);
  });

  it('lee la cuenta de servicio en JSON o en base64', () => {
    const json = JSON.stringify(account);
    const expected = {
      projectId: 'sisi-test',
      clientEmail: account.client_email,
      privateKey: account.private_key,
    };
    expect(parseServiceAccount(json)).toEqual(expected);
    expect(parseServiceAccount(Buffer.from(json).toString('base64'))).toEqual(expected);
    expect(() => parseServiceAccount('{"project_id":"x"}')).toThrow(/client_email/);
    expect(() => parseServiceAccount('no-es-json')).toThrow(/JSON válido/);
  });

  it('el falso marca como inválidos los tokens "invalid…"', async () => {
    const fake = new FakePushProvider();
    const res = await fake.send(['tok-ok', 'invalid-1'], { title: 't', body: 'b', data: {} });
    expect(res).toEqual([
      { token: 'tok-ok', ok: true, invalidToken: false },
      { token: 'invalid-1', ok: false, invalidToken: true },
    ]);
  });
});

describe('Textos de los avisos', () => {
  it('solicitud nueva: categoría, distancia y precio en Bs', () => {
    expect(
      renderNotification('request_new', {
        requestId: 'r1',
        category: 'Plomería',
        distanceM: 850,
        proposedPriceBs: '150.00',
      }),
    ).toEqual({
      title: 'Nueva solicitud cerca',
      body: 'Plomería a 850 m · Bs 150,00',
      route: '/trabajo/solicitudes/r1',
    });
    expect(
      renderNotification('request_new', {
        requestId: 'r1',
        category: 'Plomería',
        distanceM: 2345,
        proposedPriceBs: '80.5',
      }).body,
    ).toBe('Plomería a 2,3 km · Bs 80,50');
  });

  it('liberada y rechazada por moderación llevan al detalle de la solicitud', () => {
    expect(
      renderNotification('request_released', { requestId: 'r1', category: 'Limpieza' }),
    ).toEqual({
      title: 'Tu solicitud fue publicada',
      body: 'Ya estamos buscando trabajadores de Limpieza cerca de ti.',
      route: '/solicitudes/r1',
    });
    expect(
      renderNotification('request_rejected', { requestId: 'r1', category: 'Limpieza' }).title,
    ).toBe('Tu solicitud no fue publicada');
  });
});
