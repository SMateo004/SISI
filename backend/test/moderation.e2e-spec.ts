import request from 'supertest';
import { ModerationService } from '../src/moderation/moderation.service';
import type { ModerationTermDto } from '../src/moderation/moderation-terms.controller';
import { bearer, createTestApp, login, loginAsAdmin, type TestApp } from './utils/test-app';

describe('Moderación (e2e)', () => {
  let t: TestApp;
  let moderation: ModerationService;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp();
    moderation = t.app.get(ModerationService);
  });

  afterAll(async () => {
    await t.close();
  });

  it('retiene textos con términos del seed, también con evasiones', async () => {
    for (const text of [
      'Necesito que me traigan cocaína a domicilio',
      'busco quien me consiga c.o.c.a.i.n.a rápido',
      'servicio de chicas prepago a domicilio',
      'Vendo zapatillas Bs 150 c/u',
    ]) {
      const result = await moderation.check(text);
      expect([text, result.held]).toEqual([text, true]);
      expect(result.matches.length).toBeGreaterThan(0);
    }
    const sale = await moderation.check('Vendo zapatillas Bs 150 c/u');
    expect(sale.matches.map((m) => m.category)).toContain('venta_productos');
  });

  it('no retiene usos legítimos frecuentes', async () => {
    for (const text of [
      'Necesito un plomero para cambiar la llave de paso del baño',
      'Pintar dos cuartos, tengo pistola de pintura y rodillos',
      'Acompañante para mi abuela por las tardes, cuidado de adulto mayor',
      'Garzón para un evento, se sirve mate de hoja de coca',
      'Armar un armario de melamina',
    ]) {
      expect([text, (await moderation.check(text)).held]).toEqual([text, false]);
    }
  });

  describe('admin de términos', () => {
    it('agregar y desactivar un término se aplica de inmediato', async () => {
      const admin = await loginAsAdmin(t);
      const word = `palabraprohibida${Date.now().toString(36)}`;
      expect((await moderation.check(`texto con ${word}`)).held).toBe(false);

      const created = (
        await request(server())
          .post('/admin/moderation-terms')
          .set(...bearer(admin.accessToken))
          .send({ term: word, kind: 'word', category: 'ilegal' })
          .expect(201)
      ).body as ModerationTermDto;
      expect((await moderation.check(`texto con ${word}`)).held).toBe(true);

      await request(server())
        .delete(`/admin/moderation-terms/${created.id}`)
        .set(...bearer(admin.accessToken))
        .expect(204);
      expect((await moderation.check(`texto con ${word}`)).held).toBe(false);

      const dup = await request(server())
        .post('/admin/moderation-terms')
        .set(...bearer(admin.accessToken))
        .send({ term: word, kind: 'word', category: 'ilegal' })
        .expect(409);
      expect(dup.body).toMatchObject({ code: 'MODERATION_TERM_EXISTS' });
    });

    it('rechaza regex peligrosos con el motivo en español', async () => {
      const admin = await loginAsAdmin(t);
      const res = await request(server())
        .post('/admin/moderation-terms')
        .set(...bearer(admin.accessToken))
        .send({ term: '(a+)+$', kind: 'regex', category: 'ilegal' })
        .expect(400);
      expect(res.body).toMatchObject({
        code: 'MODERATION_PATTERN_INVALID',
        message:
          'No se permiten cuantificadores anidados ni alternativas repetidas: pueden ser muy lentos.',
      });
    });

    it('un usuario sin rol admin recibe 403', async () => {
      const user = await login(t);
      await request(server())
        .get('/admin/moderation-terms')
        .set(...bearer(user.accessToken))
        .expect(403);
    });
  });
});
