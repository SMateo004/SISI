import { Controller, Get } from '@nestjs/common';
import { ApiBearerAuth, ApiOkResponse, ApiOperation, ApiProperty, ApiTags } from '@nestjs/swagger';
import { CategoriesService } from './categories.service';

export class CategoryDto {
  @ApiProperty({ example: 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e' })
  id!: string;

  @ApiProperty({ example: 'Plomería' })
  name!: string;

  @ApiProperty({ example: 'Fugas, destapes, grifería', nullable: true, type: String })
  description!: string | null;

  @ApiProperty({ example: '80.00', description: 'Precio mínimo de referencia en Bs' })
  priceMinBs!: string;

  @ApiProperty({ example: '250.00', description: 'Precio máximo de referencia en Bs' })
  priceMaxBs!: string;
}

@ApiTags('categories')
@ApiBearerAuth()
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categories: CategoriesService) {}

  @Get()
  @ApiOperation({
    summary: 'Categorías activas',
    description:
      'Lista cerrada (R2.1). En la Fase 1 puede venir vacía: el seed llega en la Fase 2.',
  })
  @ApiOkResponse({ type: CategoryDto, isArray: true })
  async list(): Promise<CategoryDto[]> {
    const categories = await this.categories.listActive();
    return categories.map((c) => ({
      id: c.id,
      name: c.name,
      description: c.description,
      priceMinBs: c.priceMinBs.toFixed(2),
      priceMaxBs: c.priceMaxBs.toFixed(2),
    }));
  }
}
