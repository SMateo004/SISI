import request from 'supertest';
import { LegalService } from '../src/legal/legal.service';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';

/** Textos legales con versión y aceptación (e2e, ADR-0051). */
describe('Textos legales y consentimiento (e2e)', () => {
  let t: TestApp;
  const http = () => request(t.app.getHttpServer());
  const versionOf = async (type: 'terms' | 'privacy') =>
    (
      (await http().get('/legal/current').expect(200)).body as {
        type: string;
        version: number;
        draft: boolean;
        pilotOnly: boolean;
      }[]
    ).find((d) => d.type === type);

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.prisma.legalDocument.deleteMany({ where: { version: { gte: 900 } } });
    await t.close();
  });

  it('los textos vigentes son públicos y hoy son borradores con marcador', async () => {
    const terms = await versionOf('terms');
    const privacy = await versionOf('privacy');
    expect(terms).toMatchObject({ version: 1, draft: true, pilotOnly: true });
    expect(privacy).toMatchObject({ version: 1, draft: true, pilotOnly: true });
  });

  it('sin aceptar: /me avisa qué falta y el resto responde 403 LEGAL_ACCEPTANCE_REQUIRED', async () => {
    const user = await login(t, undefined, { acceptLegal: false });
    const me = await http()
      .get('/me')
      .set(...bearer(user.accessToken))
      .expect(200);
    expect((me.body as { legalPending: string[] }).legalPending.sort()).toEqual([
      'privacy',
      'terms',
    ]);
    const blocked = await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken));
    expect(blocked.status).toBe(403);
    expect((blocked.body as { code: string; pending: string[] }).code).toBe(
      'LEGAL_ACCEPTANCE_REQUIRED',
    );
  });

  it('exige la mayoría de edad y la versión mostrada; luego registra la aceptación', async () => {
    const user = await login(t, undefined, { acceptLegal: false });
    const accept = (body: Record<string, unknown>) =>
      http()
        .post('/me/legal/accept')
        .set(...bearer(user.accessToken))
        .send({ termsVersion: 1, privacyVersion: 1, adult: true, platform: 'android', ...body });
    expect((await accept({ adult: false })).status).toBe(400);
    const stale = await accept({ termsVersion: 7 });
    expect(stale.status).toBe(409);
    expect((stale.body as { code: string }).code).toBe('LEGAL_VERSION_CHANGED');

    const ok = await accept({ appVersion: '0.9.0+3' });
    expect(ok.status).toBe(200);
    expect(ok.body).toEqual({ legalPending: [] });
    await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken))
      .expect(200);
    const rows = await t.prisma.legalAcceptance.findMany({ where: { userId: user.user.id } });
    expect(rows.map((r) => [r.type, r.version, r.adultDeclared, r.appVersion]).sort()).toEqual([
      ['privacy', 1, true, '0.9.0+3'],
      ['terms', 1, true, '0.9.0+3'],
    ]);
  });

  it('una versión nueva de los términos vuelve a pedir la aceptación', async () => {
    const user = await login(t);
    await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken))
      .expect(200);

    await t.prisma.legalDocument.create({
      data: { type: 'terms', version: 901, title: 'Términos de uso', contentMd: 'Versión nueva.' },
    });
    await t.app.get(LegalService).reload();

    const blocked = await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken));
    expect(blocked.status).toBe(403);
    const me = await http()
      .get('/me')
      .set(...bearer(user.accessToken))
      .expect(200);
    expect((me.body as { legalPending: string[] }).legalPending).toEqual(['terms']);

    await http()
      .post('/me/legal/accept')
      .set(...bearer(user.accessToken))
      .send({ termsVersion: 901, privacyVersion: 1, adult: true })
      .expect(200);
    await http()
      .get('/requests/mine')
      .set(...bearer(user.accessToken))
      .expect(200);

    await t.prisma.legalDocument.deleteMany({ where: { version: 901 } });
    await t.app.get(LegalService).reload();
  });

  it('la aceptación es append-only', async () => {
    const user = await login(t);
    await expect(
      t.prisma.legalAcceptance.updateMany({
        where: { userId: user.user.id },
        data: { version: 99 },
      }),
    ).rejects.toThrow(/append-only/);
    await expect(
      t.prisma.legalAcceptance.deleteMany({ where: { userId: user.user.id } }),
    ).rejects.toThrow(/append-only/);
  });
});
