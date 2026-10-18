import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import type { DevicePlatform } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import {
  NotificationDto,
  NotificationPageDto,
  ReadAllResultDto,
  RegisterDeviceDto,
  UnreadCountDto,
} from './dto/notification.dto';
import { SkipLegal } from '../legal/legal.guard';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';

const PAGE = 20;

@ApiTags('notificaciones')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller('me')
export class NotificationsController {
  constructor(private readonly prisma: PrismaService) {}

  @Post('devices')
  // La app registra el push al iniciar sesión, antes de la pantalla de aceptación (ADR-0051).
  @SkipLegal()
  @RateLimit('deviceUser')
  @HttpCode(204)
  @ApiOperation({
    summary: 'Registrar el token de push (FCM) de este dispositivo',
    description: 'Idempotente. Si el token era de otra cuenta (cambio de sesión), pasa a esta.',
  })
  @ApiNoContentResponse()
  async registerDevice(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: RegisterDeviceDto,
  ): Promise<void> {
    const platform = dto.platform as DevicePlatform;
    await this.prisma.deviceToken.upsert({
      where: { token: dto.token },
      create: { token: dto.token, platform, userId: current.id },
      update: { userId: current.id, platform, lastSeenAt: new Date() },
    });
  }

  @Delete('devices/:token')
  @SkipLegal()
  @HttpCode(204)
  @ApiOperation({ summary: 'Dar de baja el token de push (al cerrar sesión)' })
  @ApiNoContentResponse()
  async unregisterDevice(
    @CurrentUser() current: AuthenticatedUser,
    @Param('token') token: string,
  ): Promise<void> {
    await this.prisma.deviceToken.deleteMany({ where: { token, userId: current.id } });
  }

  @Get('notifications')
  @ApiOperation({ summary: 'Mis avisos, del más reciente al más antiguo' })
  @ApiQuery({ name: 'cursor', required: false })
  @ApiOkResponse({ type: NotificationPageDto })
  async list(
    @CurrentUser() current: AuthenticatedUser,
    @Query('cursor') cursor?: string,
  ): Promise<NotificationPageDto> {
    const rows = await this.prisma.notification.findMany({
      where: { userId: current.id },
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: PAGE + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, PAGE);
    return {
      items: page.map((n): NotificationDto => {
        const data = (n.payload ?? {}) as Record<string, unknown>;
        return {
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          route: typeof data.route === 'string' ? data.route : '/',
          data,
          readAt: n.readAt?.toISOString() ?? null,
          createdAt: n.createdAt.toISOString(),
        };
      }),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  @Get('notifications/unread-count')
  @ApiOperation({ summary: 'Cuántos avisos tengo sin leer' })
  @ApiOkResponse({ type: UnreadCountDto })
  async unreadCount(@CurrentUser() current: AuthenticatedUser): Promise<UnreadCountDto> {
    return {
      count: await this.prisma.notification.count({
        where: { userId: current.id, readAt: null },
      }),
    };
  }

  @Post('notifications/read-all')
  @HttpCode(200)
  @ApiOperation({ summary: 'Marcar todos mis avisos como leídos' })
  @ApiOkResponse({ type: ReadAllResultDto })
  async readAll(@CurrentUser() current: AuthenticatedUser): Promise<ReadAllResultDto> {
    const { count } = await this.prisma.notification.updateMany({
      where: { userId: current.id, readAt: null },
      data: { readAt: new Date() },
    });
    return { updated: count };
  }

  @Post('notifications/:id/read')
  @HttpCode(204)
  @ApiOperation({ summary: 'Marcar un aviso como leído' })
  @ApiNoContentResponse()
  async markRead(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<void> {
    await this.prisma.notification.updateMany({
      where: { id, userId: current.id, readAt: null },
      data: { readAt: new Date() },
    });
  }
}
