import request from 'supertest';
import { CENTRO, eastOf } from './utils/requests';
import {
  bearer,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueIp,
} from './utils/test-app';

/** Zona del piloto editable desde el panel (e2e, ADR-0052). */
describe('Zona de servicio por GeoJSON (e2e)', () => {
  let t: TestApp;
  let admin: Awaited<ReturnType<typeof loginAsAdmin>>;
  let cityId: string;
  let radiusBefore: number;
  const http = () => request(t.app.getHttpServer());
  const area = () => `/admin/cities/${cityId}/service-area`;
  const put = (body: Record<string, unknown>) =>
    http()
      .put(area())
      .set(...bearer(admin.accessToken))
      .send({ reason: 'Zona del piloto (prueba e2e)', ...body });
  const ring = (points: [number, number][]) =>
    JSON.stringify({ type: 'Polygon', coordinates: [[...points, points[0]]] });

  // Un cuadrado de ~2 km alrededor de la Plaza 24 de Septiembre ([lng, lat]).
  const SMALL: [number, number][] = [
    [-63.192, -17.774],
    [-63.172, -17.774],
    [-63.172, -17.793],
    [-63.192, -17.793],
  ];

  beforeAll(async () => {
    t = await createTestApp();
    admin = await loginAsAdmin(t);
    cityId = (await t.prisma.city.findUniqueOrThrow({ where: { slug: 'santa-cruz' } })).id;
    radiusBefore = (
      (
        await http()
          .get(area())
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as {
        radiusKm: number;
      }
    ).radiusKm;
  });

  afterAll(async () => {
    // Las demás suites usan el radio provisional: se deja como estaba.
    await put({ geojson: null, radiusKm: radiusBefore });
    await t.close();
  });

  it('hoy: centro en la plaza y radio, sin polígono', async () => {
    const res = await http()
      .get(area())
      .set(...bearer(admin.accessToken))
      .expect(200);
    expect(res.body).toMatchObject({ geojson: null, centerLat: CENTRO.latitude });
  });

  it('rechaza JSON inválido, coordenadas invertidas, autointersecciones y una zona sin el centro', async () => {
    const code = async (body: Record<string, unknown>) => {
      const res = await put(body);
      return [res.status, (res.body as { code?: string; message?: string }).code];
    };
    expect(await code({ geojson: '{no es json' })).toEqual([400, 'SERVICE_AREA_INVALID']);
    // [lat, lng] en vez de [lng, lat]: cae fuera de Bolivia.
    expect(await code({ geojson: ring(SMALL.map(([lng, lat]) => [lat, lng])) })).toEqual([
      400,
      'SERVICE_AREA_INVALID',
    ]);
    // Moño (se cruza a sí mismo).
    expect(
      await code({
        geojson: ring([
          [-63.192, -17.774],
          [-63.172, -17.793],
          [-63.172, -17.774],
          [-63.192, -17.793],
        ]),
      }),
    ).toEqual([400, 'SERVICE_AREA_INVALID']);
    // Una zona lejos del centro.
    expect(
      await code({
        geojson: ring([
          [-63.1, -17.7],
          [-63.09, -17.7],
          [-63.09, -17.71],
          [-63.1, -17.71],
        ]),
      }),
    ).toEqual([400, 'SERVICE_AREA_INVALID']);
  });

  it('con un polígono: el punto de prueba y las solicitudes nuevas usan esa zona; queda auditado', async () => {
    const saved = await put({ geojson: ring(SMALL) }).expect(200);
    expect((saved.body as { geojson: string }).geojson).toContain('Polygon');

    const test = async (lat: number, lng: number) =>
      (
        await http()
          .post(`${area()}/test`)
          .set(...bearer(admin.accessToken))
          .send({ lat, lng })
          .expect(200)
      ).body as { inside: boolean; by: string };
    expect(await test(CENTRO.latitude, CENTRO.longitude)).toEqual({ inside: true, by: 'polygon' });
    const far = eastOf(CENTRO, 5000); // dentro del radio de 15 km, fuera del cuadrado
    expect(await test(far.latitude, far.longitude)).toEqual({ inside: false, by: 'polygon' });

    const employer = await login(t);
    const category = await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } });
    const res = await http()
      .post('/requests')
      .set('X-Forwarded-For', uniqueIp())
      .set(...bearer(employer.accessToken))
      .send({
        categoryId: category.id,
        description: 'Se rompió la cañería del patio y sale agua sin parar.',
        ...far,
        address: 'Lejos del centro',
        proposedPriceBs: '150.00',
      });
    expect(res.status).toBe(400);
    expect((res.body as { code: string }).code).toBe('LOCATION_OUTSIDE_CITY');

    const audit = await t.prisma.adminAuditLog.findFirst({
      where: { action: 'catalog.city_area_set', targetId: cityId },
      orderBy: { createdAt: 'desc' },
    });
    expect(audit?.reason).toBe('Zona del piloto (prueba e2e)');
  });

  it('null vuelve al radio', async () => {
    const res = await put({ geojson: null, radiusKm: radiusBefore }).expect(200);
    expect(res.body).toMatchObject({ geojson: null, radiusKm: radiusBefore });
  });
});
