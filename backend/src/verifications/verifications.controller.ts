import {
  Body,
  Controller,
  Get,
  Header,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiConflictResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { DocumentUrlDto } from '../workers/dto/worker.dto';
import {
  ApproveVerificationDto,
  RejectVerificationDto,
  VerificationDetailDto,
  VerificationPageDto,
  VerificationQueueQueryDto,
  VerificationResultDto,
} from './dto/verifications.dto';
import { VerificationsService } from './verifications.service';

@ApiTags('admin')
@Admin('verificaciones')
@ApiNotFoundResponse({ type: ApiErrorBody, description: 'VERIFICATION_NOT_FOUND' })
@Controller('admin')
export class VerificationsController {
  constructor(private readonly verifications: VerificationsService) {}

  @Get('verifications')
  @ApiOperation({
    summary: 'Cola de verificaciones (pendiente_revision)',
    description: 'De la más antigua a la más nueva, 25 por página.',
  })
  @ApiOkResponse({ type: VerificationPageDto })
  queue(@Query() query: VerificationQueueQueryDto): Promise<VerificationPageDto> {
    return this.verifications.queue(query.cursor);
  }

  @Get('verifications/:userId')
  @Header('Cache-Control', 'no-store')
  @ApiOperation({
    summary: 'Detalle de una solicitud de trabajador',
    description:
      'Datos, edad, categorías con sus requisitos extra y documentos por URL temporal de 5 minutos (R9.5). Queda auditado.',
  })
  @ApiOkResponse({ type: VerificationDetailDto })
  detail(
    @AdminCtx() ctx: AdminContext,
    @Param('userId', ParseUUIDPipe) userId: string,
  ): Promise<VerificationDetailDto> {
    return this.verifications.detail(ctx, userId);
  }

  @Post('verifications/:userId/approve')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Aprobar: el perfil pasa a aprobado y se le avisa (push)' })
  @ApiOkResponse({ type: VerificationResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_TRANSITION_NOT_ALLOWED' })
  approve(
    @AdminCtx() ctx: AdminContext,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Body() dto: ApproveVerificationDto,
  ): Promise<VerificationResultDto> {
    return this.verifications.approve(ctx, userId, dto.note);
  }

  @Post('verifications/:userId/reject')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Rechazar con motivo de la lista y nota',
    description: 'El trabajador ve el motivo y la nota, y puede corregir y volver a enviar.',
  })
  @ApiOkResponse({ type: VerificationResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_TRANSITION_NOT_ALLOWED' })
  reject(
    @AdminCtx() ctx: AdminContext,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Body() dto: RejectVerificationDto,
  ): Promise<VerificationResultDto> {
    return this.verifications.reject(ctx, userId, dto.reason, dto.note);
  }

  @Get('workers/:userId/documents/:documentId/url')
  @Header('Cache-Control', 'no-store')
  @ApiOperation({
    summary: 'Enlace temporal a un documento de identidad (R9.5)',
    description: 'Válido 5 minutos, sin caché. Queda auditado.',
  })
  @ApiOkResponse({ type: DocumentUrlDto })
  documentUrl(
    @AdminCtx() ctx: AdminContext,
    @Param('userId', ParseUUIDPipe) userId: string,
    @Param('documentId', ParseUUIDPipe) documentId: string,
  ): Promise<DocumentUrlDto> {
    return this.verifications.documentUrl(ctx, userId, documentId);
  }
}
