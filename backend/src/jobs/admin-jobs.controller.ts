import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { AdminDisputedJobDto, ResolveDisputeDto } from './dto/job.dto';
import { JobsService } from './jobs.service';

/** Disputas de trabajos (mínimo; la consola completa llega en la Fase 6). */
@ApiTags('admin')
@ApiBearerAuth()
@Admin('moderacion')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/jobs')
export class AdminJobsController {
  constructor(private readonly jobs: JobsService) {}

  @Get('disputed')
  @ApiOperation({ summary: 'Trabajos con un problema reportado, sin resolver' })
  @ApiOkResponse({ type: [AdminDisputedJobDto] })
  disputed(): Promise<AdminDisputedJobDto[]> {
    return this.jobs.disputed();
  }

  @Post(':id/resolve')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Resolver una disputa',
    description:
      'confirm → terminado con comisión (job.completed); cancel → cancelado sin comisión. La nota queda en el historial.',
  })
  @ApiOkResponse({ schema: { properties: { status: { type: 'string', example: 'terminado' } } } })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'JOB_TRANSITION_NOT_ALLOWED' })
  resolve(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ResolveDisputeDto,
  ): Promise<{ status: string }> {
    return this.jobs.resolveDispute(current.id, id, dto.decision, dto.note.trim());
  }
}
