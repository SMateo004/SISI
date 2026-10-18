import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { assertNotSelf } from '../common/admin/self-review';
import { ApiError } from '../common/errors/api-error';
import { RateLimitStore } from '../common/rate-limit/rate-limit.store';
import { RateLimitedException } from '../common/rate-limit/rate-limited.exception';
import type { AppConfigService } from '../config/app-config';
import type { ChatMessage, Prisma } from '../generated/prisma/client';
import { jobNotFound } from '../jobs/job-status.service';
import { ModerationService } from '../moderation/moderation.service';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { chatWindow, HELD_NOTICE } from './chat.rules';
import type {
  AdminHeldMessageDto,
  AdminHeldMessagePageDto,
  ChatMessageDto,
  ChatPageDto,
  MarkReadResultDto,
  SentMessageDto,
} from './dto/chat.dto';

const ADMIN_PAGE = 25;

interface ChatJob {
  id: string;
  cityId: string;
  workerId: string;
  employerId: string;
  status: string;
  completedAt: Date | null;
  cancelledAt: Date | null;
}

/**
 * Chat del trabajo (ADR-0031). Solo las dos partes; texto moderado mensaje por mensaje:
 * un retenido no se entrega y solo lo ve quien lo envió. La entrega (chat:message y push)
 * la hace el worker a partir del outbox.
 */
@Injectable()
export class ChatService {
  private readonly openAfterMs: number;

  constructor(
    private readonly prisma: PrismaService,
    private readonly moderation: ModerationService,
    private readonly outbox: OutboxService,
    private readonly rateLimits: RateLimitStore,
    private readonly audit: AdminAuditService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {
    this.openAfterMs = config.get('JOB_CHAT_OPEN_AFTER_MS', { infer: true });
  }

  async send(userId: string, jobId: string, rawBody: string): Promise<SentMessageDto> {
    const body = rawBody.trim();
    if (body.length === 0) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'MESSAGE_EMPTY', 'Escribe un mensaje.');
    }
    const job = await this.partyJob(userId, jobId);
    if (!chatWindow(job, Date.now(), this.openAfterMs).open) throw chatClosed();

