import { Inject, Injectable, Logger } from '@nestjs/common';
import type { Redis } from 'ioredis';
import { withTimeout } from '../common/with-timeout';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import type { HealthCheckDto, HealthResponseDto } from './dto/health-response.dto';

const CHECK_TIMEOUT_MS = 3_000;

@Injectable()
export class HealthService {
  private readonly logger = new Logger(HealthService.name);

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  async check(): Promise<HealthResponseDto> {
    const [database, postgis, redis] = await Promise.all([
      this.run('database', async () => {
        await this.prisma.$queryRaw`SELECT 1`;
        return { status: 'up' };
      }),
      this.run('postgis', async () => {
        const rows = await this.prisma.$queryRaw<
          { version: string }[]
        >`SELECT postgis_lib_version() AS version`;
        return { status: 'up', version: rows[0]?.version };
      }),
      this.run('redis', async () => {
        await this.redis.ping();
        return { status: 'up' };
      }),
    ]);

    const allUp = [database, postgis, redis].every((c) => c.status === 'up');
    return {
      status: allUp ? 'ok' : 'error',
      checks: { database, postgis, redis },
      timestamp: new Date().toISOString(),
    };
  }

  /** Ejecuta un chequeo con tiempo límite; el detalle del error solo va al log. */
  private async run(name: string, fn: () => Promise<HealthCheckDto>): Promise<HealthCheckDto> {
    try {
      return await withTimeout(fn(), CHECK_TIMEOUT_MS, name);
    } catch (error) {
      const reason = error instanceof Error ? error.message : 'error desconocido';
      this.logger.warn(`Chequeo ${name} falló: ${reason}`);
      return { status: 'down' };
    }
  }
}
