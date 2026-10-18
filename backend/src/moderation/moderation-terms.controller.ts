import { Admin } from '../common/admin/admin-permissions';
import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  NotFoundException,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { IsBoolean, IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiError, ApiErrorBody } from '../common/errors/api-error';
import type { ModerationTerm } from '../generated/prisma/client';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { ModerationService } from './moderation.service';

const KINDS = ['word', 'regex'] as const;
const CATEGORIES = ['sexual', 'drogas', 'armas', 'ilegal', 'inmoral', 'venta_productos'] as const;

export class CreateModerationTermDto {
  @ApiProperty({ example: 'cocain*', description: 'Palabra/frase (con * de prefijo) o regex' })
  @IsString()
  @MaxLength(100, { message: 'El término admite hasta 100 caracteres.' })
  term!: string;

  @ApiProperty({ enum: KINDS, example: 'word' })
  @IsIn(KINDS, { message: 'kind debe ser word o regex.' })
  kind!: (typeof KINDS)[number];

  @ApiProperty({ enum: CATEGORIES, example: 'drogas' })
  @IsIn(CATEGORIES, { message: 'Categoría de prohibición no válida (R9.1).' })
  category!: (typeof CATEGORIES)[number];

  @ApiPropertyOptional({ example: 'Agregado por reporte del 15/10' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  note?: string;
}

export class UpdateModerationTermDto {
  @ApiPropertyOptional({ enum: CATEGORIES })
  @IsOptional()
  @IsIn(CATEGORIES, { message: 'Categoría de prohibición no válida (R9.1).' })
  category?: (typeof CATEGORIES)[number];

  @ApiPropertyOptional({ example: true })
  @IsOptional()
  @IsBoolean()
  active?: boolean;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(200)
  note?: string;
}

export class ModerationTermDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: 'cocain*' }) term!: string;
  @ApiProperty({ enum: KINDS }) kind!: string;
  @ApiProperty({ enum: CATEGORIES }) category!: string;
  @ApiProperty() active!: boolean;
  @ApiProperty({ nullable: true, type: String }) note!: string | null;
}

const toDto = (t: ModerationTerm): ModerationTermDto => ({
  id: t.id,
  term: t.term,
  kind: t.kind,
  category: t.category,
  active: t.active,
  note: t.note,
});

@ApiTags('admin')
@ApiBearerAuth()
@Admin('moderacion')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/moderation-terms')
export class ModerationTermsController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly moderation: ModerationService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Términos del filtro de moderación' })
  @ApiQuery({ name: 'incluirInactivos', required: false, type: Boolean })
  @ApiOkResponse({ type: ModerationTermDto, isArray: true })
  async list(@Query('incluirInactivos') all?: string): Promise<ModerationTermDto[]> {
    const terms = await this.prisma.moderationTerm.findMany({
      where: all === 'true' ? {} : { active: true },
      orderBy: [{ category: 'asc' }, { term: 'asc' }],
    });
    return terms.map(toDto);
  }

  @Post()
  @ApiOperation({
    summary: 'Agrega un término o patrón',
    description:
      'Los regex se validan: máx. 100 caracteres, sin referencias, lookaround ni cuantificadores anidados, y se prueban contra entradas lentas (ADR-0018).',
  })
  @ApiCreatedResponse({ type: ModerationTermDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'MODERATION_PATTERN_INVALID o MODERATION_TERM_INVALID',
  })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'MODERATION_TERM_EXISTS' })
  async create(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: CreateModerationTermDto,
  ): Promise<ModerationTermDto> {
    const term = this.moderation.validate(dto.term, dto.kind);
    try {
      const created = await this.prisma.moderationTerm.create({
        data: {
          term,
          kind: dto.kind,
          category: dto.category,
          note: dto.note,
          createdById: current.id,
        },
      });
      await this.moderation.invalidate();
      return toDto(created);
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        throw new ApiError(HttpStatus.CONFLICT, 'MODERATION_TERM_EXISTS', 'Ese término ya existe.');
      }
      throw error;
    }
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Cambia la categoría, la nota o reactiva un término' })
  @ApiOkResponse({ type: ModerationTermDto })
  async update(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateModerationTermDto,
  ): Promise<ModerationTermDto> {
    await this.require(id);
    const updated = await this.prisma.moderationTerm.update({ where: { id }, data: dto });
    await this.moderation.invalidate();
    return toDto(updated);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Desactiva un término (baja lógica)' })
  @ApiNoContentResponse()
  async remove(@Param('id', new ParseUUIDPipe()) id: string): Promise<void> {
    await this.require(id);
    await this.prisma.moderationTerm.update({ where: { id }, data: { active: false } });
    await this.moderation.invalidate();
  }

  private async require(id: string): Promise<void> {
    if (!(await this.prisma.moderationTerm.findUnique({ where: { id } }))) {
      throw new NotFoundException('El término no existe.');
    }
  }
}
