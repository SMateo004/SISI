import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { setupApp, setupSwagger } from './app.setup';
import type { AppConfigService } from './config/app-config';
import { createLogger } from './observability/logger.factory';
import { initSentry } from './observability/sentry';

async function bootstrap(): Promise<void> {
  initSentry('api');
  const app = await NestFactory.create(AppModule, { logger: createLogger('api') });
  setupApp(app);
  const config = app.get<AppConfigService>(ConfigService);
  // Swagger no se publica en producción (ADR-0047); el contrato sale de packages/api_contract.
  const swagger = config.get('APP_ENV', { infer: true }) !== 'production';
  if (swagger) setupSwagger(app);

  const port = config.get('PORT', { infer: true });
  await app.listen(port, '0.0.0.0');
  Logger.log(
    `API escuchando en el puerto ${String(port)}${swagger ? ' (Swagger en /docs)' : ''}`,
    'Bootstrap',
  );
}

void bootstrap();
