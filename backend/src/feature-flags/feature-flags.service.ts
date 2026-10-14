import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import type { Redis } from 'ioredis';
import { ApiError } from '../common/errors/api-error';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';

export const FLAG_KEY_PATTERN = /^[a-z0-9._-]{2,64}$/;
const CACHE_TTL_SEC = 60;
const cacheKey = (key: string): string => `ff:${key}`;

/** Valores de una key: global y por ciudad. */
export interface FlagValues {
  global: boolean | null;
  cities: Record<string, boolean>;
}

/** Regla: la ciudad tiene prioridad; si no hay, el global; si no hay ninguno, apagado. */
export function resolveFlag(values: FlagValues, cityId?: string | null): boolean {
  if (cityId && cityId in values.cities) return values.cities[cityId] ?? false;
  return values.global ?? false;
}

export interface FeatureFlagRow {
  key: string;
  cityId: string | null;
  enabled: boolean;
  description: string | null;
  updatedAt: Date;
}

/**
 * Feature flags (R10.2, ADR-0017). Lecturas desde Redis (60 s) y la base como fuente;
 * cada cambio borra la caché de esa key, así que todas las instancias ven el valor
 * nuevo en la siguiente lectura.
 */
@Injectable()
export class FeatureFlagsService {
  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
  ) {}

  async isEnabled(key: string, cityId?: string | null): Promise<boolean> {
    return resolveFlag(await this.values(key), cityId);
  }

  list(): Promise<FeatureFlagRow[]> {
    return this.prisma.featureFlag.findMany({
      select: { key: true, cityId: true, enabled: true, description: true, updatedAt: true },
      orderBy: [{ key: 'asc' }, { cityId: 'asc' }],
    });
  }

  async set(
    key: string,
    input: { cityId: string | null; enabled: boolean; description?: string },
    actorId: string,
  ): Promise<FeatureFlagRow> {
    if (!FLAG_KEY_PATTERN.test(key)) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'FLAG_KEY_INVALID',
        'La key debe tener de 2 a 64 caracteres: minúsculas, números, punto, guion o guion bajo.',
      );
    }
    if (input.cityId) {
      const city = await this.prisma.city.findUnique({ where: { id: input.cityId } });
      if (!city) throw new ApiError(HttpStatus.NOT_FOUND, 'CITY_NOT_FOUND', 'La ciudad no existe.');
    }
    // Upsert con el índice único (key, city_id) NULLS NOT DISTINCT: Prisma no acepta null en claves compuestas.
    await this.prisma.$executeRaw`
      INSERT INTO feature_flags (key, city_id, enabled, description, updated_by, updated_at)
      VALUES (${key}, ${input.cityId}::uuid, ${input.enabled}, ${input.description ?? null}, ${actorId}::uuid, now())
      ON CONFLICT (key, city_id) DO UPDATE
      SET enabled = EXCLUDED.enabled,
          description = COALESCE(EXCLUDED.description, feature_flags.description),
          updated_by = EXCLUDED.updated_by,
          updated_at = now()`;
    await this.redis.del(cacheKey(key));
    return this.prisma.featureFlag.findFirstOrThrow({
      where: { key, cityId: input.cityId },
      select: { key: true, cityId: true, enabled: true, description: true, updatedAt: true },
    });
  }

  private async values(key: string): Promise<FlagValues> {
    const cached = await this.redis.get(cacheKey(key));
    if (cached) return JSON.parse(cached) as FlagValues;
    const rows = await this.prisma.featureFlag.findMany({
      where: { key },
      select: { cityId: true, enabled: true },
    });
    const values: FlagValues = { global: null, cities: {} };
    for (const row of rows) {
      if (row.cityId) values.cities[row.cityId] = row.enabled;
      else values.global = row.enabled;
    }
    await this.redis.set(cacheKey(key), JSON.stringify(values), 'EX', CACHE_TTL_SEC);
    return values;
  }
}
