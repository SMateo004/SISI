import request from 'supertest';
import { AppSettingsService } from '../src/settings/app-settings.service';
import { bearer, createTestApp, login, loginAsAdmin, type TestApp } from './utils/test-app';

/** Configuración de la app, soporte y versión mínima (e2e, ADR-0052 y ADR-0054). */
describe('Configuración de la app y versión mínima (e2e)', () => {
  let t: TestApp;
  let admin: Awaited<ReturnType<typeof loginAsAdmin>>;
  const http = () => request(t.app.getHttpServer());
  const setSetting = async (key: string, value: string) => {
    await http()
      .put(`/admin/settings/${key}`)
      .set(...bearer(admin.accessToken))
      .send({ value, reason: 'Prueba e2e de la Fase 7' })
      .expect(200);
  };
  const resetSetting = async (key: string) => {
    await http()
      .post(`/admin/settings/${key}/reset`)
      .set(...bearer(admin.accessToken))
      .send({ reason: 'Fin de la prueba e2e' });
  };

  beforeAll(async () => {
    t = await createTestApp();
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    for (const key of ['APP_MIN_VERSION_ANDROID', 'SUPPORT_WHATSAPP']) await resetSetting(key);
    await t.close();
  });

  it('/app/config es público: versión mínima, soporte y versiones legales', async () => {
    const res = await http().get('/app/config').query({ platform: 'android', version: '0.9.0' });
    expect(res.status).toBe(200);
    expect(res.body).toMatchObject({
      platform: 'android',
      minVersion: '0.0.0',
      upgradeRequired: false,
      support: null,
    });
    expect((res.body as { legal: { type: string }[] }).legal.map((l) => l.type).sort()).toEqual([
      'privacy',
      'terms',
    ]);
    await http().get('/app/config').query({ platform: 'symbian' }).expect(400);
  });

  it('el WhatsApp de soporte se configura desde el panel', async () => {
    await http()
      .put('/admin/settings/SUPPORT_WHATSAPP')
      .set(...bearer(admin.accessToken))
      .send({ value: '12345', reason: 'Prueba e2e de la Fase 7' })
      .expect(400);
    await setSetting('SUPPORT_WHATSAPP', '+59170000001');
    const res = await http().get('/app/config').query({ platform: 'android' }).expect(200);
    expect((res.body as { support: unknown }).support).toEqual({
      whatsapp: '+59170000001',
      url: expect.stringMatching(/^https:\/\/wa\.me\/59170000001\?text=/) as string,
    });
  });

  it('una versión menor que la mínima recibe 426 salvo en las rutas exentas', async () => {
    const user = await login(t);
    await setSetting('APP_MIN_VERSION_ANDROID', '0.9.1');
    expect(t.app.get(AppSettingsService).value('APP_MIN_VERSION_ANDROID')).toBe('0.9.1');

    const old = (path: string) =>
      http()
        .get(path)
        .set(...bearer(user.accessToken))
        .set('X-App-Platform', 'android')
        .set('X-App-Version', '0.9.0+4');
    const blocked = await old('/requests/mine');
    expect(blocked.status).toBe(426);
    expect(blocked.body).toMatchObject({ code: 'APP_UPGRADE_REQUIRED', minVersion: '0.9.1' });

    // Exentas: configuración, salud y textos legales.
    expect((await old('/app/config?platform=android&version=0.9.0')).status).toBe(200);
    expect((await old('/health')).status).toBe(200);
    expect((await old('/legal/current')).status).toBe(200);
    const config = await http().get('/app/config').query({ platform: 'android', version: '0.9.0' });
    expect((config.body as { upgradeRequired: boolean }).upgradeRequired).toBe(true);

    // La versión mínima o una mayor pasa; otra plataforma o sin headers, también.
    const current = await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken))
      .set('X-App-Platform', 'android')
      .set('X-App-Version', '0.9.1+5');
    expect(current.status).toBe(200);
    const ios = await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken))
      .set('X-App-Platform', 'ios')
      .set('X-App-Version', '0.9.0');
    expect(ios.status).toBe(200);
    await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken))
      .expect(200);
  });
});
