import { Module } from '@nestjs/common';
import { AppConfigModule } from '../config/config.module';
import { PrismaModule } from '../prisma/prisma.module';
import { RedisModule } from '../redis/redis.module';

/** Procesos en segundo plano (BullMQ). Las colas se registran a partir de la Fase 3. */
@Module({
  imports: [AppConfigModule, PrismaModule, RedisModule],
})
export class WorkerModule {}
