import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { BillingCatchUpService } from './billing/billing-catchup.service';
import { BillingCronModule } from './billing-cron/billing-cron.module';
import { createLogger } from './observability/logger.factory';
import { checkIn, flushSentry, initSentry, reportError } from './observability/sentry';

/**
 * Monitor de cron de Sentry (ADR-0048): corre a los :05 de cada hora; si no hay check-in
 * 60 min después de la hora esperada (2 h sin correr) Sentry avisa por el canal de alertas.
 */
const MONITOR = { crontab: '5 * * * *', checkinMargin: 60, maxRuntime: 30 };

/**
 * Cron Job de Render (cada hora, ADR-0036): cierra los periodos cuyo fin ya pasó, vence los
 * impagos y programa los avisos. Idempotente: si una corrida falla, la siguiente se pone al día.
 */
async function run(): Promise<void> {
  initSentry('billing-cron');
  const checkInId = checkIn('billing-cron', 'in_progress', MONITOR);
  const app = await NestFactory.createApplicationContext(BillingCronModule, {
    logger: createLogger('billing-cron'),
  });
  try {
    const result = await app.get(BillingCatchUpService).run(new Date());
    Logger.log(`Cobros al día: ${JSON.stringify(result)}`, 'BillingCron');
    checkIn('billing-cron', 'ok', MONITOR, checkInId);
  } catch (error) {
    checkIn('billing-cron', 'error', MONITOR, checkInId);
    throw error;
  } finally {
    await app.close();
  }
}

run()
  .then(() => flushSentry())
  .catch(async (error: unknown) => {
    Logger.error(error, 'BillingCron');
    reportError(error, { job: 'billing-cron' });
    await flushSentry();
    process.exit(1);
  });
