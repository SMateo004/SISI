/**
 * Textos "v0" del piloto cerrado (ADR-0051, ADR-0052). Valen solo con la lista de teléfonos del
 * piloto activa: mientras sean los vigentes, producción exige el flag `pilot.closed` encendido en
 * la ciudad por defecto (la API no arranca sin él, el panel no lo deja apagar y el ingreso se
 * trata como cerrado aunque el flag falte).
 *
 * Sin dependencias de Nest: lo usan la API, el seed y los tests con el mismo criterio.
 */
import type { PrismaClient } from '../generated/prisma/client';

export const PILOT_FLAG = 'pilot.closed';

/** Lo mínimo de Prisma que hace falta (PrismaService o el PrismaClient del seed). */
export type PilotTextsDb = Pick<PrismaClient, 'legalDocument' | 'featureFlag'>;

/** ¿Alguno de los textos vigentes (la versión publicada más alta de cada tipo) es del piloto? */
export async function pilotOnlyTextsActive(db: PilotTextsDb, now = new Date()): Promise<boolean> {
  const rows = await db.legalDocument.findMany({
    where: { publishedAt: { lte: now } },
    orderBy: [{ type: 'asc' }, { version: 'desc' }],
    select: { type: true, pilotOnly: true },
  });
  const seen = new Set<string>();
  for (const row of rows) {
    if (seen.has(row.type)) continue;
    seen.add(row.type);
    if (row.pilotOnly) return true;
  }
  return false;
}

/**
 * Valor de `pilot.closed` en la ciudad leído de la base, sin la caché de Redis (al arrancar no
 * sirve un valor de hace 60 s). Misma regla que resolveFlag: la ciudad manda sobre el global.
 */
export async function pilotFlagOnInDb(db: PilotTextsDb, cityId: string): Promise<boolean> {
  const rows = await db.featureFlag.findMany({
    where: { key: PILOT_FLAG, OR: [{ cityId }, { cityId: null }] },
    select: { cityId: true, enabled: true },
  });
  const city = rows.find((r) => r.cityId === cityId);
  if (city) return city.enabled;
  return rows.find((r) => r.cityId === null)?.enabled ?? false;
}
