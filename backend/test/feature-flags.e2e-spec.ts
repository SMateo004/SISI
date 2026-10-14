import request from 'supertest';
import type { FeatureFlagDto } from '../src/feature-flags/feature-flags.controller';
import { FeatureFlagsService } from '../src/feature-flags/feature-flags.service';
import { bearer, createTestApp, login, loginAsAdmin, type TestApp } from './utils/test-app';

describe('Feature flags (e2e)', () => {
  let t: TestApp;
  let flags: FeatureFlagsService;
  let santaCruzId: string;
  const server = () => t.app.getHttpServer();
  const key = () => `e2e.flag-${Date.now().toString(36)}${Math.random().toString(36).slice(2, 6)}`;

  beforeAll(async () => {
    t = await createTestApp();
    flags = t.app.get(FeatureFlagsService);
    santaCruzId = (await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } })).id;
  });

  afterAll(async () => {
    await t.close();
  });

  it('global, override por ciudad e invalidación de caché al cambiar', async () => {
    const admin = await loginAsAdmin(t);
    const k = key();
    expect(await flags.isEnabled(k, santaCruzId)).toBe(false);

    await request(server())
      .put(`/admin/feature-flags/${k}`)
      .set(...bearer(admin.accessToken))
      .send({ enabled: true })
      .expect(200);
    // Se lee (y se cachea) el valor nuevo.
    expect(await flags.isEnabled(k, santaCruzId)).toBe(true);

    const res = await request(server())
      .put(`/admin/feature-flags/${k}`)
      .set(...bearer(admin.accessToken))
      .send({ enabled: false, cityId: santaCruzId })
      .expect(200);
    expect(res.body as FeatureFlagDto).toMatchObject({
      key: k,
      cityId: santaCruzId,
      enabled: false,
    });
    // La caché se invalidó: la ciudad ya ve su override sin esperar el TTL.
    expect(await flags.isEnabled(k, santaCruzId)).toBe(false);
    expect(await flags.isEnabled(k)).toBe(true);

    // Un segundo PUT global actualiza la misma fila (no duplica).
    await request(server())
      .put(`/admin/feature-flags/${k}`)
      .set(...bearer(admin.accessToken))
      .send({ enabled: false })
      .expect(200);
    const rows = await t.prisma.featureFlag.findMany({ where: { key: k } });
    expect(rows).toHaveLength(2);
    expect(await flags.isEnabled(k)).toBe(false);
  });

  it('rechaza keys inválidas y a usuarios sin rol admin', async () => {
    const admin = await loginAsAdmin(t);
    const bad = await request(server())
      .put('/admin/feature-flags/Con%20Espacio')
      .set(...bearer(admin.accessToken))
      .send({ enabled: true })
      .expect(400);
    expect(bad.body).toMatchObject({ code: 'FLAG_KEY_INVALID' });

    const user = await login(t);
    await request(server())
      .get('/admin/feature-flags')
      .set(...bearer(user.accessToken))
      .expect(403);
  });
});
