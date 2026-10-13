import { type INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, type OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import type { AppConfigService } from './config/app-config';

/** Configuración HTTP común a main.ts y a los tests e2e. */
export function setupApp(app: INestApplication): void {
  const config = app.get<AppConfigService>(ConfigService);
  const origins = config.get('CORS_ORIGINS', { infer: true });

  // Solo dominios web conocidos (Vercel y localhost). Las apps nativas no envían Origin.
  app.enableCors({ origin: origins.length > 0 ? origins : false, credentials: true });
  app.useGlobalPipes(
    new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }),
  );
  app.enableShutdownHooks();
}

export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const doc = new DocumentBuilder()
    .setTitle('SISI API')
    .setDescription('API de SISI: servicios inmediatos (Bolivia).')
    .setVersion('0.1.0')
    .build();
  return SwaggerModule.createDocument(app, doc);
}

export function setupSwagger(app: INestApplication): void {
  SwaggerModule.setup('docs', app, buildOpenApiDocument(app), { jsonDocumentUrl: 'docs-json' });
}
