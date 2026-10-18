import { Body, Controller, Get, HttpCode, HttpStatus, Post } from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser, Public } from '../auth/decorators/auth.decorators';
import { OtpService } from '../auth/otp/otp.service';
import { SkipAppVersion } from '../client-app/app-version.guard';
import { ApiError, ApiErrorBody } from '../common/errors/api-error';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import { SkipLegal } from '../legal/legal.guard';
import { PrismaService } from '../prisma/prisma.service';
import { AccountDeletionService } from './account-deletion.service';
import {
  ConfirmDeletionDto,
  DeletionCheckDto,
  WebDeletionCodeDto,
  WebDeletionDto,
} from './dto/account-deletion.dto';

const ERASED = [
  'Tu nombre, tu número de celular y tu foto',
  'Tus documentos de identidad y tu fecha de nacimiento',
  'Tu ubicación, las fotos y direcciones de tus solicitudes',
  'Tus sesiones, avisos y notificaciones',
];
const KEPT = [
  'Los movimientos de comisión y pagos, sin tu nombre ni teléfono (obligación contable)',
  'El historial de trabajos y calificaciones, sin tu nombre',
];

/**
 * Eliminar la cuenta (ADR-0049) desde la app, con un código nuevo por SMS como confirmación.
 * Funciona sin aceptar los textos vigentes y con una app desactualizada: nadie queda atrapado.
 */
@ApiTags('me')
@ApiBearerAuth()
@SkipLegal()
@SkipAppVersion()
@Controller('me/deletion')
export class MeDeletionController {
  constructor(
    private readonly deletion: AccountDeletionService,
    private readonly otp: OtpService,
    private readonly prisma: PrismaService,
  ) {}

  @Get()
  @ApiOperation({
    summary: '¿Puedo eliminar mi cuenta? Qué se borra, qué se conserva y qué lo impide',
  })
  @ApiOkResponse({ type: DeletionCheckDto })
  async check(@CurrentUser() user: AuthenticatedUser): Promise<DeletionCheckDto> {
    const blockers = await this.deletion.blockers(user.id);
    return { canDelete: blockers.length === 0, blockers, erased: ERASED, kept: KEPT };
  }

  @Post('code')
  @HttpCode(HttpStatus.ACCEPTED)
  @RateLimit('accountDeletionUser')
  @ApiOperation({ summary: 'Envía el código de confirmación a mi celular' })
  @ApiAcceptedResponse({ description: 'Código enviado' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'ACCOUNT_HAS_DEBT y otros impedimentos' })
  async code(@CurrentUser() user: AuthenticatedUser): Promise<void> {
    const blockers = await this.deletion.blockers(user.id);
    const [first] = blockers;
    if (first) throw new ApiError(HttpStatus.CONFLICT, first.code, first.message, { blockers });
    const { phone } = await this.prisma.user.findUniqueOrThrow({ where: { id: user.id } });
    await this.otp.request(phone);
  }

  @Post()
  @HttpCode(HttpStatus.NO_CONTENT)
  @RateLimit('accountDeletionUser')
  @ApiOperation({ summary: 'Eliminar mi cuenta con el código recibido (no se puede deshacer)' })
  @ApiNoContentResponse()
  @ApiConflictResponse({ type: ApiErrorBody, description: 'ACCOUNT_HAS_DEBT y otros impedimentos' })
  async delete(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: ConfirmDeletionDto,
  ): Promise<void> {
    const { phone } = await this.prisma.user.findUniqueOrThrow({ where: { id: user.id } });
    await this.otp.verify(phone, dto.code);
    await this.deletion.delete(user.id, 'app');
  }
}

/**
 * Página pública de eliminación (la exige Google Play para apps con registro): se identifica con
 * el celular y un código por SMS, sin instalar la app.
 */
@ApiTags('me')
@Public()
@SkipAppVersion()
@Controller('account-deletion')
export class WebDeletionController {
  constructor(
    private readonly deletion: AccountDeletionService,
    private readonly otp: OtpService,
    private readonly prisma: PrismaService,
  ) {}

  @Post('code')
  @HttpCode(HttpStatus.ACCEPTED)
  @RateLimit('otpRequestIp')
  @ApiOperation({
    summary: 'Pide el código para eliminar una cuenta',
    description:
      'La respuesta es la misma tenga o no cuenta el número (solo se envía SMS si la tiene).',
  })
  @ApiAcceptedResponse({ description: 'Si el número tiene cuenta, se envió el código' })
  async code(@Body() dto: WebDeletionCodeDto): Promise<void> {
    const phone = this.otp.normalize(dto.phone);
    const user = await this.prisma.user.findUnique({ where: { phone } });
    if (user && !user.deletedAt) await this.otp.request(phone);
  }

  @Post()
  @HttpCode(HttpStatus.NO_CONTENT)
  @RateLimit('otpVerifyIp')
  @ApiOperation({
    summary: 'Eliminar la cuenta de ese número con el código (no se puede deshacer)',
  })
  @ApiNoContentResponse()
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'ACCOUNT_NOT_FOUND' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'ACCOUNT_HAS_DEBT y otros impedimentos' })
  async delete(@Body() dto: WebDeletionDto): Promise<void> {
    const phone = await this.otp.verify(dto.phone, dto.code);
    const user = await this.prisma.user.findUnique({ where: { phone } });
    if (!user || user.deletedAt) {
      throw new ApiError(
        HttpStatus.NOT_FOUND,
        'ACCOUNT_NOT_FOUND',
        'Ese número no tiene una cuenta.',
      );
    }
    await this.deletion.delete(user.id, 'web');
  }
}
