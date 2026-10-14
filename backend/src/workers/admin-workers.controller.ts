import { Controller, Get, Param, ParseUUIDPipe } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Roles } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { DocumentUrlDto } from './dto/worker.dto';
import { WorkersService } from './workers.service';

/** Endpoints de administración de trabajadores. La revisión completa llega en la Fase 6. */
@ApiTags('admin')
@ApiBearerAuth()
@Roles('admin')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/workers')
export class AdminWorkersController {
  constructor(private readonly workers: WorkersService) {}

  @Get(':userId/documents/:documentId/url')
  @ApiOperation({
    summary: 'Enlace temporal a un documento de identidad (R9.5)',
    description: 'Válido 5 minutos. Solo administradores.',
  })
  @ApiOkResponse({ type: DocumentUrlDto })
  @ApiNotFoundResponse({ description: 'El documento no existe o no es de ese trabajador' })
  documentUrl(
    @Param('userId', new ParseUUIDPipe()) userId: string,
    @Param('documentId', new ParseUUIDPipe()) documentId: string,
  ): Promise<DocumentUrlDto> {
    return this.workers.adminDocumentUrl(userId, documentId);
  }
}
