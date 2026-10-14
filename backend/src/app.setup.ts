import {
  BadRequestException,
  type INestApplication,
  type ValidationError,
  ValidationPipe,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { DocumentBuilder, type OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import type { AppConfigService } from './config/app-config';

/** Primer mensaje de validación (en español, definido en cada DTO). */
function firstMessage(errors: ValidationError[]): string {
  for (const error of errors) {
    const message = Object.values(error.constraints ?? {})[0];
    if (message) return message;
    const nested = firstMessage(error.children ?? []);
    if (nested) return nested;
  }
  return 'Los datos enviados no son válidos.';
}

/** Configuración HTTP común a main.ts y a los tests e2e. */
export function setupApp(app: INestApplication): void {
  const config = app.get<AppConfigService>(ConfigService);
  const origins = config.get('CORS_ORIGINS', { infer: true });

  // Render (y cualquier proxy delante) envía la IP real en X-Forwarded-For: necesaria para los límites por IP.
  (app as NestExpressApplication).set('trust proxy', 1);
  // Solo dominios web conocidos (Vercel y localhost). Las apps nativas no envían Origin.
  app.enableCors({ origin: origins.length > 0 ? origins : false, credentials: true });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
      exceptionFactory: (errors) =>
        new BadRequestException({
          statusCode: 400,
          code: 'VALIDATION_ERROR',
          message: firstMessage(errors),
        }),
    }),
  );
  app.enableShutdownHooks();
}

export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const doc = new DocumentBuilder()
    .setTitle('SISI API')
    .setDescription(
      'API de SISI: servicios inmediatos (Bolivia). Los errores tienen la forma {statusCode, code, message} con mensajes en español.',
    )
    .setVersion('0.2.0')
    .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' })
    .build();
  return SwaggerModule.createDocument(app, doc);
}

export function setupSwagger(app: INestApplication): void {
  SwaggerModule.setup('docs', app, buildOpenApiDocument(app), {
    jsonDocumentUrl: 'docs-json',
    swaggerOptions: { persistAuthorization: true },
  });
}
