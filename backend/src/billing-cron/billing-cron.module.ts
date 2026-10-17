import { Module } from '@nestjs/common';
import { BillingCoreModule } from '../billing/billing-core.module';
import { AppConfigModule } from '../config/config.module';
import { OutboxModule } from '../outbox/outbox.module';
import { PrismaModule } from '../prisma/prisma.module';
import { RedisModule } from '../redis/redis.module';

/**
 * Proceso billing-cron (ADR-0036): puesta al día de cobros cada hora. Solo escribe en
 * Postgres y en el outbox; los avisos y bloqueos los hace el worker.
 */
@Module({
  imports: [AppConfigModule, PrismaModule, RedisModule, OutboxModule, BillingCoreModule],
})
export class BillingCronModule {}
