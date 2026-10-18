import request from 'supertest';
import type {
  ModerationTermDto,
  ModerationTestResultDto,
} from '../src/moderation/dto/moderation-terms.dto';
import { expectAudited } from './utils/audit';
import {
  type AdminSession,
  bearer,
  createTestApp,
  loginAsAdmin,
  type TestApp,
  uniqueSuffix,
} from './utils/test-app';

/** Términos de moderación en el panel (ADR-0018): CRUD auditado, validación y probador. */
describe('Términos de moderación en el panel (e2e)', () => {
  let t: TestApp;
  let admin: AdminSession;

  beforeAll(async () => {
    t = await createTestApp();
    admin = await loginAsAdmin(t);
  });

  afterAll(async () => {
    await t.close();
  });

  const call = (method: 'get' | 'post' | 'patch' | 'delete', path: string, body?: object) =>
    request(t.app.getHttpServer())
      [method](path)
      .set(...bearer(admin.accessToken))
      .send(body);
  const probe = (text: string) =>
    call('post', '/admin/moderation-terms/test', { text })
      .expect(200)
      .then((r) => r.body as ModerationTestResultDto);

  it('crear un término lo aplica de inmediato (invalidación por versión) y queda auditado', async () => {
    const word = `zqx${uniqueSuffix()}`;
    expect((await probe(`hola ${word} chau`)).held).toBe(false);

    const created = (
      await call('post', '/admin/moderation-terms', {
        term: word,
        kind: 'word',
        category: 'ilegal',
        note: 'Prueba del panel',
      }).expect(201)
    ).body as ModerationTermDto;
    const result = await probe(`hola ${word.toUpperCase()} chau`);
    expect(result).toMatchObject({ held: true, timedOut: false });
    expect(result.matches).toEqual([
      { termId: created.id, term: word, kind: 'word', category: 'ilegal' },
    ]);
    const row = await expectAudited(t, {
      action: 'moderation.term_create',
      targetType: 'moderation_term',
      targetId: created.id,
      adminId: admin.user.id,
    });
    expect(row?.after).toMatchObject({ term: word, active: true });

    // Desactivarlo deja de aplicarlo, con su fila de auditoría (antes y después).
    await call('delete', `/admin/moderation-terms/${created.id}`).expect(204);
    expect((await probe(`hola ${word} chau`)).held).toBe(false);
    const off = await expectAudited(t, {
      action: 'moderation.term_deactivate',
      targetType: 'moderation_term',
      targetId: created.id,
      adminId: admin.user.id,
    });
    expect(off).toMatchObject({ before: { active: true }, after: { active: false } });

    // Reactivarlo con PATCH.
    await call('patch', `/admin/moderation-terms/${created.id}`, { active: true }).expect(200);
    expect((await probe(word)).held).toBe(true);
  });

  it('un regex peligroso se rechaza y no deja fila', async () => {
    const before = await t.prisma.adminAuditLog.count({ where: { adminId: admin.user.id } });
    const res = await call('post', '/admin/moderation-terms', {
      term: '(a+)+$',
      kind: 'regex',
      category: 'ilegal',
    }).expect(400);
    expect(res.body).toMatchObject({ code: 'MODERATION_PATTERN_INVALID' });
    expect(await t.prisma.adminAuditLog.count({ where: { adminId: admin.user.id } })).toBe(before);
  });

  it('el probador usa los términos sembrados y no guarda nada', async () => {
    const count = await t.prisma.moderationTerm.count();
    const result = await probe('Arreglo la ducha y de paso te vendo marihuana');
    expect(result.held).toBe(true);
    expect(result.matches.map((m) => m.category)).toContain('drogas');
    expect(await t.prisma.moderationTerm.count()).toBe(count);
    await call('post', '/admin/moderation-terms/test', { text: '' }).expect(400);
  });

  it('404 para un término inexistente', async () => {
    await call('patch', '/admin/moderation-terms/00000000-0000-4000-8000-000000000000', {
      active: false,
    }).expect(404);
  });
});
