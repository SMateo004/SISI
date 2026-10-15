import { Injectable } from '@nestjs/common';
import type { Prisma } from '../generated/prisma/client';
import type { OutboxEventType, OutboxPayloads } from './outbox.events';

/**
 * Escribe eventos en el outbox (ADR-0022). Siempre dentro de la transacción del cambio
 * de estado: si la transacción se revierte, el evento tampoco existe.
 */
@Injectable()
export class OutboxService {
  async add<T extends OutboxEventType>(
    tx: Prisma.TransactionClient,
    type: T,
    aggregateId: string,
    payload: OutboxPayloads[T],
  ): Promise<void> {
    await tx.outboxEvent.create({
      data: { type, aggregateId, payload },
    });
  }
}
