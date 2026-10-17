import { Injectable, type OnModuleInit } from '@nestjs/common';
import { NotificationsService } from '../notifications/notifications.service';
import { shortName } from '../offers/offer.rules';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { PrismaService } from '../prisma/prisma.service';
import { PresenceService } from '../realtime/presence.service';
import { RealtimeEmitter } from '../realtime/realtime.emitter';
import { chatPreview } from './chat.rules';

/**
 * Entrega del chat en el worker (ADR-0031): chat:message a las dos partes (así lo ven
 * también los otros dispositivos de quien lo envió) y, si el destinatario no está
 * conectado, aviso con push. Idempotente: el aviso se deduplica por outboxId.
 */
@Injectable()
export class ChatEventsHandlers implements OnModuleInit {
  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly prisma: PrismaService,
    private readonly realtime: RealtimeEmitter,
    private readonly presence: PresenceService,
    private readonly notifications: NotificationsService,
  ) {}

  onModuleInit(): void {
    this.registry.on('chat.message_sent', async ({ outboxId, payload }) => {
      const message = await this.prisma.chatMessage.findUniqueOrThrow({
        where: { id: payload.messageId },
        include: { job: { select: { workerId: true, employerId: true, cityId: true } } },
      });
      if (message.status !== 'entregado') return;
      const { job } = message;
      const recipientId = message.senderId === job.workerId ? job.employerId : job.workerId;
      this.realtime.toUsers([recipientId, message.senderId], 'chat:message', {
        jobId: message.jobId,
        messageId: message.id,
        senderId: message.senderId,
        body: message.body,
        createdAt: message.createdAt.toISOString(),
      });

      if (await this.presence.isOnline(recipientId)) return;
      const sender = await this.prisma.user.findUniqueOrThrow({
        where: { id: message.senderId },
        select: { name: true },
      });
      await this.notifications.notify({
        userId: recipientId,
        cityId: job.cityId,
        type: 'chat_message',
        data: {
          jobId: message.jobId,
          senderShortName: shortName(sender.name),
          preview: chatPreview(message.body),
        },
        dedupeKey: `${outboxId}:${recipientId}`,
      });
    });
  }
}
