import { execSync } from 'node:child_process';
import { Redis } from 'ioredis';
import { applyE2eEnv } from './e2e-env';

/** Migra y siembra la base de pruebas, y limpia el Redis de pruebas (contadores y OTP). */
export default async function globalSetup(): Promise<void> {
  applyE2eEnv();
  execSync('npx prisma migrate deploy', { stdio: 'inherit', env: process.env });
  execSync('npx prisma db seed', { stdio: 'inherit', env: process.env });

  const redis = new Redis(process.env.REDIS_URL ?? '');
  await redis.flushdb();
  await redis.quit();
}
