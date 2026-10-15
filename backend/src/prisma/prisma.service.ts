import { Inject, Injectable, type OnApplicationShutdown } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaPg } from '@prisma/adapter-pg';
import type { AppConfigService } from '../config/app-config';
import { PrismaClient } from '../generated/prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnApplicationShutdown {
  constructor(@Inject(ConfigService) config: AppConfigService) {
    super({
      adapter: new PrismaPg({ connectionString: config.get('DATABASE_URL', { infer: true }) }),
    });
  }

  /**
   * Se desconecta al final del apagado: el relay y los workers de BullMQ se detienen antes
   * (beforeApplicationShutdown). Si se desconectara en onModuleDestroy, un job en curso
   * volvería a abrir el pool y el proceso no terminaría.
   */
  async onApplicationShutdown(): Promise<void> {
    await this.$disconnect();
  }
}
