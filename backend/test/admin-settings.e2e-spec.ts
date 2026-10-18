import request from 'supertest';
import { DebtCapService } from '../src/billing/debt-cap.service';
import type { SettingDto } from '../src/settings/dto/settings.dto';
import { AppSettingsService } from '../src/settings/app-settings.service';
import { expectAudited } from './utils/audit';
import { waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { createApprovedWorker, makeAvailable } from './utils/workers';
import {
  type AdminSession,
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueIp,
} from './utils/test-app';

/** Parámetros de negocio desde el panel (ADR-0043). */
describe('Parámetros en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    // Nada de esta suite queda para las demás.
    for (const key of ['OFFER_COUNTER_MAX_FACTOR', 'BILLING_DEBT_CAP_BS']) {
      await call('post', `/admin/settings/${key}/reset`, { reason: 'Fin de la prueba.' });
    }
    await t.close();
  });

  const call = (method: 'get' | 'put' | 'post', path: string, body?: object) =>
    request(t.app.getHttpServer())
      [method](path)
      .set(...bearer(admin.accessToken))
      .send(body);

  it('lista los parámetros con valor vigente, por defecto, rango y unidad', async () => {
    const list = (await call('get', '/admin/settings').expect(200)).body as SettingDto[];
    expect(list.find((s) => s.key === 'MATCHING_RINGS')).toMatchObject({
      group: 'matching',
      kind: 'rings',
      overridden: false,
    });
    expect(list.find((s) => s.key === 'BILLING_DEBT_CAP_BS')).toMatchObject({
      unit: 'Bs',
      defaultValue: '150.00',
      min: 0,
      max: 5000,
    });
  });

  it('fuera de rango o sin motivo: 400 y sin cambios; un parámetro que no existe: 404', async () => {
    const res = await call('put', '/admin/settings/MATCHING_RING_WAIT_MS', {
      value: '100',
      reason: 'Demasiado corto',
    }).expect(400);
    expect(res.body).toMatchObject({ code: 'SETTING_OUT_OF_RANGE' });
    await call('put', '/admin/settings/MATCHING_RING_WAIT_MS', { value: '45000' }).expect(400);
    await call('put', '/admin/settings/RATE_GLOBAL_IP_PER_MIN', {
      value: '1',
      reason: 'No es de negocio',
    }).expect(404);
    expect(
      (await t.prisma.appSetting.findMany({ where: { key: 'MATCHING_RING_WAIT_MS' } })).length,
    ).toBe(0);
  });

  it('un cambio válido se aplica de inmediato (contraoferta máxima), queda auditado y se puede revertir', async () => {
    const category = await createCategory(t); // máximo de referencia 300 Bs
    const worker = await createApprovedWorker(t, { categorySlugs: [category.slug] });
    await makeAvailable(t, worker, eastOf(CENTRO, 300));
    const employer = await login(t);
    const requestId = await publishRequest(t, employer.accessToken, { categoryId: category.id });
    await waitNotified(t, requestId, worker.id);
    const offer = (amountBs: string) =>
      request(t.app.getHttpServer())
        .post(`/requests/${requestId}/offers`)
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(worker.accessToken))
        .send({ type: 'counter', amountBs });

    const changed = (
      await call('put', '/admin/settings/OFFER_COUNTER_MAX_FACTOR', {
        value: '1',
        reason: 'Contraofertas fuera de lugar esta semana.',
      }).expect(200)
    ).body as SettingDto;
    expect(changed).toMatchObject({ value: '1', defaultValue: '3', overridden: true });
    expect(t.app.get(AppSettingsService).value('OFFER_COUNTER_MAX_FACTOR')).toBe(1);
    const tooHigh = await offer('400.00').expect(400);
    expect(tooHigh.body).toMatchObject({ code: 'OFFER_AMOUNT_TOO_HIGH' });
    const row = await expectAudited(t, {
      action: 'config.setting_set',
      targetType: 'app_setting',
      targetId: 'OFFER_COUNTER_MAX_FACTOR',
      adminId: admin.user.id,
    });
    expect(row).toMatchObject({ before: { value: 3 }, after: { value: 1 } });

    const reset = (
      await call('post', '/admin/settings/OFFER_COUNTER_MAX_FACTOR/reset', {
        reason: 'Volvemos a la propuesta.',
      }).expect(200)
    ).body as SettingDto;
    expect(reset).toMatchObject({ value: '3', overridden: false });
    await offer('400.00').expect(200);
    await expectAudited(t, {
      action: 'config.setting_reset',
      targetType: 'app_setting',
      targetId: 'OFFER_COUNTER_MAX_FACTOR',
      adminId: admin.user.id,
    });
  });

  it('el tope de deuda se guarda como monto con 2 decimales y lo usa billing', async () => {
    await call('put', '/admin/settings/BILLING_DEBT_CAP_BS', {
      value: '200.5',
      reason: 'Más margen en temporada alta.',
    }).expect(200);
    const list = (await call('get', '/admin/settings').expect(200)).body as SettingDto[];
    expect(list.find((s) => s.key === 'BILLING_DEBT_CAP_BS')?.value).toBe('200.50');
    expect(t.app.get(DebtCapService).cap.toFixed(2)).toBe('200.50');
  });
});
