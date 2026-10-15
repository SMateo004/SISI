import request from 'supertest';
import type { AdminCategoryDto, CategoryDto } from '../src/categories/dto/category.dto';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueSuffix,
} from './utils/test-app';

describe('Categorías por ciudad (e2e)', () => {
  let t: TestApp;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  it('GET /categories lista las 6 del seed en Santa Cruz con rango efectivo en Bs', async () => {
    const { accessToken } = await login(t);
    const res = await request(server())
      .get('/categories')
      .set(...bearer(accessToken))
      .expect(200);
    const categories = res.body as CategoryDto[];
    const slugs = categories.map((c) => c.slug);
    for (const slug of [
      'plomeria',
      'electricidad',
      'limpieza',
      'cuidado-hogar',
      'eventos',
      'mudanzas-carga',
    ]) {
      expect(slugs).toContain(slug);
    }
    const plomeria = categories.find((c) => c.slug === 'plomeria');
    expect(plomeria).toMatchObject({ name: 'Plomería', priceMinBs: '80.00', priceMaxBs: '300.00' });
    // Los montos viajan como texto con 2 decimales, nunca como float.
    expect(typeof plomeria?.priceMinBs).toBe('string');
  });

  it('no lista categorías inactivas ni las de otra ciudad', async () => {
    const otherCity = await t.prisma.city.create({
      data: {
        slug: `otra-${uniqueSuffix()}`,
        name: 'Otra ciudad',
        countryCode: 'BO',
        timezone: 'America/La_Paz',
      },
    });
    const elsewhere = await createCategory(t, { cityId: otherCity.id });
    const disabledHere = await createCategory(t, { activeInCity: false });
    const disabledGlobal = await createCategory(t, { active: false });

    const { accessToken } = await login(t);
    const slugs = (
      (
        await request(server())
          .get('/categories')
          .set(...bearer(accessToken))
      ).body as CategoryDto[]
    ).map((c) => c.slug);
    expect(slugs).not.toContain(elsewhere.slug);
    expect(slugs).not.toContain(disabledHere.slug);
    expect(slugs).not.toContain(disabledGlobal.slug);
  });

  describe('admin', () => {
    it('un usuario sin rol admin recibe 403', async () => {
      const { accessToken } = await login(t);
      const res = await request(server())
        .get('/admin/categories')
        .set(...bearer(accessToken))
        .expect(403);
      expect(res.body).toMatchObject({ code: 'FORBIDDEN' });
    });

    it('edita la base y el override por ciudad; GET /categories refleja el valor efectivo', async () => {
      const admin = await loginAsAdmin(t);
      const category = await createCategory(t);
      const city = await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } });

      const patched = (
        await request(server())
          .patch(`/admin/categories/${category.id}`)
          .set(...bearer(admin.accessToken))
          .send({ priceMinBs: '90', priceMaxBs: '310.5' })
          .expect(200)
      ).body as AdminCategoryDto;
      expect(patched).toMatchObject({ priceMinBs: '90.00', priceMaxBs: '310.50' });

      const overridden = (
        await request(server())
          .put(`/admin/categories/${category.id}/cities/${city.id}`)
          .set(...bearer(admin.accessToken))
          .send({ active: true, priceMinBs: '120.00', priceMaxBs: null, commissionPct: '10.00' })
          .expect(200)
      ).body as AdminCategoryDto;
      expect(overridden.cities[0]).toMatchObject({
        priceMinBs: '120.00',
        priceMaxBs: null,
        effectivePriceMinBs: '120.00',
        effectivePriceMaxBs: '310.50',
        effectiveCommissionPct: '10.00',
      });

      const listed = (
        (
          await request(server())
            .get('/categories')
            .set(...bearer(admin.accessToken))
        ).body as CategoryDto[]
      ).find((c) => c.id === category.id);
      expect(listed).toMatchObject({ priceMinBs: '120.00', priceMaxBs: '310.50' });
    });

    it('rechaza rangos incoherentes y montos con formato inválido', async () => {
      const admin = await loginAsAdmin(t);
      const category = await createCategory(t);
      const bad = await request(server())
        .patch(`/admin/categories/${category.id}`)
        .set(...bearer(admin.accessToken))
        .send({ priceMinBs: '500.00' })
        .expect(400);
      expect(bad.body).toMatchObject({ code: 'PRICE_RANGE_INVALID' });
      const float = await request(server())
        .patch(`/admin/categories/${category.id}`)
        .set(...bearer(admin.accessToken))
        .send({ priceMinBs: '80.555' })
        .expect(400);
      expect(float.body).toMatchObject({ code: 'VALIDATION_ERROR' });
    });
  });
});
