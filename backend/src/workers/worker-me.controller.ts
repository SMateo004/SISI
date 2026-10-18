import { Body, Controller, Get, Param, ParseEnumPipe, Patch, Post, Put } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiProperty,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { IsIn } from 'class-validator';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { ConfirmUploadDto, PresignedUploadDto } from '../storage/dto/upload.dto';
import { UserDto } from '../users/dto/user.dto';
import { UserPresenter } from '../users/user.presenter';
import {
  DocumentUploadRequestDto,
  REQUIRED_DOCUMENTS,
  type RequiredDocumentType,
  SubmitUpgradeDto,
  WorkerProfileDto,
} from './dto/worker.dto';
import { ModeService } from './mode.service';
import { WorkersService } from './workers.service';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';

export class SwitchModeDto {
  @ApiProperty({ enum: ['employer', 'worker'], example: 'worker' })
  @IsIn(['employer', 'worker'], { message: 'El modo debe ser employer o worker.' })
  mode!: 'employer' | 'worker';
}

export class ModeDeniedDto extends ApiErrorBody {
  @ApiProperty({
    enum: [
      'COMPLETE_VERIFICATION',
      'VIEW_REVIEW_STATUS',
      'RESUBMIT_VERIFICATION',
      'PAY_COMMISSION',
      'CONTACT_SUPPORT',
      'COMPLETE_PROFILE',
    ],
    example: 'COMPLETE_VERIFICATION',
  })
  nextAction!: string;

  @ApiProperty({ example: 'Completa tu verificación' })
  actionLabel!: string;
}

const DOCUMENT_TYPES = Object.fromEntries(REQUIRED_DOCUMENTS.map((t) => [t, t])) as Record<
  RequiredDocumentType,
  RequiredDocumentType
>;

@ApiTags('worker')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller('me')
export class WorkerMeController {
  constructor(
    private readonly workers: WorkersService,
    private readonly modes: ModeService,
    private readonly presenter: UserPresenter,
  ) {}

  @Patch('mode')
  @ApiOperation({
    summary: 'Interruptor empleador / trabajador',
    description:
      'A employer siempre se puede cambiar. A worker solo con el perfil aprobado; si no, 409 con el motivo y la acción siguiente (R1.5, R1.6).',
  })
  @ApiOkResponse({ type: UserDto })
  @ApiConflictResponse({
    type: ModeDeniedDto,
    description:
      'WORKER_NOT_REQUESTED, WORKER_UNDER_REVIEW, WORKER_REJECTED, WORKER_BLOCKED_DEBT, WORKER_SUSPENDED o NAME_REQUIRED (R1.3 ampliada)',
  })
  async switchMode(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: SwitchModeDto,
  ): Promise<UserDto> {
    return this.presenter.present(await this.modes.switchMode(current.id, dto.mode));
  }

  @Get('worker')
  @ApiOperation({ summary: 'Mi perfil de trabajador y el estado de cada documento' })
  @ApiOkResponse({ type: WorkerProfileDto })
  getProfile(@CurrentUser() current: AuthenticatedUser): Promise<WorkerProfileDto> {
    return this.workers.getMyProfile(current.id);
  }

  @Post('worker/documents/upload-url')
  @RateLimit('uploadUrlUser')
  @ApiOperation({
    summary: 'URL prefirmada para subir un documento (CI anverso, reverso o selfie)',
    description: 'Válida 5 minutos. Luego confirmar con PUT /me/worker/documents/{type}.',
  })
  @ApiCreatedResponse({ type: PresignedUploadDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'UPLOAD_TYPE_NOT_ALLOWED o UPLOAD_TOO_LARGE',
  })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_PROFILE_LOCKED' })
  documentUploadUrl(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: DocumentUploadRequestDto,
  ): Promise<PresignedUploadDto> {
    return this.workers.documentUploadUrl(current.id, dto.type, dto.contentType, dto.sizeBytes);
  }

  @Put('worker/documents/:type')
  @ApiOperation({ summary: 'Confirma un documento subido' })
  @ApiParam({ name: 'type', enum: REQUIRED_DOCUMENTS })
  @ApiOkResponse({ type: WorkerProfileDto })
  @ApiForbiddenResponse({ type: ApiErrorBody, description: 'UPLOAD_KEY_FORBIDDEN' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_PROFILE_LOCKED' })
  confirmDocument(
    @CurrentUser() current: AuthenticatedUser,
    @Param('type', new ParseEnumPipe(DOCUMENT_TYPES)) type: RequiredDocumentType,
    @Body() dto: ConfirmUploadDto,
  ): Promise<WorkerProfileDto> {
    return this.workers.confirmDocument(current.id, type, dto.key);
  }

  @Post('worker/upgrade')
  @ApiOperation({
    summary: 'Envía la solicitud para trabajar (R1.3)',
    description:
      'Requiere teléfono verificado, 18 años cumplidos (hora de Bolivia), CI ambos lados, selfie, categorías activas, transporte y radio de 1 a 10 km. El estado pasa a pendiente_revision.',
  })
  @ApiCreatedResponse({ type: WorkerProfileDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description:
      'VALIDATION_ERROR, WORKER_UNDERAGE, WORKER_DOCUMENTS_MISSING, CATEGORY_NOT_AVAILABLE o PHONE_NOT_VERIFIED',
  })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_TRANSITION_NOT_ALLOWED' })
  submitUpgrade(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: SubmitUpgradeDto,
  ): Promise<WorkerProfileDto> {
    return this.workers.submitUpgrade(current.id, dto);
  }
}
