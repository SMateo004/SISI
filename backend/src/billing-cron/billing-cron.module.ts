import { Module } from '@nestjs/common';
import { AppConfigModule } from '../config/config.module';
import { PrismaModule } from '../prisma/prisma.module';

/** Corte semanal y bloqueos por deuda (R7). Se implementa en la Fase 5. */
@Module({
  imports: [AppConfigModule, PrismaModule],
})
export class BillingCronModule {}
