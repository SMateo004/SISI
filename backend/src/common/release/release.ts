import { readFileSync } from 'node:fs';
import { join } from 'node:path';

/**
 * Versión publicada (ADR-0046): la de backend/package.json (semver, igual al tag vX.Y.Z) y el
 * commit que desplegó Render. Se lee una vez; los servicios corren con cwd = backend/.
 */
export interface ReleaseInfo {
  version: string;
  sha: string | null;
}

let cached: ReleaseInfo | undefined;

export function releaseInfo(sha?: string): ReleaseInfo {
  if (!cached) {
    let version = '0.0.0';
    try {
      const pkg = JSON.parse(readFileSync(join(process.cwd(), 'package.json'), 'utf8')) as {
        version?: string;
      };
      version = pkg.version ?? version;
    } catch {
      // Sin package.json (no debería pasar): se informa 0.0.0.
    }
    cached = { version, sha: sha ?? null };
  }
  return cached;
}

/** Nombre de la release para Sentry: sisi-backend@0.9.0+abc1234. */
export function releaseName(info: ReleaseInfo): string {
  return `sisi-backend@${info.version}${info.sha ? `+${info.sha.slice(0, 7)}` : ''}`;
}
