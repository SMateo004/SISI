import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import type { OutboxRecord } from './outbox.events';
import { type BatchResult, type OutboxStore, retryDelayMs } from './outbox-relay.core';

/**
 * Outbox en Postgres. `FOR UPDATE SKIP LOCKED` permite varias instancias del worker:
 * cada una toma filas distintas y ninguna espera a la otra.
 */
@Injectable()
export class PrismaOutboxStore implements OutboxStore {
  constructor(private readonly prisma: PrismaService) {}

  withBatch(
    limit: number,
    handle: (events: OutboxRecord[]) => Promise<BatchResult>,
  ): Promise<number> {
    return this.prisma.$transaction(
      async (tx) => {
        const events = await tx.$queryRaw<OutboxRecord[]>`
          SELECT id, type, aggregate_id AS "aggregateId", payload, attempts, request_id AS "requestId"
          FROM outbox_events
          WHERE published_at IS NULL AND available_at <= now()
          ORDER BY id
          LIMIT ${limit}
          FOR UPDATE SKIP LOCKED`;
        if (events.length === 0) return 0;

        const { published, failed } = await handle(events);
        if (published.length > 0) {
          await tx.outboxEvent.updateMany({
            where: { id: { in: published } },
            data: { publishedAt: new Date() },
          });
        }
        for (const { id, error } of failed) {
          const attempts = (events.find((e) => e.id === id)?.attempts ?? 0) + 1;
          await tx.outboxEvent.update({
            where: { id },
            data: {
              attempts,
              lastError: error.slice(0, 1000),
              availableAt: new Date(Date.now() + retryDelayMs(attempts)),
            },
          });
        }
        return events.length;
      },
      // Publicar a Redis dentro de la transacción: el lote es corto, pero no 5 s.
      { timeout: 30_000 },
    );
  }
}
