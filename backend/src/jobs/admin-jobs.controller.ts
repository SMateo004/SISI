import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post } from '@nestjs/common';
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
import { AdminJobsService } from './admin-jobs.service';
import { AdminJobDetailDto } from './dto/admin-job.dto';
import { AdminDisputedJobDto, ResolveDisputeDto } from './dto/job.dto';
import { JobsService } from './jobs.service';

/** Disputas de trabajos (R6, ADR-0029): lista, detalle y resolución. */
@ApiTags('admin')
@Admin('moderacion')
@Controller('admin/jobs')
export class AdminJobsController {
  constructor(
    private readonly jobs: JobsService,
    private readonly adminJobs: AdminJobsService,
  ) {}

  @Get('disputed')
  @ApiOperation({ summary: 'Trabajos con un problema reportado, sin resolver' })
  @ApiOkResponse({ type: [AdminDisputedJobDto] })
  disputed(): Promise<AdminDisputedJobDto[]> {
    return this.jobs.disputed();
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Detalle de un trabajo para revisar una disputa',
    description:
      'Partes, solicitud, montos, línea de tiempo (job_events), todo el chat (incluido lo retenido) y las ofertas con su historial (offer_events).',
  })
  @ApiOkResponse({ type: AdminJobDetailDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'JOB_NOT_FOUND' })
  detail(@Param('id', ParseUUIDPipe) id: string): Promise<AdminJobDetailDto> {
    return this.adminJobs.detail(id);
  }

  @Post(':id/resolve')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Resolver una disputa',
    description:
      'confirm → terminado con comisión (job.completed); cancel → cancelado sin comisión. La nota queda en el historial y en la auditoría.',
  })
  @ApiOkResponse({ schema: { properties: { status: { type: 'string', example: 'terminado' } } } })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'JOB_TRANSITION_NOT_ALLOWED' })
  resolve(
    @AdminCtx() ctx: AdminContext,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ResolveDisputeDto,
  ): Promise<{ status: string }> {
    return this.adminJobs.resolve(ctx, id, dto.decision, dto.note.trim());
  }
}
