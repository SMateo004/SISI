import { Body, Controller, Get, Param, ParseUUIDPipe, Patch, Post, Put } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { UsersService } from '../users/users.service';
import { AdminCategoriesService } from './admin-categories.service';
import { CategoryResolver } from './category-resolver';
import {
  AdminCategoryDto,
  AdminCityDto,
  CategoryDto,
  CreateCategoryDto,
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
@Admin('catalogo')
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

  @Post()
  @ApiOperation({
    summary: 'Crea una categoría (R2.2)',
    description:
      'Con rango, comisión (13 % por defecto), requisitos extra y las ciudades donde queda activa.',
  })
  @ApiCreatedResponse({ type: AdminCategoryDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'CATEGORY_SLUG_TAKEN' })
  create(@AdminCtx() ctx: AdminContext, @Body() dto: CreateCategoryDto): Promise<AdminCategoryDto> {
    return this.admin.create(ctx, dto);
  }

  @Patch(':id')
  @ApiOperation({
    summary: 'Edita los valores base de una categoría',
    description:
      'Si cambia la comisión, `notice` avisa que solo afecta a los trabajos asignados desde ahora.',
  })
  @ApiOkResponse({ type: AdminCategoryDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'PRICE_RANGE_INVALID o VALIDATION_ERROR',
  })
  update(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCategoryDto,
  ): Promise<AdminCategoryDto> {
    return this.admin.update(ctx, id, dto);
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
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('cityId', new ParseUUIDPipe()) cityId: string,
    @Body() dto: UpsertCategoryCityDto,
  ): Promise<AdminCategoryDto> {
    return this.admin.upsertCity(ctx, id, cityId, dto);
  }
}

/** Ciudades (solo lectura en el MVP: se agregan por seed o migración). */
@ApiTags('admin')
@Admin('catalogo')
@Controller('admin/cities')
export class AdminCitiesController {
  constructor(private readonly admin: AdminCategoriesService) {}

  @Get()
  @ApiOperation({ summary: 'Ciudades' })
  @ApiOkResponse({ type: AdminCityDto, isArray: true })
  list(): Promise<AdminCityDto[]> {
    return this.admin.cities();
  }
}
