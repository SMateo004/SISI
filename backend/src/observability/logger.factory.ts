import { ConsoleLogger, type LoggerService } from '@nestjs/common';
import { releaseInfo, releaseName } from '../common/release/release';
import { JsonLogger } from './json-logger';
import type { SisiService } from './sentry';

/** JSON en staging y producción (Render), el formato de Nest en local y test (ADR-0048). */
export function createLogger(service: SisiService, env = process.env): LoggerService {
  const appEnv = env.APP_ENV ?? 'local';
  if (appEnv !== 'staging' && appEnv !== 'production') return new ConsoleLogger();
  return new JsonLogger({
    service,
    env: appEnv,
    release: releaseName(releaseInfo(env.RENDER_GIT_COMMIT)),
  });
}
