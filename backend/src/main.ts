import { Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { setupApp, setupSwagger } from './app.setup';
import type { AppConfigService } from './config/app-config';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule);
  setupApp(app);
  setupSwagger(app);

  const port = app.get<AppConfigService>(ConfigService).get('PORT', { infer: true });
  await app.listen(port, '0.0.0.0');
  Logger.log(`API escuchando en el puerto ${port} (Swagger en /docs)`, 'Bootstrap');
}

void bootstrap();
