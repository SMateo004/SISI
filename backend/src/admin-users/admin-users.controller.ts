import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
} from '@nestjs/common';
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
import { AdminUsersService } from './admin-users.service';
import {
  ReasonDto,
  UserPageDto,
  UserProfileDto,
  UserRowDto,
  UserSearchQueryDto,
  WorkerStatusResultDto,
} from './dto/admin-users.dto';

@ApiTags('admin')
@Admin('usuarios')
@ApiNotFoundResponse({ type: ApiErrorBody, description: 'USER_NOT_FOUND' })
@Controller('admin')
export class AdminUsersController {
  constructor(private readonly users: AdminUsersService) {}

  @Get('users')
  @ApiOperation({ summary: 'Buscar usuarios por teléfono o nombre', description: '25 por página.' })
  @ApiOkResponse({ type: UserPageDto })
  search(@Query() query: UserSearchQueryDto): Promise<UserPageDto> {
    return this.users.search(query);
  }

  @Get('users/:id')
  @ApiOperation({
    summary: 'Ficha de un usuario',
    description:
      'Estado, modo, ciudad, calificaciones, cancelaciones, reportes recibidos, trabajos, saldo y periodos.',
  })
  @ApiOkResponse({ type: UserProfileDto })
  profile(@Param('id', ParseUUIDPipe) id: string): Promise<UserProfileDto> {
    return this.users.profile(id);
  }

  @Post('users/:id/clear-flag')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Quitar la marca "revisar" de un empleador reportado' })
  @ApiOkResponse({ type: UserRowDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'USER_NOT_FLAGGED' })
  clearFlag(
    @AdminCtx() ctx: AdminContext,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReasonDto,
  ): Promise<UserRowDto> {
    return this.users.clearFlag(ctx, id, dto.reason);
  }

  @Post('workers/:id/suspend')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Suspender el perfil de trabajador',
    description: 'Pasa a suspendido_moderacion y a modo empleador (R1.6). Solo trabajadores.',
  })
  @ApiOkResponse({ type: WorkerStatusResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_TRANSITION_NOT_ALLOWED' })
  suspend(
    @AdminCtx() ctx: AdminContext,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReasonDto,
  ): Promise<WorkerStatusResultDto> {
    return this.users.suspend(ctx, id, dto.reason);
  }

  @Post('workers/:id/reactivate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Levantar la suspensión',
    description: 'Vuelve a aprobado, o a bloqueado_deuda si tiene un periodo vencido.',
  })
  @ApiOkResponse({ type: WorkerStatusResultDto })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'WORKER_TRANSITION_NOT_ALLOWED' })
  reactivate(
    @AdminCtx() ctx: AdminContext,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReasonDto,
  ): Promise<WorkerStatusResultDto> {
    return this.users.reactivate(ctx, id, dto.reason);
  }
}
