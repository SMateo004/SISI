import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { BillingCronModule } from './billing-cron/billing-cron.module';

/**
 * Punto de entrada del Cron Job de Render (domingo 23:59, hora de Bolivia).
 * Sin tareas todavía: arranca, registra la ejecución y termina con código 0.
 */
async function run(): Promise<void> {
  const app = await NestFactory.createApplicationContext(BillingCronModule);
  Logger.log('Ejecución de billing-cron: sin tareas todavía (Fase 5).', 'BillingCron');
  await app.close();
}

run().catch((error: unknown) => {
  Logger.error(error, 'BillingCron');
  process.exit(1);
});
