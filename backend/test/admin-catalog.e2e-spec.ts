import request from 'supertest';
import { COMMISSION_NOTICE } from '../src/categories/admin-categories.service';
import type { AdminCategoryDto, AdminCityDto } from '../src/categories/dto/category.dto';
import { FeatureFlagsService } from '../src/feature-flags/feature-flags.service';
import { expectAudited } from './utils/audit';
import { assignJob } from './utils/jobs';
import {
  type AdminSession,
  bearer,
  createTestApp,
  loginAsAdmin,
  type TestApp,
  uniqueSuffix,
} from './utils/test-app';

/** Catálogo y configuración en el panel (R2.2, R10.1, R10.2). */
describe('Catálogo y flags en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;
  let santaCruz: AdminCityDto;

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    admin = await loginAsAdmin(t);
    const cities = (
      await request(t.app.getHttpServer())
        .get('/admin/cities')
        .set(...bearer(admin.accessToken))
        .expect(200)
    ).body as AdminCityDto[];
    const found = cities.find((c) => c.slug === 'santa-cruz');
    if (!found) throw new Error('Sin Santa Cruz');
    santaCruz = found;
  });

  afterAll(async () => {
    await t.close();
  });

  const call = (method: 'post' | 'patch' | 'put', path: string, body: object) =>
    request(t.app.getHttpServer())
      [method](path)
      .set(...bearer(admin.accessToken))
      .send(body);

  it('crear una categoría con requisitos extra y ciudad; queda auditada y aparece en la app', async () => {
    const slug = `jardin-${uniqueSuffix()}`;
    const created = (
      await call('post', '/admin/categories', {
        slug,
        name: 'Jardinería',
        description: 'Poda y césped',
        priceMinBs: '60.00',
        priceMaxBs: '250.00',
        extraRequirements: ['herramientas_propias'],
        cityIds: [santaCruz.id],
      }).expect(201)
    ).body as AdminCategoryDto;
    expect(created).toMatchObject({
      slug,
      commissionPct: '13.00',
      extraRequirements: ['herramientas_propias'],
      cities: [expect.objectContaining({ cityId: santaCruz.id, active: true })],
      notice: null,
    });
    await expectAudited(t, {
      action: 'catalog.category_create',
      targetType: 'category',
      targetId: created.id,
      adminId: admin.user.id,
    });
    const app = (
      await request(t.app.getHttpServer())
        .get('/categories')
        .set(...bearer(admin.appAccessToken))
        .expect(200)
    ).body as { slug: string }[];
    expect(app.map((c) => c.slug)).toContain(slug);

    // Slug repetido, rango invertido o requisito mal escrito: no se crea.
    await call('post', '/admin/categories', {
      slug,
      name: 'Otra',
      priceMinBs: '1.00',
      priceMaxBs: '2.00',
    }).expect(409);
    await call('post', '/admin/categories', {
      slug: `x-${uniqueSuffix()}`,
      name: 'Otra',
      priceMinBs: '300.00',
      priceMaxBs: '2.00',
    }).expect(400);
    await call('post', '/admin/categories', {
      slug: `y-${uniqueSuffix()}`,
      name: 'Otra',
      priceMinBs: '1.00',
      priceMaxBs: '2.00',
      extraRequirements: ['Con Espacios'],
    }).expect(400);
  });

  it('cambiar la comisión avisa que solo afecta a lo que se asigne desde ahora (y es así)', async () => {
    const before = await assignJob(t);
    const patched = (
      await call('patch', `/admin/categories/${before.categoryId}`, {
        commissionPct: '10.00',
      }).expect(200)
    ).body as AdminCategoryDto;
    expect(patched.notice).toBe(COMMISSION_NOTICE);
    const row = await expectAudited(t, {
      action: 'catalog.category_update',
      targetType: 'category',
      targetId: before.categoryId,
      adminId: admin.user.id,
    });
    expect(row).toMatchObject({
      before: expect.objectContaining({ commissionPct: '13.00' }) as unknown,
      after: expect.objectContaining({ commissionPct: '10.00' }) as unknown,
    });
    // El trabajo ya asignado conserva 13 %; uno nuevo toma 10 %.
    const old = await t.prisma.job.findUniqueOrThrow({ where: { id: before.jobId } });
    expect(old.commissionPct.toFixed(2)).toBe('13.00');
    await request(t.app.getHttpServer())
      .post(`/jobs/${before.jobId}/cancel`)
      .set(...bearer(before.employer.accessToken))
      .send({ reason: 'otro' })
      .expect(200);
    const after = await assignJob(t, { worker: before.worker, categoryId: before.categoryId });
    const fresh = await t.prisma.job.findUniqueOrThrow({ where: { id: after.jobId } });
    expect(fresh.commissionPct.toFixed(2)).toBe('10.00');

    // Sin cambio de comisión, sin aviso.
    const renamed = (
      await call('patch', `/admin/categories/${before.categoryId}`, { name: 'Otro nombre' }).expect(
        200,
      )
    ).body as AdminCategoryDto;
    expect(renamed.notice).toBeNull();
  });

  it('override por ciudad auditado, con aviso si cambia la comisión efectiva', async () => {
    const job = await assignJob(t);
    const res = (
      await call('put', `/admin/categories/${job.categoryId}/cities/${santaCruz.id}`, {
        active: true,
        commissionPct: '11.50',
      }).expect(200)
    ).body as AdminCategoryDto;
    expect(res.notice).toBe(COMMISSION_NOTICE);
    expect(res.cities[0]).toMatchObject({ effectiveCommissionPct: '11.50' });
    await expectAudited(t, {
      action: 'catalog.category_city',
      targetType: 'category',
      targetId: job.categoryId,
      adminId: admin.user.id,
    });
  });

  it('un flag por ciudad queda auditado y se aplica', async () => {
    const key = `prueba.panel_${uniqueSuffix()}`;
    await call('put', `/admin/feature-flags/${key}`, {
      enabled: true,
      cityId: santaCruz.id,
      reason: 'Piloto en Santa Cruz',
    }).expect(200);
    expect(await t.app.get(FeatureFlagsService).isEnabled(key, santaCruz.id)).toBe(true);
    const row = await expectAudited(t, {
      action: 'config.flag_set',
      targetType: 'feature_flag',
      targetId: `${key}@${santaCruz.id}`,
      adminId: admin.user.id,
    });
    expect(row).toMatchObject({
      before: null,
      after: { enabled: true },
      cityId: santaCruz.id,
      reason: 'Piloto en Santa Cruz',
    });
  });
});
