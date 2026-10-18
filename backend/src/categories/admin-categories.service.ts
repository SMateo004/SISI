import { HttpStatus, Injectable } from '@nestjs/common';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { ApiError } from '../common/errors/api-error';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type {
  AdminCategoryDto,
  AdminCityDto,
  CreateCategoryDto,
  UpdateCategoryDto,
  UpsertCategoryCityDto,
} from './dto/category.dto';
import { decimal, effectiveCategory, toBs } from './effective-category';

const invalidRange = (): ApiError =>
  new ApiError(
    HttpStatus.BAD_REQUEST,
    'PRICE_RANGE_INVALID',
    'El precio mínimo no puede ser mayor que el máximo.',
  );

const invalidPct = (): ApiError =>
  new ApiError(
    HttpStatus.BAD_REQUEST,
    'COMMISSION_INVALID',
    'La comisión debe estar entre 0 y 100 %.',
  );

const notFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'CATEGORY_NOT_FOUND', 'La categoría no existe.');

/** La comisión se copia al asignar el trabajo (CategoryResolver, ADR-0016 y ADR-0030). */
export const COMMISSION_NOTICE =
  'La nueva comisión solo se aplica a los trabajos asignados desde ahora. Los trabajos ya asignados conservan la comisión que tenían.';

const include = {
  cities: { include: { city: { select: { slug: true } } } },
} satisfies Prisma.CategoryInclude;
type CategoryRow = Prisma.CategoryGetPayload<{ include: typeof include }>;

const requirements = (value: unknown): string[] => (Array.isArray(value) ? value.map(String) : []);

/** Lo que se guarda en la auditoría: valores base y por ciudad. */
const snapshot = (c: CategoryRow) => ({
  name: c.name,
  description: c.description,
  priceMinBs: c.priceMinBs,
  priceMaxBs: c.priceMaxBs,
  commissionPct: c.commissionPct,
  active: c.active,
  extraRequirements: requirements(c.extraRequirements),
  cities: c.cities.map((cc) => ({
    cityId: cc.cityId,
    active: cc.active,
    priceMinBs: cc.priceMinBs,
    priceMaxBs: cc.priceMaxBs,
    commissionPct: cc.commissionPct,
  })),
});

