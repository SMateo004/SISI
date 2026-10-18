import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { Admin } from '../common/admin/admin-permissions';
import { ApiErrorBody } from '../common/errors/api-error';
import { ChatService } from './chat.service';
import {
  AdminHeldMessageDto,
  ChatPageDto,
  ListMessagesQuery,
  MarkReadDto,
  MarkReadResultDto,
  SendMessageDto,
  SentMessageDto,
} from './dto/chat.dto';

/** Chat del trabajo (R9.4, ADR-0031). Solo las dos partes; a un tercero, 404. */
@ApiTags('chat')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@ApiNotFoundResponse({ type: ApiErrorBody, description: 'JOB_NOT_FOUND' })
@Controller('jobs/:id/messages')
export class ChatController {
  constructor(private readonly chat: ChatService) {}

  @Get()
  @ApiOperation({
    summary: 'Mensajes del trabajo',
    description:
      'Del más reciente al más antiguo. Los retenidos solo los ve quien los envió. En vivo llegan por chat:message.',
  })
  @ApiOkResponse({ type: ChatPageDto })
  list(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Query() q: ListMessagesQuery,
  ): Promise<ChatPageDto> {
    return this.chat.list(current.id, id, q.cursor, q.limit);
  }

  @Post()
  @ApiOperation({
    summary: 'Enviar un mensaje (solo texto)',
    description:
      'Se modera (R9.2): si coincide, queda retenido, no se entrega y vuelve con `notice`. Abierto hasta 24 h después de terminado o cancelado.',
  })
  @ApiCreatedResponse({ type: SentMessageDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'MESSAGE_EMPTY o validación' })
  @ApiConflictResponse({ type: ApiErrorBody, description: 'CHAT_CLOSED' })
  @ApiTooManyRequestsResponse({ type: ApiErrorBody, description: 'RATE_LIMITED' })
  send(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SendMessageDto,
  ): Promise<SentMessageDto> {
    return this.chat.send(current.id, id, dto.body);
  }

  @Post('read')
  @HttpCode(200)
  @ApiOperation({ summary: 'Marcar como leídos los mensajes recibidos hasta uno (incluido)' })
  @ApiOkResponse({ type: MarkReadResultDto })
  read(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: MarkReadDto,
  ): Promise<MarkReadResultDto> {
    return this.chat.markRead(current.id, id, dto.upToId);
  }
}

/** Mensajes retenidos por moderación (mínimo; la consola llega en la Fase 6). */
@ApiTags('admin')
@ApiBearerAuth()
@Admin('moderacion')
@ApiForbiddenResponse({ type: ApiErrorBody, description: 'FORBIDDEN: solo administradores' })
@Controller('admin/chat')
export class AdminChatController {
  constructor(private readonly chat: ChatService) {}

  @Get('held')
  @ApiOperation({ summary: 'Mensajes de chat retenidos (los 100 más recientes)' })
  @ApiOkResponse({ type: [AdminHeldMessageDto] })
  held(): Promise<AdminHeldMessageDto[]> {
    return this.chat.held();
  }
}
