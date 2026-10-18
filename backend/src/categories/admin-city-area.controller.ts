import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
} from '@nestjs/common';
import { ApiBadRequestResponse, ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { AdminAuditService } from '../audit/admin-audit.service';
import { AdminCtx, type AdminContext } from '../audit/admin-context';
import { Admin } from '../common/admin/admin-permissions';
import { ApiError, ApiErrorBody } from '../common/errors/api-error';
import { type CityArea, CityAreaService } from './city-area.service';
import { CityAreaDto, SetCityAreaDto, TestPointDto, TestPointResultDto } from './dto/city-area.dto';

const toDto = (a: CityArea): CityAreaDto => ({
  cityId: a.cityId,
  centerLat: a.center?.lat ?? null,
  centerLng: a.center?.lng ?? null,
  radiusKm: a.radiusKm,
  geojson: a.polygon ? JSON.stringify(a.polygon) : null,
});

@ApiTags('admin')
@Admin('catalogo')
@Controller('admin/cities/:id/service-area')
export class AdminCityAreaController {
  constructor(
    private readonly areas: CityAreaService,
    private readonly audit: AdminAuditService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Zona de servicio de la ciudad: polígono GeoJSON o radio (ADR-0052)' })
  @ApiOkResponse({ type: CityAreaDto })
  async get(@Param('id', new ParseUUIDPipe()) id: string): Promise<CityAreaDto> {
    return toDto(await this.areas.get(id));
  }

  @Put()
  @ApiOperation({
    summary: 'Cambiar la zona (polígono o radio), con motivo',
    description:
      'Se valida el GeoJSON (un contorno cerrado dentro de Bolivia, válido en PostGIS y con el centro adentro). Vale para las solicitudes nuevas.',
  })
  @ApiOkResponse({ type: CityAreaDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'SERVICE_AREA_INVALID' })
  async set(
    @AdminCtx() ctx: AdminContext,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: SetCityAreaDto,
  ): Promise<CityAreaDto> {
    let polygon: unknown = null;
    if (dto.geojson !== null) {
      try {
        polygon = JSON.parse(dto.geojson);
      } catch {
        throw new ApiError(
          HttpStatus.BAD_REQUEST,
          'SERVICE_AREA_INVALID',
          'El texto no es un JSON válido.',
        );
      }
    }
    return toDto(
      await this.areas.set(
        id,
        { polygon, radiusKm: dto.radiusKm },
        this.audit.hook(ctx),
        dto.reason,
      ),
    );
  }

  @Post('test')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Probar si un punto está dentro de la zona (sin guardar nada)' })
  @ApiOkResponse({ type: TestPointResultDto })
  test(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: TestPointDto,
  ): Promise<TestPointResultDto> {
    return this.areas.test(id, dto);
  }
}
