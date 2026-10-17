import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { CancelJobDto, DisputeJobDto, JobDto, JobPageDto, ListJobsQuery } from './dto/job.dto';
import { JobLocationDto } from './dto/job.dto';
import { JobTrackingService } from './job-tracking.service';
import { JobsService } from './jobs.service';

/** Ciclo del trabajo (R6, ADR-0029). Los errores de estado son 409; los de rol, 403. */
@ApiTags('trabajos')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@ApiNotFoundResponse({ type: ApiErrorBody, description: 'JOB_NOT_FOUND (también para terceros)' })
@ApiForbiddenResponse({
  type: ApiErrorBody,
  description: 'JOB_ACTION_FORBIDDEN: no le toca a tu rol',
})
@ApiConflictResponse({ type: ApiErrorBody, description: 'JOB_TRANSITION_NOT_ALLOWED' })
@Controller('jobs')
export class JobsController {
  constructor(
    private readonly jobs: JobsService,
    private readonly tracking: JobTrackingService,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Historial de trabajos (R8.3)',
    description: 'Como trabajador incluye la comisión y el neto de cada trabajo terminado.',
  })
  @ApiOkResponse({ type: JobPageDto })
  list(@CurrentUser() current: AuthenticatedUser, @Query() q: ListJobsQuery): Promise<JobPageDto> {
    return this.jobs.list(current.id, q.role, q.cursor, q.limit);
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Detalle del trabajo',
    description: 'Estado, línea de tiempo y acciones permitidas. Solo para las dos partes.',
  })
  @ApiOkResponse({ type: JobDto })
  get(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobDto> {
    return this.jobs.get(current.id, id);
  }

  @Post(':id/on-the-way')
  @HttpCode(200)
  @ApiOperation({ summary: 'Voy en camino (trabajador)', description: 'asignado → en_camino' })
  @ApiOkResponse({ type: JobDto })
  onTheWay(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobDto> {
    return this.jobs.act(current.id, id, 'START_TRIP');
  }

  @Post(':id/start')
  @HttpCode(200)
  @ApiOperation({ summary: 'Empecé el trabajo (trabajador)', description: 'en_camino → en_curso' })
  @ApiOkResponse({ type: JobDto })
  start(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobDto> {
    return this.jobs.act(current.id, id, 'START_WORK');
  }

  @Post(':id/finish')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Terminé el trabajo (trabajador)',
    description:
      'Solo en curso. Queda esperando la confirmación del empleador; si no responde en el plazo (24 h), se confirma solo.',
  })
  @ApiOkResponse({ type: JobDto })
  finish(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobDto> {
    return this.jobs.act(current.id, id, 'FINISH');
  }

  @Post(':id/confirm')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Confirmar el término (empleador, R6.2)',
    description: 'en_curso → terminado. Calcula la comisión (R6.3).',
  })
  @ApiOkResponse({ type: JobDto })
  confirm(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobDto> {
    return this.jobs.act(current.id, id, 'CONFIRM');
  }

  @Post(':id/dispute')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Hubo un problema (empleador)',
    description:
      'Después de que el trabajador marcó terminado. Frena la autoconfirmación; lo resuelve un administrador.',
  })
  @ApiOkResponse({ type: JobDto })
  dispute(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: DisputeJobDto,
  ): Promise<JobDto> {
    const trimmed = dto.note?.trim();
    const note = trimmed === '' ? undefined : trimmed;
    return this.jobs.act(current.id, id, 'DISPUTE', { data: { disputeNote: note ?? null }, note });
  }

  @Post(':id/cancel')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Cancelar el trabajo (cualquiera de las dos partes)',
    description:
      'Solo asignado o en camino; en curso ya no. Motivo de la lista y nota opcional (moderada). Sin penalidad; la solicitud queda cancelada y el empleador puede volver a publicarla.',
  })
  @ApiOkResponse({ type: JobDto })
  cancel(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CancelJobDto,
  ): Promise<JobDto> {
    return this.jobs.cancel(current.id, id, dto.reason, dto.note);
  }

  @Get(':id/location')
  @ApiOperation({
    summary: 'Ubicación del trabajador en camino (empleador)',
    description:
      'Para resincronizar el mapa; en vivo llega por job:location. Solo mientras va en camino (409 JOB_LOCATION_UNAVAILABLE).',
  })
  @ApiOkResponse({ type: JobLocationDto })
  async location(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobLocationDto> {
    return { jobId: id, location: await this.tracking.current(current.id, id) };
  }
}
