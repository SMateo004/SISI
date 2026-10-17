import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser, Roles } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import {
  AdminReportDto,
  CreateReportDto,
  ListReportsQuery,
  ReportDto,
  ResolveReportDto,
  ResolveReportResultDto,
} from './dto/report.dto';
import { ReportsService } from './reports.service';

/** Reportes (R9.3, ADR-0033). */
@ApiTags('reportes')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller('reports')
export class ReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Post()
  @ApiOperation({
    summary: 'Reportar una solicitud, un perfil, un mensaje o un trabajo',
    description:
      'Solo algo con lo que tuviste relación. Un reporte por objetivo. Un mensaje reportado deja de mostrarse para quien lo reportó.',
  })
  @ApiCreatedResponse({ type: ReportDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REPORT_TARGET_NOT_FOUND' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'ALREADY_REPORTED' })
  create(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: CreateReportDto,
  ): Promise<ReportDto> {
    return this.reports.create(current.id, dto.targetType, dto.targetId, dto.reason, dto.note);
  }

  @Get('mine')
  @ApiOperation({ summary: 'Mis reportes y su estado' })
  @ApiOkResponse({ type: [ReportDto] })
  mine(@CurrentUser() current: AuthenticatedUser): Promise<ReportDto[]> {
    return this.reports.mine(current.id);
  }
}

/** Revisión de reportes (mínimo; la consola llega en la Fase 6). */
@ApiTags('admin')
@ApiBearerAuth()
@Roles('admin')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/reports')
export class AdminReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Get()
  @ApiOperation({ summary: 'Reportes por estado (por defecto, pendientes)' })
  @ApiOkResponse({ type: [AdminReportDto] })
  list(@Query() q: ListReportsQuery): Promise<AdminReportDto[]> {
    return this.reports.list(q.status);
  }

  @Post(':id/resolve')
  @HttpCode(200)
  @ApiOperation({
    summary: 'Marcar un reporte como válido o descartado',
    description:
      'Con 3 reportes válidos de personas distintas, el trabajador queda suspendido (R9.3) o, si solo es empleador, marcado para revisión.',
  })
  @ApiOkResponse({ type: ResolveReportResultDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'REPORT_NOT_FOUND' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'REPORT_ALREADY_RESOLVED' })
  resolve(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ResolveReportDto,
  ): Promise<ResolveReportResultDto> {
    return this.reports.resolve(current.id, id, dto.valid, dto.resolution.trim());
  }
}
