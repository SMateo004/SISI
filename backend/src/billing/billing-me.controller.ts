import { Body, Controller, Get, Post } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { PresignedUploadDto } from '../storage/dto/upload.dto';
import { BillingFilesService } from './billing-files.service';
import { CreateSubmissionDto, FileUploadDto, PaymentSubmissionDto } from './dto/billing-files.dto';

/** Cobros del trabajador (R7.4, R8). Solo sus propios datos. */
@ApiTags('ganancias')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'NOT_A_WORKER' })
@Controller('me/billing')
export class BillingMeController {
  constructor(private readonly files: BillingFilesService) {}

  @Post('submissions/upload-url')
  @ApiOperation({ summary: 'URL para subir la foto de mi comprobante de pago' })
  @ApiCreatedResponse({ type: PresignedUploadDto })
  submissionUploadUrl(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: FileUploadDto,
  ): Promise<PresignedUploadDto> {
    return this.files.submissionUploadUrl(current.id, dto.contentType, dto.sizeBytes);
  }

  @Post('submissions')
  @ApiOperation({
    summary: 'Enviar mi comprobante de pago (propuesta)',
    description:
      'Queda "enviado, pendiente de verificación". No cambia la deuda hasta que SISI registra el pago.',
  })
  @ApiCreatedResponse({ type: PaymentSubmissionDto })
  submit(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: CreateSubmissionDto,
  ): Promise<PaymentSubmissionDto> {
    return this.files.submit(current.id, dto);
  }

  @Get('submissions')
  @ApiOperation({ summary: 'Mis comprobantes enviados y su estado' })
  @ApiOkResponse({ type: [PaymentSubmissionDto] })
  submissions(@CurrentUser() current: AuthenticatedUser): Promise<PaymentSubmissionDto[]> {
    return this.files.mySubmissions(current.id);
  }
}
