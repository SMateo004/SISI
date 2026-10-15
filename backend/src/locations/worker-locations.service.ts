import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import { ApiError } from '../common/errors/api-error';
import { RateLimitStore } from '../common/rate-limit/rate-limit.store';
import { RateLimitedException } from '../common/rate-limit/rate-limited.exception';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { assertValidCoordinates, type LatLng } from '../requests/location';
import type {
  AvailabilityDto,
  LocationUpdateDto,
  LocationUpdateResultDto,
  SetAvailabilityDto,
} from './dto/location.dto';
import { canBeAvailable, type PersistedPoint, shouldPersist } from './location.rules';
import { liveKeys, WorkerAvailabilityService } from './worker-availability.service';

/**
 * Disponibilidad y ubicación en vivo del trabajador (ADR-0024). MVP: solo en primer plano,
 * mientras la app está abierta y el trabajador está disponible.
 */
@Injectable()
export class WorkerLocationsService {
  private readonly persistMs: number;
  private readonly persistM: number;
  private readonly staleMs: number;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly availability: WorkerAvailabilityService,
    private readonly rateLimits: RateLimitStore,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {
    this.persistMs = config.get('WORKER_LOCATION_PERSIST_MS', { infer: true });
    this.persistM = config.get('WORKER_LOCATION_PERSIST_M', { infer: true });
    this.staleMs = config.get('WORKER_LOCATION_STALE_MS', { infer: true });
  }

  async get(userId: string): Promise<AvailabilityDto> {
    const row = await this.prisma.workerLocation.findUnique({ where: { workerId: userId } });
    return this.toDto(row);
  }

  async setAvailability(userId: string, dto: SetAvailabilityDto): Promise<AvailabilityDto> {
    if (!dto.available) {
      await this.prisma.$transaction((tx) => this.availability.markUnavailable(tx, userId));
      return this.get(userId);
    }

    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { activeMode: true, cityId: true, workerProfile: { select: { status: true } } },
    });
    const decision = canBeAvailable({
      activeMode: user.activeMode,
      status: user.workerProfile?.status ?? null,
    });
    if (!decision.allowed) {
      const { allowed: _allowed, code, message, ...extra } = decision;
      throw new ApiError(HttpStatus.CONFLICT, code, message, extra);
    }
    if (dto.latitude === undefined || dto.longitude === undefined) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'LOCATION_REQUIRED',
        'Necesitamos tu ubicación para mostrarte solicitudes cercanas.',
      );
    }
    const point = { lat: dto.latitude, lng: dto.longitude };
    assertValidCoordinates(point);

    // Si ya estaba disponible, conserva desde cuándo.
    await this.prisma.$executeRaw`
      INSERT INTO worker_locations
        (worker_id, city_id, geog, available, available_since, located_at, updated_at)
      VALUES (${userId}::uuid, ${user.cityId}::uuid,
              ST_SetSRID(ST_MakePoint(${point.lng}, ${point.lat}), 4326)::geography,
              true, now(), now(), now())
      ON CONFLICT (worker_id) DO UPDATE SET
        city_id = EXCLUDED.city_id,
        geog = EXCLUDED.geog,
        available = true,
        available_since = CASE WHEN worker_locations.available
                               THEN worker_locations.available_since ELSE now() END,
        located_at = now(),
        updated_at = now()`;
    await this.saveLive(userId, user.cityId, point, Date.now());
    return this.get(userId);
  }

  async updateLocation(userId: string, dto: LocationUpdateDto): Promise<LocationUpdateResultDto> {
    const decision = await this.rateLimits.consume([
      {
        key: `worker:location:user:${userId}`,
        limit: this.config.get('RATE_WORKER_LOCATION_PER_MIN', { infer: true }),
        windowSec: 60,
      },
    ]);
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);

    const point = { lat: dto.latitude, lng: dto.longitude };
    assertValidCoordinates(point);
    const row = await this.prisma.workerLocation.findUnique({
      where: { workerId: userId },
      select: { available: true, cityId: true },
    });
    if (!row?.available) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'NOT_AVAILABLE',
        'Activa "Disponible" para compartir tu ubicación.',
      );
    }

    const now = Date.now();
    const last = await this.lastPersisted(userId);
    const persist = shouldPersist(last, point, now, {
      persistMs: this.persistMs,
      persistM: this.persistM,
    });
    if (persist) {
      // Solo si sigue disponible: un bloqueo concurrente gana.
      const updated = await this.prisma.$executeRaw`
        UPDATE worker_locations
        SET geog = ST_SetSRID(ST_MakePoint(${point.lng}, ${point.lat}), 4326)::geography,
            located_at = now(), updated_at = now()
        WHERE worker_id = ${userId}::uuid AND available`;
      if (updated === 0) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'NOT_AVAILABLE',
          'Activa "Disponible" para compartir tu ubicación.',
        );
      }
    }
    await this.saveLive(userId, row.cityId, point, persist ? now : undefined);
    return { persisted: persist };
  }

  /** Copia en vivo en Redis GEO; con `persistedAt`, recuerda el punto guardado en Postgres. */
  private async saveLive(
    workerId: string,
    cityId: string,
    point: LatLng,
    persistedAt?: number,
  ): Promise<void> {
    const multi = this.redis.multi().geoadd(liveKeys.geo(cityId), point.lng, point.lat, workerId);
    if (persistedAt !== undefined) {
      multi
        .hset(liveKeys.persisted(workerId), {
          lat: point.lat,
          lng: point.lng,
          at: persistedAt,
        })
        .pexpire(liveKeys.persisted(workerId), this.staleMs);
    }
    await multi.exec();
  }

  private async lastPersisted(workerId: string): Promise<PersistedPoint | null> {
    const h = await this.redis.hgetall(liveKeys.persisted(workerId));
    if (!h.lat || !h.lng || !h.at) return null;
    return { lat: Number(h.lat), lng: Number(h.lng), at: Number(h.at) };
  }

  private toDto(
    row: { available: boolean; availableSince: Date | null; locatedAt: Date | null } | null,
  ): AvailabilityDto {
    return {
      available: row?.available ?? false,
      availableSince: row?.availableSince?.toISOString() ?? null,
      locatedAt: row?.locatedAt?.toISOString() ?? null,
      sendEverySec: Math.max(Math.round(this.persistMs / 1000), 1),
      staleAfterSec: Math.round(this.staleMs / 1000),
    };
  }
}
