import {
  Body,
  Controller,
  Delete,
  Get,
  Header,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  Res,
} from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiProduces, ApiQuery, ApiTags } from '@nestjs/swagger';
import type { Response } from 'express';
import { AdminAuditService } from '../audit/admin-audit.service';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { CSV_BOM, csvLine, localCell, textCell } from '../billing/csv';
import { Admin, AdminExport } from '../common/admin/admin-permissions';
import {
  AddPilotPhonesDto,
  AddPilotPhonesResultDto,
  PilotInterestRowDto,
  PilotOverviewDto,
  RemovePilotPhoneDto,
} from './dto/pilot.dto';
import { PilotService } from './pilot.service';

@ApiTags('admin')
@Admin('usuarios')
@Controller('admin/pilot')
export class AdminPilotController {
  constructor(
    private readonly pilot: PilotService,
    private readonly audit: AdminAuditService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Piloto cerrado: flag, lista de números e interés (ADR-0052)' })
  @ApiQuery({ name: 'cityId', required: false })
  @ApiOkResponse({ type: PilotOverviewDto })
  async overview(@Query('cityId') cityId?: string): Promise<PilotOverviewDto> {
    const o = await this.pilot.overview(cityId);
    return {
      cityId: o.city.id,
      cityName: o.city.name,
      closed: o.enabled,
      allowlist: o.allowlist.map((r) => ({
        id: r.id,
        phone: r.phone,
        note: r.note,
        createdAt: r.createdAt.toISOString(),
      })),
      interestCount: o.interestCount,
    };
  }

  @Post('allowlist')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Habilitar números (se pueden pegar varios), con motivo' })
  @ApiOkResponse({ type: AddPilotPhonesResultDto })
  async add(
    @AdminCtx() ctx: AdminContext,
    @Body() dto: AddPilotPhonesDto,
  ): Promise<AddPilotPhonesResultDto> {
    const cityId = dto.cityId ?? (await this.pilot.defaultCity()).id;
    return this.pilot.addPhones(
      cityId,
      dto.phones,
      dto.note,
      ctx.adminId,
      this.audit.hook(ctx),
      dto.reason,
    );
  }

  @Delete('allowlist/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Quitar un número de la lista (su cuenta, si ya la creó, sigue)' })
  async remove(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: RemovePilotPhoneDto,
  ): Promise<void> {
    await this.pilot.removePhone(id, this.audit.hook(ctx), dto.reason);
  }

  @Get('interest')
  @ApiOperation({ summary: 'Interés registrado ("Pronto en tu zona"), lo más nuevo primero' })
  @ApiQuery({ name: 'cityId', required: false })
  @ApiOkResponse({ type: PilotInterestRowDto, isArray: true })
  async interest(@Query('cityId') cityId?: string): Promise<PilotInterestRowDto[]> {
    return (await this.pilot.interest(cityId)).map((r) => ({
      id: r.id,
      phone: r.phone,
      role: r.role,
      categoryName: r.category?.name ?? null,
      zone: r.zone,
      createdAt: r.createdAt.toISOString(),
    }));
  }

  @Get('interest.csv')
  @AdminExport()
  @ApiOperation({ summary: 'Interés en CSV (para medir la demanda)' })
  @ApiProduces('text/csv')
  @Header('Content-Type', 'text/csv; charset=utf-8')
  @Header('Content-Disposition', 'attachment; filename="interes-piloto.csv"')
  async interestCsv(
    @Res({ passthrough: true }) res: Response,
    @Query('cityId') cityId?: string,
  ): Promise<string> {
    res.setHeader('Cache-Control', 'no-store');
    const rows = await this.pilot.interest(cityId, 10_000);
    return (
      CSV_BOM +
      csvLine(['fecha', 'telefono', 'quiere', 'categoria', 'zona']) +
      rows
        .map((r) =>
          csvLine([
            localCell(r.createdAt, 'America/La_Paz'),
            textCell(r.phone),
            textCell(r.role),
            textCell(r.category?.name),
            textCell(r.zone),
          ]),
        )
        .join('')
    );
  }
}
