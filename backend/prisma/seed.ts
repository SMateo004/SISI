import 'dotenv/config';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../src/generated/prisma/client';

/**
 * Datos de referencia. Idempotente: solo crea lo que falta y nunca pisa cambios
 * hechos desde el panel admin (por eso `update: {}`).
 */
const CITIES = [
  {
    slug: 'santa-cruz',
    name: 'Santa Cruz de la Sierra',
    countryCode: 'BO',
    timezone: 'America/La_Paz',
    active: true,
  },
] as const;

async function main(): Promise<void> {
  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) throw new Error('DATABASE_URL no está definida');

  const prisma = new PrismaClient({ adapter: new PrismaPg({ connectionString }) });
  try {
    for (const city of CITIES) {
      await prisma.city.upsert({ where: { slug: city.slug }, create: city, update: {} });
      console.log(`Ciudad lista: ${city.name}`);
    }
  } finally {
    await prisma.$disconnect();
  }
}

void main();
