import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import {
  AcceptOfferResultDto,
  CreateOfferDto,
  EmployerOfferDto,
  IncomingRequestDto,
  JobContactDto,
  MyOfferDto,
} from './dto/offer.dto';
import { OffersService } from './offers.service';

@ApiTags('ofertas')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller()
export class OffersController {
  constructor(private readonly offers: OffersService) {}

  // ---- Trabajador ----

  @Get('worker/requests')
  @ApiOperation({
    summary: 'Solicitudes que me llegaron (últimas 24 h)',
    description:
      'Bandeja del trabajador y resincronización al reconectar el socket. Incluye el estado de mi oferta y si me eligieron.',
  })
  @ApiOkResponse({ type: [IncomingRequestDto] })
  incoming(@CurrentUser() current: AuthenticatedUser): Promise<IncomingRequestDto[]> {
    return this.offers.incoming(current.id);
  }

  @Get('worker/requests/:id')
  @ApiOperation({
    summary: 'Detalle de una solicitud que me llegó (R5.1)',
    description: 'Solo para trabajadores notificados: a los demás les responde 404.',
  })
  @ApiOkResponse({ type: IncomingRequestDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_FOUND' })
  incomingOne(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<IncomingRequestDto> {
    return this.offers.incomingOne(current.id, id);
  }

  @Post('requests/:id/offers')
  @HttpCode(200)
  @RateLimit('offerCreateIp')
  @ApiOperation({
    summary: 'Ofertar: aceptar el precio o contraofertar (R5.2)',
    description:
      'Solo trabajadores notificados y que sigan elegibles. Una oferta por trabajador: enviar otra la reemplaza mientras no se haya elegido ninguna.',
  })
  @ApiOkResponse({ type: MyOfferDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'OFFER_AMOUNT_INVALID u OFFER_AMOUNT_TOO_HIGH (trae maxBs)',
  })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_FOUND' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'OFFERS_CLOSED o NOT_ELIGIBLE' })
  @ApiTooManyRequestsResponse({ type: ApiErrorBody, description: 'RATE_LIMITED' })
  offer(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CreateOfferDto,
  ): Promise<MyOfferDto> {
    return this.offers.createOrReplace(current.id, id, dto);
  }

  @Delete('requests/:id/offers/mine')
  @ApiOperation({
    summary: 'Retirar mi oferta',
    description:
      'Mientras el empleador no haya elegido. Si era la única, la solicitud vuelve a buscar trabajadores.',
  })
  @ApiOkResponse({ type: MyOfferDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_FOUND' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'NO_ACTIVE_OFFER u OFFERS_CLOSED' })
  withdraw(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<MyOfferDto> {
    return this.offers.withdraw(current.id, id);
  }

  // ---- Empleador ----

  @Get('requests/:id/offers')
  @ApiOperation({
    summary: 'Ofertas de mi solicitud (R5.3)',
    description: 'Precio, calificación, tiempo estimado de llegada y nombre corto del trabajador.',
  })
  @ApiOkResponse({ type: [EmployerOfferDto] })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_FOUND' })
  list(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<EmployerOfferDto[]> {
    return this.offers.listForEmployer(current.id, id);
  }

  @Post('requests/:id/offers/:offerId/accept')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Elegir una oferta (R5.4)',
    description:
      'Crea el trabajo, asigna la solicitud y cierra las demás ofertas. Después, el contacto se pide con GET /jobs/{jobId}/contact.',
  })
  @ApiOkResponse({ type: AcceptOfferResultDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REQUEST_NOT_FOUND' })
  @ApiConflictResponse({
    type: ApiErrorBody,
    description:
      'REQUEST_ALREADY_ASSIGNED, OFFERS_CLOSED, OFFER_NOT_AVAILABLE o WORKER_BUSY (la oferta se retira)',
  })
  accept(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Param('offerId', ParseUUIDPipe) offerId: string,
  ): Promise<AcceptOfferResultDto> {
    return this.offers.accept(current.id, id, offerId);
  }

  // ---- Contacto ----

  @Get('jobs/:id/contact')
  @ApiOperation({
    summary: 'Contacto de la contraparte (R5.4, R9.4)',
    description:
      'Solo para el empleador y el trabajador del trabajo. Al trabajador también le da la dirección.',
  })
  @ApiOkResponse({ type: JobContactDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'JOB_NOT_FOUND' })
  contact(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobContactDto> {
    return this.offers.contact(current.id, id);
  }
}
