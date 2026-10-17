import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { REDIS_CLIENT } from '../redis/redis.constants';
import type { LatLng } from '../requests/location';
import { jobNotFound } from './job-status.service';

/** Claves de Redis del seguimiento en vivo (ADR-0029). */
export const trackingKeys = {
  /** Último punto del trabajador en camino (hash lat, lng, at). */
  point: (jobId: string): string => `job:loc:${jobId}`,
  /** Marca de throttling de job:location. */
  throttle: (jobId: string): string => `job:loc:emit:${jobId}`,
};

export interface TrackedPoint {
  latitude: number;
  longitude: number;
  at: string;
}

/**
 * Ubicación del trabajador mientras va en camino (ADR-0029). Es telemetría efímera, no un
 * evento de dominio: vive en Redis y se emite directo (sin outbox), solo al empleador de
 * ese trabajo y como máximo cada JOB_LOCATION_EMIT_MS. En curso o cancelado deja de
 * emitirse, porque cada envío vuelve a mirar el estado del trabajo en Postgres.
 */
@Injectable()
export class JobTrackingService {
  private readonly emitMs: number;
  private readonly ttlMs: number;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly realtime: RealtimeEmitter,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.emitMs = config.get('JOB_LOCATION_EMIT_MS', { infer: true });
    this.ttlMs = config.get('WORKER_LOCATION_STALE_MS', { infer: true });
  }

  /** Si el trabajador va en camino, guarda el punto y avisa al empleador. Devuelve si lo hizo. */
  async relay(workerId: string, point: LatLng): Promise<boolean> {
    const job = await this.prisma.job.findFirst({
      where: { workerId, status: 'en_camino' },
      select: { id: true, employerId: true },
    });
    if (!job) return false;
    const at = new Date().toISOString();
    await this.redis
      .multi()
      .hset(trackingKeys.point(job.id), { lat: point.lat, lng: point.lng, at })
      .pexpire(trackingKeys.point(job.id), this.ttlMs)
      .exec();
    const first = await this.redis.set(trackingKeys.throttle(job.id), '1', 'PX', this.emitMs, 'NX');
    if (first === 'OK') {
      this.realtime.toUser(job.employerId, 'job:location', {
        jobId: job.id,
        latitude: point.lat,
        longitude: point.lng,
        at,
      });
    }
    return true;
  }

  /** Para resincronizar el mapa del empleador. Solo el empleador y solo en camino. */
  async current(userId: string, jobId: string): Promise<TrackedPoint | null> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      select: { employerId: true, workerId: true, status: true },
    });
    if (!job || (job.employerId !== userId && job.workerId !== userId)) throw jobNotFound();
    if (job.employerId !== userId || job.status !== 'en_camino') {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'JOB_LOCATION_UNAVAILABLE',
        'La ubicación del trabajador solo se ve mientras va en camino.',
      );
    }
    const h = await this.redis.hgetall(trackingKeys.point(jobId));
    if (!h.lat || !h.lng || !h.at) return null;
    return { latitude: Number(h.lat), longitude: Number(h.lng), at: h.at };
  }
}