    const decision = await this.rateLimits.consume([
      {
        key: `chat:send:user:${userId}`,
        limit: this.config.get('RATE_CHAT_PER_MIN', { infer: true }),
        windowSec: 60,
      },
    ]);
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);

    const moderation = await this.moderation.check(body);
    const message = await this.prisma.$transaction(async (tx) => {
      const created = await tx.chatMessage.create({
        data: {
          jobId,
          cityId: job.cityId,
          senderId: userId,
          body,
          status: moderation.held ? 'retenido' : 'entregado',
          moderationMatches: moderation.held
            ? (moderation.matches as unknown as Prisma.InputJsonValue)
            : undefined,
        },
      });
      if (!moderation.held) {
        await this.outbox.add(tx, 'chat.message_sent', jobId, {
          jobId,
          messageId: created.id,
        });
      }
      return created;
    });
    return Object.assign(toDto(message, userId), {
      notice: moderation.held ? HELD_NOTICE : null,
    });
  }

  /** Historial paginado, del más reciente al más antiguo. */
  async list(
    userId: string,
    jobId: string,
    cursor: string | undefined,
    limit = 30,
  ): Promise<ChatPageDto> {
    const job = await this.partyJob(userId, jobId);
    const reported = await this.prisma.report.findMany({
      where: { reporterId: userId, targetType: 'chat_message' },
      select: { targetId: true },
    });
    const visible: Prisma.ChatMessageWhereInput = {
      jobId,
      OR: [{ status: 'entregado' }, { senderId: userId }],
      // Un mensaje que reporté deja de mostrarse para mí (ADR-0033).
      ...(reported.length > 0 ? { id: { notIn: reported.map((r) => r.targetId) } } : {}),
    };
    const rows = await this.prisma.chatMessage.findMany({
      where: visible,
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, limit);
    const unread = await this.prisma.chatMessage.count({
      where: { jobId, status: 'entregado', senderId: { not: userId }, readAt: null },
    });
    const window = chatWindow(job, Date.now(), this.openAfterMs);
    return {
      items: page.map((m) => toDto(m, userId)),
      nextCursor: rows.length > limit ? (page.at(-1)?.id ?? null) : null,
      open: window.open,
      closesAt: window.closesAt?.toISOString() ?? null,
      unread,
    };
  }

  /** Marca como leídos los mensajes de la contraparte hasta ese mensaje (incluido). */
  async markRead(userId: string, jobId: string, upToId: string): Promise<MarkReadResultDto> {
    await this.partyJob(userId, jobId);
    const upTo = await this.prisma.chatMessage.findFirst({
      where: { id: upToId, jobId },
      select: { createdAt: true },
    });
    if (!upTo) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'MESSAGE_NOT_FOUND', 'El mensaje no existe.');
    }
    const { count } = await this.prisma.chatMessage.updateMany({
      where: {
        jobId,
        status: 'entregado',
        senderId: { not: userId },
        readAt: null,
        createdAt: { lte: upTo.createdAt },
      },
      data: { readAt: new Date() },
    });
    return { updated: count };
  }

  // ---- Admin (panel, Fase 6) ----

  /** Retenidos, del más antiguo al más nuevo (el que más espera, primero), 25 por página. */
  async held(cursor?: string): Promise<AdminHeldMessagePageDto> {
    const rows = await this.prisma.chatMessage.findMany({
      where: { status: 'retenido' },
      orderBy: [{ createdAt: 'asc' }, { id: 'asc' }],
      take: ADMIN_PAGE + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, ADMIN_PAGE);
    return {
      items: page.map((m) => ({
        id: m.id,
        jobId: m.jobId,
        senderId: m.senderId,
        body: m.body,
        matches: m.moderationMatches ?? [],
        createdAt: m.createdAt.toISOString(),
      })),
      nextCursor: rows.length > ADMIN_PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  /**
   * Libera un retenido (R9.2): se entrega con su hora original (chat:message y push por el
   * outbox). Auditado; nunca sobre un trabajo del propio admin.
   */
  release(ctx: AdminContext, messageId: string, reason: string): Promise<AdminHeldMessageDto> {
    return this.review(ctx, messageId, reason, 'entregado');
  }

  /** Descarta un retenido: no se entrega nunca. Quien lo envió lo sigue viendo como no enviado. */
  discard(ctx: AdminContext, messageId: string, reason: string): Promise<AdminHeldMessageDto> {
    return this.review(ctx, messageId, reason, 'descartado');
  }

  private async review(
    ctx: AdminContext,
    messageId: string,
    reason: string,
    to: 'entregado' | 'descartado',
  ): Promise<AdminHeldMessageDto> {
    const message = await this.prisma.chatMessage.findUnique({
      where: { id: messageId },
      include: { job: { select: { workerId: true, employerId: true } } },
    });
    if (!message) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'MESSAGE_NOT_FOUND', 'El mensaje no existe.');
    }
    assertNotSelf(
      ctx.adminId,
      [message.job.workerId, message.job.employerId],
      'No puedes moderar mensajes de un trabajo tuyo.',
    );
    await this.prisma.$transaction(async (tx) => {
      const { count } = await tx.chatMessage.updateMany({
        where: { id: messageId, status: 'retenido' },
        data: { status: to },
      });
      if (count === 0) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'MESSAGE_ALREADY_REVIEWED',
          'Este mensaje ya fue revisado.',
        );
      }
      if (to === 'entregado') {
        await this.outbox.add(tx, 'chat.message_sent', message.jobId, {
          jobId: message.jobId,
          messageId,
        });
      }
      await this.audit.record(tx, ctx, {
        action: to === 'entregado' ? 'moderation.chat_release' : 'moderation.chat_discard',
        targetType: 'chat_message',
        targetId: messageId,
        before: { status: 'retenido' },
        after: { status: to },
        reason,
        cityId: message.cityId,
      });
    });
    return {
      id: message.id,
      jobId: message.jobId,
      senderId: message.senderId,
      body: message.body,
      matches: message.moderationMatches ?? [],
      createdAt: message.createdAt.toISOString(),
    };
  }

  private async partyJob(userId: string, jobId: string): Promise<ChatJob> {
    const job = await this.prisma.job.findUnique({
      where: { id: jobId },
      select: {
        id: true,
        cityId: true,
        workerId: true,
        employerId: true,
        status: true,
        completedAt: true,
        cancelledAt: true,
      },
    });
    if (!job || (job.workerId !== userId && job.employerId !== userId)) throw jobNotFound();
    return job;
  }
}

const chatClosed = (): ApiError =>
  new ApiError(
    HttpStatus.CONFLICT,
    'CHAT_CLOSED',
    'El chat de este trabajo ya se cerró. Puedes leer los mensajes, pero no enviar nuevos.',
  );

function toDto(m: ChatMessage, userId: string): ChatMessageDto {
  return {
    id: m.id,
    jobId: m.jobId,
    senderId: m.senderId,
    mine: m.senderId === userId,
    body: m.body,
    // Descartado por el admin: para quien lo envió sigue siendo "no se envió".
    status: m.status === 'descartado' ? 'retenido' : m.status,
    readAt: m.readAt?.toISOString() ?? null,
    createdAt: m.createdAt.toISOString(),
  };
}
