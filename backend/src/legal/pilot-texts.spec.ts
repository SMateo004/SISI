import type { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import { FeatureFlagsService } from '../feature-flags/feature-flags.service';
import { PilotService } from '../pilot/pilot.service';
import type { PrismaService } from '../prisma/prisma.service';
import { parseLegalFile } from './legal-source';
import { LegalService } from './legal.service';
import { pilotFlagOnInDb, pilotOnlyTextsActive } from './pilot-texts';

const FINAL = 'Texto aprobado.';
const doc = (type: string, version: number, pilotOnly: boolean, contentMd = FINAL) => ({
  type,
  version,
  pilotOnly,
  title: type,
  contentMd,
  publishedAt: new Date('2026-10-01T00:00:00Z'),
});

/** Prisma de mentira: textos vigentes (orden type asc, version desc) y filas de pilot.closed. */
function fakePrisma(
  docs: ReturnType<typeof doc>[],
  flags: { cityId: string | null; enabled: boolean }[] = [],
) {
  const sorted = [...docs].sort((a, b) =>
    a.type === b.type ? b.version - a.version : a.type.localeCompare(b.type),
  );
  return {
    legalDocument: { findMany: jest.fn().mockResolvedValue(sorted) },
    featureFlag: { findMany: jest.fn().mockResolvedValue(flags) },
    city: {
      findUniqueOrThrow: jest.fn().mockResolvedValue({ id: 'scz', name: 'Santa Cruz' }),
      findUnique: jest.fn().mockResolvedValue(null),
    },
    user: { findUnique: jest.fn().mockResolvedValue(null) },
    pilotAllowedPhone: { findUnique: jest.fn().mockResolvedValue(null) },
  };
}

const configFor = (env: string) =>
  ({
    get: (key: string) => ({ APP_ENV: env, DEFAULT_CITY_SLUG: 'santa-cruz' })[key],
  }) as unknown as AppConfigService & ConfigService;

const redis = { get: jest.fn(), set: jest.fn(), del: jest.fn() } as unknown as Redis;
const asPrisma = (p: ReturnType<typeof fakePrisma>) => p as unknown as PrismaService;

describe('textos v0 del piloto cerrado (ADR-0051)', () => {
  it('el encabezado stage: piloto-cerrado marca el texto como del piloto', () => {
    const raw = (stage: string) =>
      `---\ntype: terms\nversion: 1\ntitle: Términos\n${stage}---\n\nHola`;
    expect(parseLegalFile('t.md', raw('stage: piloto-cerrado\n')).pilotOnly).toBe(true);
    expect(parseLegalFile('t.md', raw('')).pilotOnly).toBe(false);
    expect(() => parseLegalFile('t.md', raw('stage: abierto\n'))).toThrow(/stage/);
  });

  it('cuenta solo la versión vigente de cada tipo', async () => {
    const v0 = fakePrisma([doc('terms', 1, true), doc('privacy', 1, true)]);
    expect(await pilotOnlyTextsActive(asPrisma(v0))).toBe(true);
    // Publicados los definitivos (v2) de los dos, el v0 ya no cuenta.
    const final = fakePrisma([
      doc('terms', 1, true),
      doc('terms', 2, false),
      doc('privacy', 1, true),
      doc('privacy', 2, false),
    ]);
    expect(await pilotOnlyTextsActive(asPrisma(final))).toBe(false);
    // Con uno solo reemplazado, el otro sigue siendo del piloto.
    const half = fakePrisma([doc('terms', 2, false), doc('privacy', 1, true)]);
    expect(await pilotOnlyTextsActive(asPrisma(half))).toBe(true);
  });

  it('el flag se lee de la base: la ciudad manda sobre el global', async () => {
    const read = (flags: { cityId: string | null; enabled: boolean }[]) =>
      pilotFlagOnInDb(asPrisma(fakePrisma([], flags)), 'scz');
    expect(await read([])).toBe(false);
    expect(await read([{ cityId: null, enabled: true }])).toBe(true);
    expect(
      await read([
        { cityId: null, enabled: true },
        { cityId: 'scz', enabled: false },
      ]),
    ).toBe(false);
  });

  describe('arranque de producción', () => {
    const start = async (prisma: ReturnType<typeof fakePrisma>) => {
      const service = new LegalService(asPrisma(prisma), redis, configFor('production'));
      try {
        await service.onModuleInit();
      } finally {
        service.onModuleDestroy();
      }
    };

    it('no arranca con los textos v0 y pilot.closed apagado', async () => {
      const prisma = fakePrisma(
        [doc('terms', 1, true), doc('privacy', 1, true)],
        [{ cityId: 'scz', enabled: false }],
      );
      await expect(start(prisma)).rejects.toThrow(/textos v0 del piloto.*pilot\.closed apagado/);
    });

    it('arranca con los textos v0 y pilot.closed encendido', async () => {
      const prisma = fakePrisma(
        [doc('terms', 1, true), doc('privacy', 1, true)],
        [{ cityId: 'scz', enabled: true }],
      );
      await expect(start(prisma)).resolves.toBeUndefined();
    });

    it('con los textos definitivos no exige el flag', async () => {
      const prisma = fakePrisma([doc('terms', 2, false), doc('privacy', 2, false)]);
      await expect(start(prisma)).resolves.toBeUndefined();
      expect(prisma.featureFlag.findMany).not.toHaveBeenCalled();
    });

    it('un v0 que sigue con la línea de revisión tampoco arranca (es borrador)', async () => {
      const prisma = fakePrisma(
        [doc('terms', 1, true, '⚠️ PENDIENTE DE REVISIÓN LEGAL ⚠️'), doc('privacy', 1, true)],
        [{ cityId: 'scz', enabled: true }],
      );
      await expect(start(prisma)).rejects.toThrow(/borradores: terms/);
    });
  });

  describe('apagar pilot.closed', () => {
    const v0 = () => fakePrisma([doc('terms', 1, true), doc('privacy', 1, true)]);

    it('en producción, 409 mientras los textos vigentes sean los v0', async () => {
      const flags = new FeatureFlagsService(asPrisma(v0()), redis, configFor('production'));
      await expect(
        flags.set('pilot.closed', { cityId: 'scz', enabled: false }, 'admin'),
      ).rejects.toMatchObject({ code: 'PILOT_TEXTS_ACTIVE' });
    });

    it('encenderlo, otro flag u otro ambiente siguen el camino normal', async () => {
      // La ciudad de mentira no existe: llegar a CITY_NOT_FOUND prueba que pasó el chequeo.
      const prod = new FeatureFlagsService(asPrisma(v0()), redis, configFor('production'));
      await expect(
        prod.set('pilot.closed', { cityId: 'scz', enabled: true }, 'admin'),
      ).rejects.toMatchObject({ code: 'CITY_NOT_FOUND' });
      await expect(
        prod.set('payments.gateway', { cityId: 'scz', enabled: false }, 'admin'),
      ).rejects.toMatchObject({ code: 'CITY_NOT_FOUND' });
      const staging = new FeatureFlagsService(asPrisma(v0()), redis, configFor('staging'));
      await expect(
        staging.set('pilot.closed', { cityId: 'scz', enabled: false }, 'admin'),
      ).rejects.toMatchObject({ code: 'CITY_NOT_FOUND' });
    });
  });

  describe('ingreso de un número nuevo', () => {
    const pilot = (env: string, flagOn: boolean, pilotTexts: boolean) => {
      const prisma = fakePrisma([doc('terms', 1, pilotTexts), doc('privacy', 1, pilotTexts)]);
      const flags = { isEnabled: jest.fn().mockResolvedValue(flagOn) };
      return new PilotService(
        asPrisma(prisma),
        flags as unknown as FeatureFlagsService,
        configFor(env),
      );
    };

    it('en producción con los textos v0 se falla cerrado aunque el flag esté apagado', async () => {
      await expect(
        pilot('production', false, true).assertCanSignIn('+59170000001'),
      ).rejects.toMatchObject({ code: 'PILOT_NOT_ALLOWED' });
    });

    it('sin textos v0, o fuera de producción, manda el flag', async () => {
      await expect(
        pilot('production', false, false).assertCanSignIn('+59170000001'),
      ).resolves.toBeUndefined();
      await expect(
        pilot('development', false, true).assertCanSignIn('+59170000001'),
      ).resolves.toBeUndefined();
      await expect(
        pilot('development', true, false).assertCanSignIn('+59170000001'),
      ).rejects.toMatchObject({ code: 'PILOT_NOT_ALLOWED' });
    });
  });
});
