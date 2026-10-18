import request from 'supertest';
import {
  bearer,
  e164,
  createTestApp,
  login,
  loginAsAdmin,
  resetPhoneCooldowns,
  type TestApp,
  uniqueIp,
} from './utils/test-app';
import { uniquePhone } from './utils/unique';

/** Piloto cerrado con lista de números e interés (e2e, ADR-0052). */
describe('Piloto cerrado (e2e)', () => {
  let t: TestApp;
  let admin: Awaited<ReturnType<typeof loginAsAdmin>>;
  let cityId: string;
  const http = () => request(t.app.getHttpServer());

  const setClosed = (enabled: boolean) =>
    http()
      .put('/admin/feature-flags/pilot.closed')
      .set(...bearer(admin.accessToken))
      .send({ enabled, cityId, reason: 'Prueba e2e del piloto' })
      .expect(200);
  const requestCode = (phone: string) =>
    http().post('/auth/otp/request').set('X-Forwarded-For', uniqueIp()).send({ phone });

  beforeAll(async () => {
    t = await createTestApp();
    admin = await loginAsAdmin(t);
    cityId = (await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } })).id;
  });

  afterAll(async () => {
    await setClosed(false);
    await t.close();
  });

  it('con el piloto abierto cualquiera ingresa', async () => {
    await setClosed(false);
    expect((await requestCode(uniquePhone())).status).toBe(202);
  });

  it('cerrado: un número fuera de la lista no recibe código ni cuenta', async () => {
    const existing = await login(t); // ya tenía cuenta antes de cerrar
    await setClosed(true);
    const outsider = uniquePhone();
    const res = await requestCode(outsider);
    expect(res.status).toBe(403);
    expect(res.body).toMatchObject({
      code: 'PILOT_NOT_ALLOWED',
      cityName: 'Santa Cruz de la Sierra',
    });
    expect(t.codes.get(e164(outsider))).toBeUndefined(); // no se envió SMS
    expect(await t.prisma.user.count({ where: { phone: e164(outsider) } })).toBe(0);

    // Las cuentas existentes siguen entrando.
    await resetPhoneCooldowns(t);
    expect((await requestCode(existing.user.phone)).status).toBe(202);
  });

  it('el admin agrega números (pegados) y esos sí ingresan; quitarlo vuelve a bloquear', async () => {
    await setClosed(true);
    const invited = uniquePhone();
    const added = await http()
      .post('/admin/pilot/allowlist')
      .set(...bearer(admin.accessToken))
      .send({
        phones: [invited, 'no-es-un-número', ''],
        note: 'Grupo 1',
        reason: 'Primer grupo del piloto',
      })
      .expect(200);
    expect(added.body).toMatchObject({ added: [e164(invited)], invalid: ['no-es-un-número'] });

    const session = await login(t, invited);
    expect(session.isNewUser).toBe(true);

    const overview = await http()
      .get('/admin/pilot')
      .set(...bearer(admin.accessToken))
      .expect(200);
    const body = overview.body as { closed: boolean; allowlist: { id: string; phone: string }[] };
    expect(body.closed).toBe(true);
    const row = body.allowlist.find((r) => r.phone === e164(invited));
    expect(row).toBeDefined();

    // Quitarlo de la lista no borra su cuenta (ya la creó) y queda auditado.
    await http()
      .delete(`/admin/pilot/allowlist/${row?.id ?? ''}`)
      .set(...bearer(admin.accessToken))
      .send({ reason: 'Pidió salir del piloto' })
      .expect(204);
    await resetPhoneCooldowns(t);
    expect((await requestCode(invited)).status).toBe(202);
    const audit = await t.prisma.adminAuditLog.findMany({
      where: {
        action: { in: ['pilot.allowlist_add', 'pilot.allowlist_remove'] },
        targetId: cityId,
      },
    });
    expect(audit.map((a) => a.action)).toEqual(
      expect.arrayContaining(['pilot.allowlist_add', 'pilot.allowlist_remove']),
    );
  });

  it('"Pronto en tu zona": el interés se guarda (uno por número) y se exporta', async () => {
    const phone = uniquePhone();
    const category = await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } });
    const send = (body: Record<string, unknown>) =>
      http()
        .post('/pilot/interest')
        .set('X-Forwarded-For', uniqueIp())
        .send({ phone, ...body });
    await send({ role: 'worker', categoryId: category.id, zone: 'Plan 3000' }).expect(204);
    await send({ role: 'ambos', zone: 'Villa 1ro de Mayo' }).expect(204);
    await send({ role: 'turista' }).expect(400);
    await http()
      .post('/pilot/interest')
      .set('X-Forwarded-For', uniqueIp())
      .send({ phone: '123', role: 'worker' })
      .expect(400);

    const rows = await t.prisma.pilotInterest.findMany({ where: { phone: e164(phone) } });
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({ role: 'ambos', zone: 'Villa 1ro de Mayo', categoryId: null });

    const list = await http()
      .get('/admin/pilot/interest')
      .set(...bearer(admin.accessToken))
      .expect(200);
    expect((list.body as { phone: string }[]).some((r) => r.phone === e164(phone))).toBe(true);
    const csv = await http()
      .get('/admin/pilot/interest.csv')
      .set(...bearer(admin.accessToken))
      .expect(200);
    expect(csv.headers['content-type']).toContain('text/csv');
    expect(csv.text).toContain('Villa 1ro de Mayo');
  });

  it('un usuario común no administra el piloto', async () => {
    await setClosed(false);
    const user = await login(t);
    await http()
      .get('/admin/pilot')
      .set(...bearer(user.accessToken))
      .expect(403);
  });
});
