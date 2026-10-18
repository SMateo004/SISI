import { Body, Controller, Get, HttpCode, HttpStatus, Post } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser, Public } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { AcceptLegalDto, LegalDocumentDto, LegalPendingDto } from './dto/legal.dto';
import { SkipLegal } from './legal.guard';
import { LegalService } from './legal.service';
import { SkipAppVersion } from '../client-app/app-version.guard';

@ApiTags('legal')
@Controller()
export class LegalController {
  constructor(private readonly legal: LegalService) {}

  @Get('legal/current')
  @SkipAppVersion()
  @Public()
  @ApiOperation({ summary: 'Términos de uso y política de privacidad vigentes (ADR-0051)' })
  @ApiOkResponse({ type: LegalDocumentDto, isArray: true })
  current(): Promise<LegalDocumentDto[]> {
    return this.legal.currentDocuments();
  }

  @Post('me/legal/accept')
  @SkipLegal()
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'Aceptar las versiones vigentes y declarar la mayoría de edad',
    description: 'Queda registrado con versión y fecha. Una versión nueva vuelve a pedirlo.',
  })
  @ApiOkResponse({ type: LegalPendingDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'VALIDATION_ERROR (adult debe ser true)',
  })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'LEGAL_VERSION_CHANGED' })
  async accept(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: AcceptLegalDto,
  ): Promise<LegalPendingDto> {
    return { legalPending: await this.legal.accept(user.id, dto) };
  }
}
