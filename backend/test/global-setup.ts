import { execSync } from 'node:child_process';
import { DeleteObjectsCommand, ListObjectsV2Command, S3Client } from '@aws-sdk/client-s3';
import { Redis } from 'ioredis';
import { Client } from 'pg';
import { applyE2eEnv } from './e2e-env';

/**
 * Aislamiento de la corrida e2e (ADR-0028):
 * 1. Candado: una sola corrida a la vez contra la base, Redis y el bucket de pruebas.
 * 2. Limpieza garantizada: base vacía (y sembrada), Redis vacío y bucket vacío.
 * El candado lo libera global-teardown (o Postgres, si el proceso muere).
 */
const LOCK_KEY = 'sisi-e2e-run';

declare global {
  var __e2eLock: Client | undefined;
}

export default async function globalSetup(): Promise<void> {
  applyE2eEnv();

  const lock = new Client({ connectionString: process.env.DATABASE_URL });
  await lock.connect();
  const { rows } = await lock.query<{ ok: boolean }>(
    'SELECT pg_try_advisory_lock(hashtext($1)) AS ok',
    [LOCK_KEY],
  );
  if (!rows[0]?.ok) {
    await lock.end();
    throw new Error(
      'Ya hay otra corrida e2e usando la base de pruebas. Espera a que termine (no se pueden correr dos a la vez).',
    );
  }
  globalThis.__e2eLock = lock;

  execSync('npx prisma migrate deploy', { stdio: 'inherit', env: process.env });
  await truncateAll(lock);
  execSync('npx prisma db seed', { stdio: 'inherit', env: process.env });

  const redis = new Redis(process.env.REDIS_URL ?? '');
  await redis.flushdb();
  await redis.quit();

  await emptyBucket();
}

/** Vacía todas las tablas de la app (no las de Prisma ni las de PostGIS). */
async function truncateAll(db: Client): Promise<void> {
  const { rows } = await db.query<{ tablename: string }>(
    `SELECT tablename FROM pg_tables
     WHERE schemaname = 'public' AND tablename NOT IN ('_prisma_migrations', 'spatial_ref_sys')`,
  );
  if (rows.length === 0) return;
  const tables = rows.map((r) => `"public"."${r.tablename}"`).join(', ');
  await db.query(`TRUNCATE ${tables} RESTART IDENTITY CASCADE`);
}

async function emptyBucket(): Promise<void> {
  const s3 = new S3Client({
    endpoint: process.env.STORAGE_ENDPOINT,
    region: process.env.STORAGE_REGION,
    forcePathStyle: true,
    credentials: {
      accessKeyId: process.env.STORAGE_ACCESS_KEY ?? '',
      secretAccessKey: process.env.STORAGE_SECRET_KEY ?? '',
    },
  });
  const Bucket = process.env.STORAGE_BUCKET ?? '';
  let token: string | undefined;
  do {
    const page = await s3.send(new ListObjectsV2Command({ Bucket, ContinuationToken: token }));
    const keys = (page.Contents ?? []).flatMap((o) => (o.Key ? [{ Key: o.Key }] : []));
    if (keys.length > 0) {
      await s3.send(new DeleteObjectsCommand({ Bucket, Delete: { Objects: keys, Quiet: true } }));
    }
    token = page.IsTruncated ? page.NextContinuationToken : undefined;
  } while (token);
  s3.destroy();
}
