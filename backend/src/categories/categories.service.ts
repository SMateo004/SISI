import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { Category } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';

/** Categorías: lista cerrada (R2.1). Lectura y validación; la administración llega en la Fase 2. */
@Injectable()
export class CategoriesService {
  constructor(private readonly prisma: PrismaService) {}

  listActive(): Promise<Category[]> {
    return this.prisma.category.findMany({ where: { active: true }, orderBy: { name: 'asc' } });
  }

  /** Todas deben existir y estar activas; si no, 400 sin revelar cuál. */
  async assertActive(ids: readonly string[]): Promise<void> {
    const unique = [...new Set(ids)];
    const found = await this.prisma.category.count({ where: { id: { in: unique }, active: true } });
    if (found !== unique.length) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'CATEGORY_NOT_AVAILABLE',
        'Alguna de las categorías elegidas ya no está disponible. Revisa tu selección.',
      );
    }
  }
}
