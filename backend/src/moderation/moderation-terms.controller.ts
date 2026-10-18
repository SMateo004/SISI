import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
} from '@nestjs/swagger';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import {
  CreateModerationTermDto,
  ModerationTermDto,
  ModerationTestResultDto,
  TestModerationDto,
  UpdateModerationTermDto,
} from './dto/moderation-terms.dto';
import { ModerationTermsService } from './moderation-terms.service';

@ApiTags('admin')
@Admin('moderacion')
@Controller('admin/moderation-terms')
export class ModerationTermsController {
  constructor(private readonly terms: ModerationTermsService) {}

  @Get()
  @ApiOperation({ summary: 'Términos del filtro de moderación' })
  @ApiQuery({ name: 'incluirInactivos', required: false, type: Boolean })
  @ApiOkResponse({ type: ModerationTermDto, isArray: true })
  list(@Query('incluirInactivos') all?: string): Promise<ModerationTermDto[]> {
    return this.terms.list(all === 'true');
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
  create(
    @AdminCtx() ctx: AdminContext,
    @Body() dto: CreateModerationTermDto,
  ): Promise<ModerationTermDto> {
    return this.terms.create(ctx, dto);
  }

  @Post('test')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Probador: qué términos vigentes coinciden con un texto',
    description:
      'Mismo filtro y presupuesto de tiempo que las solicitudes y el chat. No guarda nada.',
  })
  @ApiOkResponse({ type: ModerationTestResultDto })
  test(@Body() dto: TestModerationDto): Promise<ModerationTestResultDto> {
    return this.terms.test(dto.text);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Cambia la categoría, la nota o reactiva un término' })
  @ApiOkResponse({ type: ModerationTermDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'MODERATION_TERM_NOT_FOUND' })
  update(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateModerationTermDto,
  ): Promise<ModerationTermDto> {
    return this.terms.update(ctx, id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Desactiva un término (baja lógica)' })
  @ApiNoContentResponse()
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'MODERATION_TERM_NOT_FOUND' })
  remove(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<void> {
    return this.terms.deactivate(ctx, id);
  }
}
