import request from 'supertest';
import type { OtpCodesDto } from '../src/admin-users/admin-otp-codes.controller';
import { uniqueIp, uniquePhone } from './utils/unique';
import {
  bearer,
  createTestApp,
  e164,
  login,
  loginAsAdmin,
  resetPhoneCooldowns,
  type TestApp,
} from './utils/test-app';

/** Códigos de ingreso en el panel mientras no hay SMS (ADR-0056). */
describe('Códigos OTP en el panel (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  const server = () => t.app.getHttpServer();
  const codes = async (token: string) =>
    (
      await request(server())
        .get('/admin/otp-codes')
        .set(...bearer(token))
        .expect(200)
    ).body as OtpCodesDto;

  it('muestra el código de un número nuevo y, tras ingresar, la cuenta y el uso', async () => {
    const admin = await loginAsAdmin(t);
    const phone = uniquePhone();
    await request(server())
      .post('/auth/otp/request')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone })
      .expect(202);

    const before = await codes(admin.accessToken);
    expect(before.enabled).toBe(true);
    const pending = before.items.find((i) => i.phone === e164(phone));
    expect(pending).toMatchObject({
      code: t.codes.get(e164(phone)),
      accountExists: false,
      usedAt: null,
      name: null,
    });
    expect(Date.parse(pending?.expiresAt ?? '') - Date.parse(pending?.sentAt ?? '')).toBe(300_000);

    // El mismo número ingresa (login pide otro código): se ve el nuevo, usado y con cuenta.
    await resetPhoneCooldowns(t);
    await login(t, phone);
    const after = (await codes(admin.accessToken)).items.filter((i) => i.phone === e164(phone));
    expect(after).toHaveLength(1);
    expect(after[0]).toMatchObject({
      code: t.codes.get(e164(phone)),
      accountExists: true,
      activeMode: 'employer',
    });
    expect(after[0]?.usedAt).not.toBeNull();
  });

  it('una sesión de la app no ve los códigos', async () => {
    const user = await login(t);
    await request(server())
      .get('/admin/otp-codes')
      .set(...bearer(user.accessToken))
      .expect(403);
  });
});
