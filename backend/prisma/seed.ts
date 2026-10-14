import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../src/generated/prisma/client';
import { CATEGORIES } from './seed-data/categories';
import { CITIES } from './seed-data/cities';
import { MODERATION_TERMS } from './seed-data/moderation-terms';

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
  } finally {
    await prisma.$disconnect();
  }
}

void main();
