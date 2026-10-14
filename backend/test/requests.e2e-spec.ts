import { EventEmitter2 } from '@nestjs/event-emitter';
import request from 'supertest';
import type {
  AdminHeldRequestDto,
  CreatedRequestDto,
  PublishResultDto,
  RequestDto,
  RequestPageDto,
} from '../src/requests/dto/request.dto';
import { RequestEvents, type RequestSearchingEvent } from '../src/requests/request.events';
import type { PresignedUploadDto } from '../src/storage/dto/upload.dto';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  loginAsAdmin,
  type TestApp,
  uniqueIp,
} from './utils/test-app';
import { fakeJpeg, putPresigned } from './utils/upload';

// Cerca de la Plaza 24 de Septiembre (dentro del radio provisional de 15 km).
const CENTRO = { latitude: -17.7834, longitude: -63.1821 };
const LA_PAZ = { latitude: -16.5, longitude: -68.15 };

describe('Solicitudes de servicio (e2e)', () => {
  let t: TestApp;
  let plomeriaId: string;
  let emit: jest.SpyInstance;
  const server = () => t.app.getHttpServer();

  const draft = (overrides: Record<string, unknown> = {}) => ({
    categoryId: plomeriaId,
    description: 'Tengo una fuga debajo del lavaplatos de la cocina, gotea constantemente.',
    ...CENTRO,
    address: 'Calle Junín 150, entre Ayacucho y Sucre',
    proposedPriceBs: '150.00',
    ...overrides,
  });

  const create = async (token: string, overrides: Record<string, unknown> = {}) =>
    (
      await request(server())
        .post('/requests')
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(token))
        .send(draft(overrides))
        .expect(201)
    ).body as CreatedRequestDto;

  const publish = (token: string, id: string) =>
    request(server())
      .post(`/requests/${id}/publish`)
      .set(...bearer(token));

  const uploadPhoto = async (token: string, id: string, size = 2048) => {
    const file = fakeJpeg(size);
    const upload = (
      await request(server())
        .post(`/requests/${id}/photos/upload-url`)
        .set(...bearer(token))
        .send({ contentType: 'image/jpeg', sizeBytes: file.length })
        .expect(201)
    ).body as PresignedUploadDto;
    expect(await putPresigned(upload, file)).toBe(200);
    return (
      await request(server())
        .put(`/requests/${id}/photos`)
        .set(...bearer(token))
        .send({ key: upload.key })
        .expect(200)
    ).body as RequestDto;
  };

  beforeAll(async () => {
    t = await createTestApp();
    plomeriaId = (await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } })).id;
    emit = jest.spyOn(t.app.get(EventEmitter2), 'emit');
  });

  afterAll(async () => {
    await t.close();
  });

  beforeEach(() => {
    emit.mockClear();
  });

  it('publica una solicitud normal con fotos: queda en buscando y emite request.searching', async () => {
    const { accessToken } = await login(t);
    const created = await create(accessToken);
    expect(created.warnings).toEqual([]);
    expect(created.request).toMatchObject({
      status: 'borrador',
      category: { slug: 'plomeria', name: 'Plomería' },
      proposedPriceBs: '150.00',
      latitude: CENTRO.latitude,
      longitude: CENTRO.longitude,
    });

    const id = created.request.id;
    await uploadPhoto(accessToken, id);
    const withPhotos = await uploadPhoto(accessToken, id, 3000);
    expect(withPhotos.photos.map((p) => p.position)).toEqual([0, 1]);

    const published = (await publish(accessToken, id).expect(200)).body as PublishResultDto;
    expect(published).toMatchObject({
      held: false,
      message: '¡Listo! Estamos buscando trabajadores cerca de ti.',
      request: { status: 'buscando' },
    });
    expect(published.request.publishedAt).not.toBeNull();

    const calls = emit.mock.calls as [string, unknown][];
    const searching = calls.find(([name]) => name === RequestEvents.searching);
    expect(searching?.[1]).toMatchObject({
      requestId: id,
      categoryId: plomeriaId,
      location: { lat: CENTRO.latitude, lng: CENTRO.longitude },
    } satisfies Partial<RequestSearchingEvent>);

    // Las fotos solo se leen con URL firmada.
    const detail = (
      await request(server())
        .get(`/requests/${id}`)
        .set(...bearer(accessToken))
        .expect(200)
    ).body as RequestDto;
    const photoUrl = detail.photos[0]?.url ?? '';
    expect((await fetch(photoUrl)).status).toBe(200);
    expect((await fetch(photoUrl.split('?')[0] ?? '')).status).toBe(403);

    const mine = (
      await request(server())
        .get('/requests/mine')
        .set(...bearer(accessToken))
        .expect(200)
    ).body as RequestPageDto;
    expect(mine.items.map((r) => r.id)).toContain(id);

    // No se publica dos veces ni se cambian fotos después de publicar.
    await publish(accessToken, id).expect(409);
    await request(server())
      .post(`/requests/${id}/photos/upload-url`)
      .set(...bearer(accessToken))
      .send({ contentType: 'image/jpeg', sizeBytes: 100 })
      .expect(409);
  });

  it('advierte si el precio está bajo el mínimo de referencia, pero permite publicar (R3.2)', async () => {
    const { accessToken } = await login(t);
    const created = await create(accessToken, { proposedPriceBs: '50' });
    expect(created.warnings).toEqual([
      expect.objectContaining({ code: 'PRICE_BELOW_REFERENCE', referenceMinBs: '80.00' }),
    ]);
    const published = (await publish(accessToken, created.request.id).expect(200))
      .body as PublishResultDto;
    expect(published.request.status).toBe('buscando');
    expect(published.warnings[0]?.message).toContain('Bs 80,00');
  });

  describe('moderación (R3.3)', () => {
    it('con un término prohibido queda retenida con mensaje neutral; el admin la libera', async () => {
      const { accessToken } = await login(t);
      const created = await create(accessToken, {
        description: 'Necesito que me traigan c.o.c.a.i.n.a a domicilio esta noche, pago bien',
      });
      const res = await publish(accessToken, created.request.id).expect(200);
      const body = res.body as PublishResultDto;
      expect(body).toMatchObject({
        held: true,
        message: 'Recibimos tu solicitud. La estamos revisando y te avisaremos cuando se publique.',
        request: { status: 'retenida' },
      });
      // Al empleador nunca se le dice qué término coincidió.
      expect(JSON.stringify(res.body)).not.toMatch(/cocain|matches|drogas/i);
      expect(emit.mock.calls.some(([name]) => name === RequestEvents.searching)).toBe(false);

      const admin = await loginAsAdmin(t);
      const held = (
        await request(server())
          .get('/admin/requests')
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as AdminHeldRequestDto[];
      const mine = held.find((r) => r.id === created.request.id);
      expect(JSON.stringify(mine?.matches)).toContain('cocain');

      const released = (
        await request(server())
          .post(`/admin/requests/${created.request.id}/release`)
          .set(...bearer(admin.accessToken))
          .expect(200)
      ).body as RequestDto;
      expect(released.status).toBe('buscando');
      expect(emit.mock.calls.some(([name]) => name === RequestEvents.searching)).toBe(true);

      const events = await t.prisma.serviceRequestEvent.findMany({
        where: { requestId: created.request.id },
        orderBy: { createdAt: 'asc' },
      });
      expect(events.map((e) => `${e.event}:${e.toStatus}`)).toEqual([
        'CREATE:borrador',
        'PUBLISH_HELD:retenida',
        'RELEASE:buscando',
      ]);
    });

    it('el admin puede rechazar una retenida: queda cancelada por moderación', async () => {
      const { accessToken } = await login(t);
      const created = await create(accessToken, {
        description: 'Vendo zapatillas originales a Bs 150 c/u, entrega a domicilio',
      });
      await publish(accessToken, created.request.id).expect(200);
      const admin = await loginAsAdmin(t);
      await request(server())
        .post(`/admin/requests/${created.request.id}/reject`)
        .set(...bearer(admin.accessToken))
        .send({ reason: 'Venta de productos, no un servicio.' })
        .expect(200);
      const detail = (
        await request(server())
          .get(`/requests/${created.request.id}`)
          .set(...bearer(accessToken))
          .expect(200)
      ).body as RequestDto;
      expect(detail).toMatchObject({
        status: 'cancelada',
        statusMessage:
          'Tu solicitud no pudo publicarse porque no cumple las normas de uso de SISI.',
      });
    });

    it('un usuario sin rol admin no puede ver ni liberar retenidas', async () => {
      const { accessToken } = await login(t);
      await request(server())
        .get('/admin/requests')
        .set(...bearer(accessToken))
        .expect(403);
      await request(server())
        .post('/admin/requests/00000000-0000-4000-8000-000000000000/release')
        .set(...bearer(accessToken))
        .expect(403);
    });
  });

  it('cancela mientras no esté asignada; solo el dueño ve y cancela', async () => {
    const owner = await login(t);
    const created = await create(owner.accessToken);
    await publish(owner.accessToken, created.request.id).expect(200);

    const other = await login(t);
    await request(server())
      .get(`/requests/${created.request.id}`)
      .set(...bearer(other.accessToken))
      .expect(404);
    await request(server())
      .post(`/requests/${created.request.id}/cancel`)
      .set(...bearer(other.accessToken))
      .expect(404);

    const cancelled = (
      await request(server())
        .post(`/requests/${created.request.id}/cancel`)
        .set(...bearer(owner.accessToken))
        .expect(200)
    ).body as RequestDto;
    expect(cancelled).toMatchObject({
      status: 'cancelada',
      statusMessage: 'Cancelaste esta solicitud.',
    });
    const again = await request(server())
      .post(`/requests/${created.request.id}/cancel`)
      .set(...bearer(owner.accessToken))
      .expect(409);
    expect(again.body).toMatchObject({ message: 'Esta solicitud ya no se puede cancelar.' });

    // Una asignada tampoco se puede cancelar (R3.4).
    const assigned = await create(owner.accessToken);
    await t.prisma.serviceRequest.update({
      where: { id: assigned.request.id },
      data: { status: 'asignada' },
    });
    await request(server())
      .post(`/requests/${assigned.request.id}/cancel`)
      .set(...bearer(owner.accessToken))
      .expect(409);
  });

  describe('validaciones', () => {
    it('rechaza ubicaciones fuera de la ciudad y categorías de otra ciudad', async () => {
      const { accessToken } = await login(t);
      const outside = await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft(LA_PAZ))
        .expect(400);
      expect(outside.body).toMatchObject({ code: 'LOCATION_OUTSIDE_CITY' });

      const otherCity = await t.prisma.city.create({
        data: {
          slug: `otra-${Date.now()}`,
          name: 'Otra',
          countryCode: 'BO',
          timezone: 'America/La_Paz',
        },
      });
      const elsewhere = await createCategory(t, { cityId: otherCity.id });
      const res = await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft({ categoryId: elsewhere.id }))
        .expect(400);
      expect(res.body).toMatchObject({ code: 'CATEGORY_NOT_AVAILABLE' });
    });

    it('con polígono de servicio manda el polígono (PostGIS)', async () => {
      const city = await t.prisma.city.create({
        data: {
          slug: `poly-${Date.now()}`,
          name: 'Con polígono',
          countryCode: 'BO',
          timezone: 'America/La_Paz',
        },
      });
      // Cuadrado chico alrededor de la plaza (≈ 2 km de lado).
      await t.prisma.$executeRaw`
        UPDATE cities SET service_area = ST_GeogFromText(
          'POLYGON((-63.192 -17.793, -63.172 -17.793, -63.172 -17.773, -63.192 -17.773, -63.192 -17.793))')
        WHERE id = ${city.id}::uuid`;
      const category = await createCategory(t, { cityId: city.id });
      const { accessToken, user } = await login(t);
      await t.prisma.user.update({ where: { id: user.id }, data: { cityId: city.id } });

      await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft({ categoryId: category.id }))
        .expect(201);
      // A 5 km de la plaza: dentro del radio de Santa Cruz, pero fuera del polígono.
      const res = await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft({ categoryId: category.id, latitude: -17.74, longitude: -63.18 }))
        .expect(400);
      expect(res.body).toMatchObject({ code: 'LOCATION_OUTSIDE_CITY' });
    });

    it('rechaza descripción fuera de rango, precio 0 y más de 4 fotos', async () => {
      const { accessToken } = await login(t);
      const short = await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft({ description: 'Fuga' }))
        .expect(400);
      expect(short.body).toMatchObject({
        code: 'DESCRIPTION_LENGTH',
        message: 'Describe el trabajo con entre 20 y 1000 caracteres.',
      });
      await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft({ description: 'x'.repeat(1001) }))
        .expect(400);
      const zero = await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft({ proposedPriceBs: '0' }))
        .expect(400);
      expect(zero.body).toMatchObject({ code: 'PRICE_INVALID' });

      const created = await create(accessToken);
      for (let i = 0; i < 4; i++) await uploadPhoto(accessToken, created.request.id);
      const fifth = await request(server())
        .post(`/requests/${created.request.id}/photos/upload-url`)
        .set(...bearer(accessToken))
        .send({ contentType: 'image/jpeg', sizeBytes: 100 })
        .expect(400);
      expect(fifth.body).toMatchObject({
        code: 'TOO_MANY_PHOTOS',
        message: 'Puedes subir hasta 4 fotos.',
      });
    });

    it('en modo trabajador no se pueden crear ni publicar solicitudes', async () => {
      const { accessToken, user } = await login(t);
      const created = await create(accessToken);
      await t.prisma.user.update({ where: { id: user.id }, data: { activeMode: 'worker' } });
      const res = await request(server())
        .post('/requests')
        .set(...bearer(accessToken))
        .send(draft())
        .expect(403);
      expect(res.body).toMatchObject({
        code: 'EMPLOYER_MODE_REQUIRED',
        message: 'Cambia a modo empleador para pedir un servicio.',
      });
      await publish(accessToken, created.request.id).expect(403);
    });

    it('limita las publicaciones por usuario (10 por hora)', async () => {
      const { accessToken } = await login(t);
      for (let i = 0; i < 10; i++) {
        const created = await create(accessToken);
        await publish(accessToken, created.request.id).expect(200);
      }
      const extra = await create(accessToken);
      const res = await publish(accessToken, extra.request.id).expect(429);
      expect(res.body).toMatchObject({ code: 'RATE_LIMITED' });
      expect(res.headers['retry-after']).toBeDefined();
    });
  });
});
