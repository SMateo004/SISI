import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
  ApiTooManyRequestsResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import { ConfirmUploadDto, PresignedUploadDto, UploadRequestDto } from '../storage/dto/upload.dto';
import {
  AdminRequestPageDto,
  CreatedRequestDto,
  CreateRequestDto,
  ListRequestsQuery,
  PublishResultDto,
  ModerationDecisionDto,
  RequestDto,
  RequestPageDto,
} from './dto/request.dto';
import { REQUEST_STATUSES, type RequestStatus } from './request-status.machine';
import { RequestsService } from './requests.service';

@ApiTags('requests')
@ApiBearerAuth()
@Controller('requests')
export class RequestsController {
  constructor(private readonly requests: RequestsService) {}

  @Post()
  @RateLimit('requestCreateIp')
  @ApiOperation({
    summary: 'Crea una solicitud en borrador',
    description:
      'Solo en modo empleador. Categoría activa en la ciudad, descripción de 20 a 1000 caracteres, ubicación dentro de la zona de servicio, dirección y precio > 0. Si el precio está bajo el mínimo de referencia, se crea igual y la respuesta trae una advertencia (R3.2).',
  })
  @ApiCreatedResponse({ type: CreatedRequestDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description:
      'VALIDATION_ERROR, DESCRIPTION_LENGTH, CATEGORY_NOT_AVAILABLE, LOCATION_OUTSIDE_CITY, LOCATION_INVALID, PRICE_INVALID',
  })
  @ApiForbiddenResponse({ type: ApiErrorBody, description: 'EMPLOYER_MODE_REQUIRED' })
  create(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: CreateRequestDto,
  ): Promise<CreatedRequestDto> {
    return this.requests.create(user.id, dto);
  }

  @Post(':id/photos/upload-url')
  @RateLimit('uploadUrlUser')
  @ApiOperation({ summary: 'URL prefirmada para subir una foto (máx. 4, solo en borrador)' })
  @ApiCreatedResponse({ type: PresignedUploadDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'TOO_MANY_PHOTOS, UPLOAD_TYPE_NOT_ALLOWED, UPLOAD_TOO_LARGE',
  })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_DRAFT' })
  photoUploadUrl(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UploadRequestDto,
  ): Promise<PresignedUploadDto> {
    return this.requests.photoUploadUrl(user.id, id, dto.contentType, dto.sizeBytes);
  }

  @Put(':id/photos')
  @ApiOperation({ summary: 'Confirma una foto subida (verifica el objeto con HEAD)' })
  @ApiOkResponse({ type: RequestDto })
  @ApiForbiddenResponse({ type: ApiErrorBody, description: 'UPLOAD_KEY_FORBIDDEN' })
  confirmPhoto(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: ConfirmUploadDto,
  ): Promise<RequestDto> {
    return this.requests.confirmPhoto(user.id, id, dto.key);
  }

  @Delete(':id/photos/:photoId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Quita una foto del borrador' })
  @ApiNoContentResponse()
  deletePhoto(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('photoId', new ParseUUIDPipe()) photoId: string,
  ): Promise<void> {
    return this.requests.deletePhoto(user.id, id, photoId);
  }

  @Post(':id/publish')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Publica la solicitud',
    description:
      'Pasa por moderación (R3.3). Si hay coincidencias queda "retenida" con un mensaje neutral; si no, pasa a "buscando" y empieza la búsqueda de trabajadores. Límite: 10 por hora y 30 por día por usuario.',
  })
  @ApiOkResponse({ type: PublishResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_DRAFT' })
  @ApiTooManyRequestsResponse({ type: ApiErrorBody, description: 'RATE_LIMITED' })
  publish(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<PublishResultDto> {
    return this.requests.publish(user.id, id);
  }

  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Cancela la solicitud (mientras no esté asignada)' })
  @ApiOkResponse({ type: RequestDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'REQUEST_TRANSITION_NOT_ALLOWED' })
  cancel(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<RequestDto> {
    return this.requests.cancel(user.id, id);
  }

  @Get('mine')
  @ApiOperation({ summary: 'Mis solicitudes (más recientes primero)' })
  @ApiOkResponse({ type: RequestPageDto })
  listMine(
    @CurrentUser() user: AuthenticatedUser,
    @Query() query: ListRequestsQuery,
  ): Promise<RequestPageDto> {
    return this.requests.listMine(user.id, query.cursor, query.limit);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Detalle de una solicitud propia' })
  @ApiOkResponse({ type: RequestDto })
  @ApiNotFoundResponse({
    type: ApiErrorBody,
    description: 'REQUEST_NOT_FOUND (también si es de otra persona)',
  })
  get(
    @CurrentUser() user: AuthenticatedUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<RequestDto> {
    return this.requests.getOwn(user.id, id);
  }
}

@ApiTags('admin')
@ApiBearerAuth()
@Admin('moderacion')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/requests')
export class AdminRequestsController {
  constructor(private readonly requests: RequestsService) {}

  @Get()
  @ApiOperation({ summary: 'Solicitudes por estado (por defecto, las retenidas por moderación)' })
  @ApiQuery({ name: 'status', enum: REQUEST_STATUSES, required: false })
  @ApiQuery({ name: 'cursor', required: false, description: 'nextCursor de la página anterior' })
  @ApiOkResponse({ type: AdminRequestPageDto })
  list(
    @Query('status') status?: string,
    @Query('cursor', new ParseUUIDPipe({ optional: true })) cursor?: string,
  ): Promise<AdminRequestPageDto> {
    const value = (REQUEST_STATUSES as readonly string[]).includes(status ?? '')
      ? (status as RequestStatus)
      : 'retenida';
    return this.requests.listByStatus(value, cursor);
  }

  @Post(':id/release')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Libera una solicitud retenida: pasa a "buscando"' })
  @ApiOkResponse({ type: RequestDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'REQUEST_TRANSITION_NOT_ALLOWED' })
  release(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: ModerationDecisionDto,
  ): Promise<RequestDto> {
    return this.requests.release(ctx, id, dto.reason);
  }

  @Post(':id/reject')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Rechaza una solicitud retenida',
    description: 'Queda "cancelada" con motivo de moderación (sin estados nuevos en R3.4).',
  })
  @ApiOkResponse({ type: RequestDto })
  reject(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: ModerationDecisionDto,
  ): Promise<RequestDto> {
    return this.requests.reject(ctx, id, dto.reason);
  }
}
