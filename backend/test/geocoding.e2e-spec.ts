import request from 'supertest';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';

describe('Geocodificación inversa (e2e)', () => {
  let t: TestApp;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  it('devuelve la dirección sugerida (proveedor falso en test) y exige sesión', async () => {
    await request(server()).get('/geocoding/reverse?lat=-17.7834&lng=-63.1821').expect(401);
    const { accessToken } = await login(t);
    const res = await request(server())
      .get('/geocoding/reverse?lat=-17.7834&lng=-63.1821')
      .set(...bearer(accessToken))
      .expect(200);
    expect(res.body).toEqual({
      address: 'Dirección de prueba (-17.78340, -63.18210), Santa Cruz de la Sierra',
    });
    // La respuesta nunca incluye la llave de Maps.
    expect(JSON.stringify(res.body)).not.toMatch(/key|AIza/i);
  });

  it('rechaza coordenadas inválidas', async () => {
    const { accessToken } = await login(t);
    const res = await request(server())
      .get('/geocoding/reverse?lat=200&lng=-63')
      .set(...bearer(accessToken))
      .expect(400);
    expect(res.body).toMatchObject({ message: 'La ubicación no es válida.' });
  });
});
