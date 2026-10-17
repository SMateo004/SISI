import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { BillingCatchUpService } from './billing/billing-catchup.service';
import { BillingCronModule } from './billing-cron/billing-cron.module';

/**
 * Cron Job de Render (cada hora, ADR-0036): cierra los periodos cuyo fin ya pasó, vence los
 * impagos y programa los avisos. Idempotente: si una corrida falla, la siguiente se pone al día.
 */
async function run(): Promise<void> {
  const app = await NestFactory.createApplicationContext(BillingCronModule, {
    logger: ['error', 'warn', 'log'],
  });
  try {
    const result = await app.get(BillingCatchUpService).run(new Date());
    Logger.log(`Cobros al día: ${JSON.stringify(result)}`, 'BillingCron');
  } finally {
    await app.close();
  }
}

run().catch((error: unknown) => {
  Logger.error(error, 'BillingCron');
  process.exit(1);
});
