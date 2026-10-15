import { Inject, Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import {
  type NotificationInputs,
  type NotificationType,
  renderNotification,
} from './notification-texts';
import { PUSH_PROVIDER, type PushProvider } from './push/push-provider';

export interface NotifyInput<T extends NotificationType> {
  userId: string;
  cityId: string;
  type: T;
  data: NotificationInputs[T];
  /** Único por aviso (p. ej. id del evento del outbox + destinatario): reintentar no duplica. */
  dedupeKey: string;
}

/**
 * Avisos al usuario (ADR-0027): guarda la notificación y la envía por push a sus
 * dispositivos. Idempotente: si el job se reintenta, no duplica la fila ni reenvía un
 * push ya enviado. Los tokens que FCM declara inválidos se borran.
 */
@Injectable()
export class NotificationsService {
  private readonly logger = new Logger('Notifications');

  constructor(
    private readonly prisma: PrismaService,
    @Inject(PUSH_PROVIDER) private readonly push: PushProvider,
  ) {}

  async notify<T extends NotificationType>(input: NotifyInput<T>): Promise<void> {
    const text = renderNotification(input.type, input.data);
    const payload = { ...input.data, type: input.type, route: text.route };
    await this.prisma.notification.createMany({
      data: [
        {
          userId: input.userId,
          cityId: input.cityId,
          type: input.type,
          title: text.title,
          body: text.body,
          payload,
          dedupeKey: input.dedupeKey,
        },
      ],
      skipDuplicates: true,
    });
    const notification = await this.prisma.notification.findUniqueOrThrow({
      where: { dedupeKey: input.dedupeKey },
    });
    if (notification.pushSentAt) return;

    const devices = await this.prisma.deviceToken.findMany({
      where: { userId: input.userId },
      select: { token: true },
    });
    if (devices.length > 0) {
      const results = await this.push.send(
        devices.map((d) => d.token),
        {
          title: text.title,
          body: text.body,
          data: toStringMap({ ...payload, notificationId: notification.id }),
        },
      );
      const invalid = results.filter((r) => r.invalidToken).map((r) => r.token);
      if (invalid.length > 0) {
        await this.prisma.deviceToken.deleteMany({ where: { token: { in: invalid } } });
        this.logger.log(`Se borraron ${invalid.length} tokens de push inválidos`);
      }
    }
    await this.prisma.notification.update({
      where: { id: notification.id },
      data: { pushSentAt: new Date() },
    });
  }
}

/** FCM solo admite strings en `data`. */
function toStringMap(data: Record<string, unknown>): Record<string, string> {
  return Object.fromEntries(
    Object.entries(data).map(([k, v]) => [k, typeof v === 'string' ? v : JSON.stringify(v)]),
  );
}