/** Catálogo en el panel (R2.2, R10.1): cada cambio queda auditado con antes y después. */
@Injectable()
export class AdminCategoriesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AdminAuditService,
  ) {}

  async list(): Promise<AdminCategoryDto[]> {
    const categories = await this.prisma.category.findMany({ include, orderBy: { name: 'asc' } });
    return categories.map((c) => toDto(c, null));
  }

  cities(): Promise<AdminCityDto[]> {
    return this.prisma.city.findMany({
      select: { id: true, slug: true, name: true, timezone: true, active: true },
      orderBy: { name: 'asc' },
    });
  }

  async create(ctx: AdminContext, dto: CreateCategoryDto): Promise<AdminCategoryDto> {
    if (decimal(dto.priceMinBs).greaterThan(decimal(dto.priceMaxBs))) throw invalidRange();
    if (dto.commissionPct && decimal(dto.commissionPct).greaterThan(100)) throw invalidPct();
    const cityIds = [...new Set(dto.cityIds ?? [])];
    if (cityIds.length > 0) {
      const found = await this.prisma.city.count({ where: { id: { in: cityIds } } });
      if (found !== cityIds.length) {
        throw new ApiError(HttpStatus.NOT_FOUND, 'CITY_NOT_FOUND', 'Una ciudad no existe.');
      }
    }
    if (await this.prisma.category.findUnique({ where: { slug: dto.slug } })) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'CATEGORY_SLUG_TAKEN',
        'Ya hay una categoría con ese slug.',
      );
    }
    const created = await this.prisma.$transaction(async (tx) => {
      const row = await tx.category.create({
        data: {
          slug: dto.slug,
          name: dto.name.trim(),
          description: dto.description ?? null,
          priceMinBs: dto.priceMinBs,
          priceMaxBs: dto.priceMaxBs,
          ...(dto.commissionPct ? { commissionPct: dto.commissionPct } : {}),
          extraRequirements: dto.extraRequirements ?? [],
          cities: { create: cityIds.map((cityId) => ({ cityId })) },
        },
        include,
      });
      await this.audit.record(tx, ctx, {
        action: 'catalog.category_create',
        targetType: 'category',
        targetId: row.id,
        after: snapshot(row),
      });
      return row;
    });
    return toDto(created, null);
  }

  async update(ctx: AdminContext, id: string, dto: UpdateCategoryDto): Promise<AdminCategoryDto> {
    const updated = await this.prisma.$transaction(async (tx) => {
      const current = await tx.category.findUnique({ where: { id }, include });
      if (!current) throw notFound();
      const min = dto.priceMinBs ? decimal(dto.priceMinBs) : current.priceMinBs;
      const max = dto.priceMaxBs ? decimal(dto.priceMaxBs) : current.priceMaxBs;
      if (min.greaterThan(max)) throw invalidRange();
      if (dto.commissionPct && decimal(dto.commissionPct).greaterThan(100)) throw invalidPct();
      // El nuevo rango base no puede dejar incoherente a una ciudad que hereda solo uno de los extremos.
      for (const cc of current.cities) {
        if ((cc.priceMinBs ?? min).greaterThan(cc.priceMaxBs ?? max)) throw invalidRange();
      }
      const row = await tx.category.update({
        where: { id },
        data: {
          name: dto.name,
          description: dto.description,
          priceMinBs: dto.priceMinBs,
          priceMaxBs: dto.priceMaxBs,
          commissionPct: dto.commissionPct,
          active: dto.active,
          extraRequirements: dto.extraRequirements,
        },
        include,
      });
      await this.audit.record(tx, ctx, {
        action: 'catalog.category_update',
        targetType: 'category',
        targetId: id,
        before: snapshot(current),
        after: snapshot(row),
      });
      return { row, commissionChanged: !current.commissionPct.equals(row.commissionPct) };
    });
    return toDto(updated.row, updated.commissionChanged ? COMMISSION_NOTICE : null);
  }

  async upsertCity(
    ctx: AdminContext,
    id: string,
    cityId: string,
    dto: UpsertCategoryCityDto,
  ): Promise<AdminCategoryDto> {
    const city = await this.prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw new ApiError(HttpStatus.NOT_FOUND, 'CITY_NOT_FOUND', 'La ciudad no existe.');
    const result = await this.prisma.$transaction(async (tx) => {
      const current = await tx.category.findUnique({ where: { id }, include });
      if (!current) throw notFound();
      const min = dto.priceMinBs ? decimal(dto.priceMinBs) : current.priceMinBs;
      const max = dto.priceMaxBs ? decimal(dto.priceMaxBs) : current.priceMaxBs;
      if (min.greaterThan(max)) throw invalidRange();
      if (dto.commissionPct && decimal(dto.commissionPct).greaterThan(100)) throw invalidPct();
      const before = current.cities.find((cc) => cc.cityId === cityId);
      const data = {
        active: dto.active,
        priceMinBs: dto.priceMinBs ?? null,
        priceMaxBs: dto.priceMaxBs ?? null,
        commissionPct: dto.commissionPct ?? null,
      };
      await tx.categoryCity.upsert({
        where: { categoryId_cityId: { categoryId: id, cityId } },
        create: { categoryId: id, cityId, ...data },
        update: data,
      });
      const row = await tx.category.findUniqueOrThrow({ where: { id }, include });
      const after = row.cities.find((cc) => cc.cityId === cityId);
      await this.audit.record(tx, ctx, {
        action: 'catalog.category_city',
        targetType: 'category',
        targetId: id,
        before: before ?? null,
        after: after ?? null,
        cityId,
      });
      const pct = (cc: typeof before) => (cc?.commissionPct ?? current.commissionPct).toFixed(2);
      return { row, commissionChanged: pct(before) !== pct(after) };
    });
    return toDto(result.row, result.commissionChanged ? COMMISSION_NOTICE : null);
  }
}

function toDto(c: CategoryRow, notice: string | null): AdminCategoryDto {
  return {
    id: c.id,
    slug: c.slug,
    name: c.name,
    description: c.description,
    priceMinBs: toBs(c.priceMinBs),
    priceMaxBs: toBs(c.priceMaxBs),
    commissionPct: toBs(c.commissionPct),
    active: c.active,
    extraRequirements: requirements(c.extraRequirements),
    cities: c.cities.map((cc) => {
      const effective = effectiveCategory(c, cc.cityId, cc);
      return {
        cityId: cc.cityId,
        citySlug: cc.city.slug,
        active: cc.active,
        priceMinBs: cc.priceMinBs ? toBs(cc.priceMinBs) : null,
        priceMaxBs: cc.priceMaxBs ? toBs(cc.priceMaxBs) : null,
        commissionPct: cc.commissionPct ? toBs(cc.commissionPct) : null,
        effectivePriceMinBs: toBs(effective.priceMinBs),
        effectivePriceMaxBs: toBs(effective.priceMaxBs),
        effectiveCommissionPct: toBs(effective.commissionPct),
      };
    }),
    notice,
  };
}
