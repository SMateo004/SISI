import 'dotenv/config';
import { defineConfig } from 'prisma/config';

// `prisma generate` (postinstall) no necesita base de datos: no exigimos DATABASE_URL aquí.
// migrate/seed fallan con un error claro si falta.
export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
    seed: 'tsx prisma/seed.ts',
  },
  datasource: {
    url: process.env.DATABASE_URL ?? '',
  },
});
