import request from 'supertest';
import type { CreatedRequestDto, PublishResultDto } from '../../src/requests/dto/request.dto';
import { bearer, type TestApp, uniqueIp } from './test-app';

/** Cerca de la Plaza 24 de Septiembre (dentro del radio provisional de 15 km). */
export const CENTRO = { latitude: -17.7834, longitude: -63.1821 };

/** Punto a `metros` al este de `from` (aprox.; suficiente a escala de ciudad). */
export function eastOf(from: { latitude: number; longitude: number }, meters: number) {
  const metersPerDegree = 111_320 * Math.cos((from.latitude * Math.PI) / 180);
  return { latitude: from.latitude, longitude: from.longitude + meters / metersPerDegree };
}

/** Crea y publica una solicitud limpia (queda en buscando). Devuelve su id. */
export async function publishRequest(
  t: TestApp,
  token: string,
  overrides: Record<string, unknown> = {},
): Promise<string> {
  const server = t.app.getHttpServer();
  const categoryId =
    (overrides.categoryId as string | undefined) ??
    (await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } })).id;
  const created = (
    await request(server)
      .post('/requests')
      .set('X-Forwarded-For', uniqueIp())
      .set(...bearer(token))
      .send({
        description: 'Tengo una fuga debajo del lavaplatos de la cocina, gotea constantemente.',
        ...CENTRO,
        address: 'Calle Junín 150, entre Ayacucho y Sucre',
        proposedPriceBs: '150.00',
        ...overrides,
        categoryId,
      })
      .expect(201)
  ).body as CreatedRequestDto;
  const published = (
    await request(server)
      .post(`/requests/${created.request.id}/publish`)
      .set(...bearer(token))
      .expect(200)
  ).body as PublishResultDto;
  if (published.held) throw new Error('La solicitud de prueba quedó retenida');
  return created.request.id;
}
