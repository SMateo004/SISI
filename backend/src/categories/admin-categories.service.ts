import { HttpStatus, Injectable, NotFoundException } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import { PrismaService } from '../prisma/prisma.service';
import type {
  AdminCategoryDto,
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

/** Administración mínima de categorías (la pantalla llega en la Fase 6). */
@Injectable()
export class AdminCategoriesService {
  constructor(private readonly prisma: PrismaService) {}

  async list(): Promise<AdminCategoryDto[]> {
    const categories = await this.prisma.category.findMany({
      include: { cities: { include: { city: { select: { slug: true } } } } },
      orderBy: { name: 'asc' },
    });
    return categories.map((c) => ({
      id: c.id,
      slug: c.slug,
      name: c.name,
      description: c.description,
      priceMinBs: toBs(c.priceMinBs),
      priceMaxBs: toBs(c.priceMaxBs),
      commissionPct: toBs(c.commissionPct),
      active: c.active,
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
    }));
  }

  async update(id: string, dto: UpdateCategoryDto): Promise<AdminCategoryDto> {
    const current = await this.prisma.category.findUnique({
      where: { id },
      include: { cities: true },
    });
    if (!current) throw new NotFoundException('La categoría no existe.');
    const min = dto.priceMinBs ? decimal(dto.priceMinBs) : current.priceMinBs;
    const max = dto.priceMaxBs ? decimal(dto.priceMaxBs) : current.priceMaxBs;
    if (min.greaterThan(max)) throw invalidRange();
    if (dto.commissionPct && decimal(dto.commissionPct).greaterThan(100)) throw invalidPct();
    // El nuevo rango base no puede dejar incoherente a una ciudad que hereda solo uno de los extremos.
    for (const cc of current.cities) {
      if ((cc.priceMinBs ?? min).greaterThan(cc.priceMaxBs ?? max)) throw invalidRange();
    }

    await this.prisma.category.update({
      where: { id },
      data: {
        name: dto.name,
        description: dto.description,
        priceMinBs: dto.priceMinBs,
        priceMaxBs: dto.priceMaxBs,
        commissionPct: dto.commissionPct,
        active: dto.active,
      },
    });
    return this.getOne(id);
  }

  async upsertCity(
    id: string,
    cityId: string,
    dto: UpsertCategoryCityDto,
  ): Promise<AdminCategoryDto> {
    const category = await this.prisma.category.findUnique({ where: { id } });
    if (!category) throw new NotFoundException('La categoría no existe.');
    const city = await this.prisma.city.findUnique({ where: { id: cityId } });
    if (!city) throw new NotFoundException('La ciudad no existe.');

    const min = dto.priceMinBs ? decimal(dto.priceMinBs) : category.priceMinBs;
    const max = dto.priceMaxBs ? decimal(dto.priceMaxBs) : category.priceMaxBs;
    if (min.greaterThan(max)) throw invalidRange();
    if (dto.commissionPct && decimal(dto.commissionPct).greaterThan(100)) throw invalidPct();

    const data = {
      active: dto.active,
      priceMinBs: dto.priceMinBs ?? null,
      priceMaxBs: dto.priceMaxBs ?? null,
      commissionPct: dto.commissionPct ?? null,
    };
    await this.prisma.categoryCity.upsert({
      where: { categoryId_cityId: { categoryId: id, cityId } },
      create: { categoryId: id, cityId, ...data },
      update: data,
    });
    return this.getOne(id);
  }

  private async getOne(id: string): Promise<AdminCategoryDto> {
    const found = (await this.list()).find((c) => c.id === id);
    if (!found) throw new NotFoundException('La categoría no existe.');
    return found;
  }
}
