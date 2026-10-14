import { Body, Controller, Get, Param, ParseUUIDPipe, Patch, Put } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser, Roles } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { UsersService } from '../users/users.service';
import { AdminCategoriesService } from './admin-categories.service';
import { CategoryResolver } from './category-resolver';
import {
  AdminCategoryDto,
  CategoryDto,
  toCategoryDto,
  UpdateCategoryDto,
  UpsertCategoryCityDto,
} from './dto/category.dto';

@ApiTags('categories')
@ApiBearerAuth()
@Controller('categories')
export class CategoriesController {
  constructor(
    private readonly resolver: CategoryResolver,
    private readonly users: UsersService,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Categorías activas en mi ciudad',
    description:
      'Lista cerrada (R2.1) con el rango de referencia efectivo de la ciudad (R2.2, R10.1).',
  })
  @ApiOkResponse({ type: CategoryDto, isArray: true })
  async list(@CurrentUser() current: AuthenticatedUser): Promise<CategoryDto[]> {
    const user = await this.users.getById(current.id);
    return (await this.resolver.listActive(user.cityId)).map(toCategoryDto);
  }
}

@ApiTags('admin')
@ApiBearerAuth()
@Roles('admin')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/categories')
export class AdminCategoriesController {
  constructor(private readonly admin: AdminCategoriesService) {}

  @Get()
  @ApiOperation({ summary: 'Todas las categorías con sus valores por ciudad' })
  @ApiOkResponse({ type: AdminCategoryDto, isArray: true })
  list(): Promise<AdminCategoryDto[]> {
    return this.admin.list();
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Edita los valores base de una categoría' })
  @ApiOkResponse({ type: AdminCategoryDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'PRICE_RANGE_INVALID o VALIDATION_ERROR',
  })
  update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCategoryDto,
  ): Promise<AdminCategoryDto> {
    return this.admin.update(id, dto);
  }

  @Put(':id/cities/:cityId')
  @ApiOperation({
    summary: 'Activa o ajusta una categoría en una ciudad',
    description: 'Los valores null heredan los de la categoría base.',
  })
  @ApiOkResponse({ type: AdminCategoryDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'PRICE_RANGE_INVALID o VALIDATION_ERROR',
  })
  upsertCity(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('cityId', new ParseUUIDPipe()) cityId: string,
    @Body() dto: UpsertCategoryCityDto,
  ): Promise<AdminCategoryDto> {
    return this.admin.upsertCity(id, cityId, dto);
  }
}
