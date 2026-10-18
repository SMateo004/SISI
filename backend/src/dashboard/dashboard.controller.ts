import { Controller, Get, Query } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Admin } from '../common/admin/admin-permissions';
import { DashboardService } from './dashboard.service';
import { CountersDto, DashboardDto, DashboardQueryDto } from './dto/dashboard.dto';

@ApiTags('admin')
@Admin('dashboard')
@Controller('admin')
export class DashboardController {
  constructor(private readonly dashboard: DashboardService) {}

  @Get('dashboard')
  @ApiOperation({
    summary: 'Dashboard del día o de la semana (hora local de la ciudad)',
    description:
      'Solicitudes, asignación, expiración, tiempo a la primera oferta, trabajos, cancelaciones, comisión, deuda vencida, disponibles ahora y colas.',
  })
  @ApiOkResponse({ type: DashboardDto })
  get(@Query() query: DashboardQueryDto): Promise<DashboardDto> {
    return this.dashboard.dashboard(query.range ?? 'day', query.cityId);
  }

  @Get('counters')
  @ApiOperation({
    summary: 'Colas pendientes para el menú del panel',
    description: 'También llegan en vivo por el evento admin:counters (ADR-0044).',
  })
  @ApiOkResponse({ type: CountersDto })
  counters(): Promise<CountersDto> {
    return this.dashboard.counters();
  }
}
