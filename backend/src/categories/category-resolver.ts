import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import { PrismaService } from '../prisma/prisma.service';
import { effectiveCategory, type EffectiveCategory } from './effective-category';

const notAvailable = (): ApiError =>
  new ApiError(
    HttpStatus.BAD_REQUEST,
    'CATEGORY_NOT_AVAILABLE',
    'Alguna de las categorías elegidas no está disponible en tu ciudad. Revisa tu selección.',
  );

/**
 * Única fuente de la categoría efectiva por ciudad (ADR-0016). Toda lógica que use
 * precio o comisión de una categoría debe pasar por aquí.
 */
@Injectable()
export class CategoryResolver {
  constructor(private readonly prisma: PrismaService) {}

  /** Categoría efectiva en la ciudad, o null si la categoría no existe. */
  async forCity(categoryId: string, cityId: string): Promise<EffectiveCategory | null> {
    const category = await this.prisma.category.findUnique({
      where: { id: categoryId },
      include: { cities: { where: { cityId } } },
    });
    if (!category) return null;
    return effectiveCategory(category, cityId, category.cities[0] ?? null);
  }

  /** Activas en la ciudad, ordenadas por nombre. */
  async listActive(cityId: string): Promise<EffectiveCategory[]> {
    const categories = await this.prisma.category.findMany({
      where: { active: true, cities: { some: { cityId, active: true } } },
      include: { cities: { where: { cityId } } },
      orderBy: { name: 'asc' },
    });
    return categories.map((c) => effectiveCategory(c, cityId, c.cities[0] ?? null));
  }

  /** La categoría debe existir y estar activa en la ciudad; si no, 400. */
  async requireActive(categoryId: string, cityId: string): Promise<EffectiveCategory> {
    const category = await this.forCity(categoryId, cityId);
    if (!category?.active) throw notAvailable();
    return category;
  }

  /** Todas deben estar activas en la ciudad; si no, 400 sin revelar cuál. */
  async requireAllActive(categoryIds: readonly string[], cityId: string): Promise<void> {
    const unique = [...new Set(categoryIds)];
    const found = await this.prisma.category.count({
      where: { id: { in: unique }, active: true, cities: { some: { cityId, active: true } } },
    });
    if (found !== unique.length) throw notAvailable();
  }
}
