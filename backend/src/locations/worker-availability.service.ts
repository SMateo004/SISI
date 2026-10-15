import { Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import type { AppConfigService } from '../config/app-config';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';

/** Claves de Redis de la ubicación en vivo (ADR-0024). */
export const liveKeys = {
  /** Redis GEO por ciudad: miembro = id del trabajador. */
  geo: (cityId: string): string => `geo:workers:${cityId}`,
  /** Último punto persistido en Postgres (para el throttling). */
  persisted: (workerId: string): string => `wloc:${workerId}`,
};

/**
 * Apaga la disponibilidad del trabajador (ADR-0024). Lo usan el interruptor de modo, la
 * máquina de estados del trabajador (bloqueo, suspensión) y el barrido de ubicaciones
 * vencidas. Postgres es la fuente de verdad; Redis GEO se limpia sin bloquear.
 */
@Injectable()
export class WorkerAvailabilityService {
  private readonly logger = new Logger('WorkerAvailability');
  private readonly staleMs: number;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.staleMs = config.get('WORKER_LOCATION_STALE_MS', { infer: true });
  }

  /** Dentro de la transacción de quien llama (cambio de modo o de estado). */
  async markUnavailable(tx: Prisma.TransactionClient, workerId: string): Promise<void> {
    const rows = await tx.workerLocation.findMany({
      where: { workerId, available: true },
      select: { cityId: true },
    });
    if (rows.length === 0) return;
    await tx.workerLocation.updateMany({
      where: { workerId },
      data: { available: false, availableSince: null },
    });
    for (const { cityId } of rows) this.dropLive(workerId, cityId);
  }

  /** Quita al trabajador de Redis GEO. Si fallara, no afecta: el matching usa Postgres. */
  dropLive(workerId: string, cityId: string): void {
    this.redis
      .multi()
      .zrem(liveKeys.geo(cityId), workerId)
      .del(liveKeys.persisted(workerId))
      .exec()
      .catch((err: unknown) => {
        this.logger.warn(`No se pudo limpiar la ubicación en vivo de ${workerId}: ${String(err)}`);
      });
  }

  /** Barrido periódico: sin ubicación en WORKER_LOCATION_STALE_MS, deja de estar disponible. */
  async sweepStale(): Promise<number> {
    const stale = await this.prisma.$queryRaw<{ worker_id: string; city_id: string }[]>`
      UPDATE worker_locations
      SET available = false, available_since = NULL, updated_at = now()
      WHERE available AND located_at < now() - make_interval(secs => ${this.staleMs / 1000})
      RETURNING worker_id, city_id`;
    for (const row of stale) this.dropLive(row.worker_id, row.city_id);
    if (stale.length > 0) this.logger.log(`${stale.length} trabajadores sin ubicación reciente`);
    return stale.length;
  }
}
