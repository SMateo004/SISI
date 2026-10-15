import type {} from './global-setup';

/** Libera el candado de la corrida e2e tomado en global-setup (ADR-0028). */
export default async function globalTeardown(): Promise<void> {
  const lock = globalThis.__e2eLock;
  if (!lock) return;
  await lock.query("SELECT pg_advisory_unlock(hashtext('sisi-e2e-run'))");
  await lock.end();
  globalThis.__e2eLock = undefined;
}
