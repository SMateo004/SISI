import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { WorkerModule } from './worker/worker.module';

/**
 * Punto de entrada del Background Worker de Render: relay del outbox y colas BullMQ
 * (ADR-0022). Cierra limpio con SIGTERM (termina el lote y los jobs en curso).
 */
async function bootstrap(): Promise<void> {
  const app = await NestFactory.createApplicationContext(WorkerModule);
  app.enableShutdownHooks();
  Logger.log('Worker iniciado: relay del outbox y colas de BullMQ.', 'Worker');
}

void bootstrap();
