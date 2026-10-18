import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../src/generated/prisma/client';
import { CATEGORIES } from './seed-data/categories';
import { CITIES } from './seed-data/cities';
import { FEATURE_FLAGS } from './seed-data/feature-flags';
import { MODERATION_TERMS } from './seed-data/moderation-terms';
import { isDraft, readLegalSources } from '../src/legal/legal-source';

/**
 * Datos de referencia. Idempotente: solo crea lo que falta y nunca pisa cambios
 * hechos después desde el panel admin. Corre en cada deploy (preDeployCommand).
 */
async function main(): Promise<void> {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) throw new Error('DATABASE_URL no está definida');

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  try {
    for (const { center, serviceRadiusKm, ...city } of CITIES) {
      await prisma.city.upsert({ where: { slug: city.slug }, create: city, update: {} });
      // Centro y radio solo si todavía no se configuraron.
      await prisma.$executeRaw`
        UPDATE cities
        SET center = ST_SetSRID(ST_MakePoint(${center.lng}, ${center.lat}), 4326)::geography,
            service_radius_km = ${serviceRadiusKm}::numeric
        WHERE slug = ${city.slug} AND center IS NULL`;
      console.log(`Ciudad lista: ${city.name}`);
    }

    const citiesBySlug = new Map(
      (await prisma.city.findMany({ select: { id: true, slug: true } })).map((c) => [c.slug, c.id]),
    );

    for (const { cities, ...category } of CATEGORIES) {
      const existing = await prisma.category.findUnique({ where: { slug: category.slug } });
      if (existing) continue;
      const created = await prisma.category.create({ data: category });
      for (const citySlug of cities) {
        const cityId = citiesBySlug.get(citySlug);
        if (!cityId) throw new Error(`La ciudad ${citySlug} no existe`);
        await prisma.categoryCity.create({ data: { categoryId: created.id, cityId } });
      }
      console.log(`Categoría creada: ${category.name}`);
    }
    let added = 0;
    for (const term of MODERATION_TERMS) {
      const exists = await prisma.moderationTerm.findUnique({
        where: { term_kind: { term: term.term, kind: term.kind } },
      });
      if (exists) continue;
      await prisma.moderationTerm.create({ data: term });
      added++;
    }
    console.log(`Términos de moderación agregados: ${added}`);

    for (const flag of FEATURE_FLAGS) {
      const cityId = flag.citySlug ? citiesBySlug.get(flag.citySlug) : null;
      if (cityId === undefined) throw new Error(`La ciudad ${flag.citySlug ?? ''} no existe`);
      const exists = await prisma.featureFlag.findFirst({ where: { key: flag.key, cityId } });
      if (exists) continue;
      await prisma.featureFlag.create({
        data: { key: flag.key, cityId, enabled: flag.enabled, description: flag.description },
      });
      console.log(`Flag creado: ${flag.key}${flag.citySlug ? ` (${flag.citySlug})` : ''}`);
    }

    // Textos legales (ADR-0051): una versión final nunca se pisa; un borrador sí (se edita
    // libremente hasta la revisión legal). Cambiar un texto final exige subir la versión.
    for (const doc of readLegalSources()) {
      const existing = await prisma.legalDocument.findUnique({
        where: { type_version: { type: doc.type, version: doc.version } },
      });
      if (!existing) {
        await prisma.legalDocument.create({
          data: {
            type: doc.type,
            version: doc.version,
            title: doc.title,
            contentMd: doc.contentMd,
          },
        });
        console.log(`Texto legal publicado: ${doc.type} v${String(doc.version)}`);
      } else if (existing.contentMd !== doc.contentMd) {
        if (!isDraft(existing.contentMd)) {
          throw new Error(
            `${doc.file}: la versión ${String(doc.version)} ya está publicada como final. Para cambiarla, sube la versión.`,
          );
        }
        await prisma.legalDocument.update({
          where: { id: existing.id },
          data: { title: doc.title, contentMd: doc.contentMd },
        });
        console.log(`Borrador legal actualizado: ${doc.type} v${String(doc.version)}`);
      }
    }
  } finally {
    await prisma.$disconnect();
  }
}

void main();
