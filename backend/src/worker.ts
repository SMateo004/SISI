import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { WorkerModule } from './worker/worker.module';

/**
 * Punto de entrada del Background Worker de Render.
 * Sin colas todavía: arranca, mantiene la conexión a Redis y cierra limpio con SIGTERM.
 */
async function bootstrap(): Promise<void> {
  const app = await NestFactory.createApplicationContext(WorkerModule);
  app.enableShutdownHooks();
  Logger.log('Worker iniciado (sin colas registradas todavía).', 'Worker');
}

void bootstrap();
