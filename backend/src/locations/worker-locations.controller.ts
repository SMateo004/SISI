import { Body, Controller, Get, HttpCode, Post, Put } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import {
  AvailabilityDto,
  LocationUpdateDto,
  LocationUpdateResultDto,
  SetAvailabilityDto,
} from './dto/location.dto';
import { WorkerLocationsService } from './worker-locations.service';

@ApiTags('worker')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller('worker')
export class WorkerLocationsController {
  constructor(private readonly locations: WorkerLocationsService) {}

  @Get('availability')
  @ApiOperation({ summary: 'Mi disponibilidad y última ubicación recibida' })
  @ApiOkResponse({ type: AvailabilityDto })
  get(@CurrentUser() current: AuthenticatedUser): Promise<AvailabilityDto> {
    return this.locations.get(current.id);
  }

  @Put('availability')
  @ApiOperation({
    summary: 'Toggle "Disponible"',
    description:
      'Activar exige modo trabajador, perfil aprobado y la ubicación actual. Sin ubicación en `staleAfterSec`, deja de estar disponible solo (ADR-0024).',
  })
  @ApiOkResponse({ type: AvailabilityDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'LOCATION_REQUIRED' })
  @ApiConflictResponse({
    type: ApiErrorBody,
    description:
      'WORKER_MODE_REQUIRED o el motivo del estado (WORKER_UNDER_REVIEW, WORKER_BLOCKED_DEBT...)',
  })
  set(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: SetAvailabilityDto,
  ): Promise<AvailabilityDto> {
    return this.locations.setAvailability(current.id, dto);
  }

  @Post('location')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Ubicación en vivo (solo con "Disponible" y la app en primer plano)',
    description: 'Enviar cada `sendEverySec` o al moverse. Postgres se actualiza con throttling.',
  })
  @ApiOkResponse({ type: LocationUpdateResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'NOT_AVAILABLE' })
  @ApiTooManyRequestsResponse({ type: ApiErrorBody, description: 'RATE_LIMITED' })
  update(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: LocationUpdateDto,
  ): Promise<LocationUpdateResultDto> {
    return this.locations.updateLocation(current.id, dto);
  }
}
