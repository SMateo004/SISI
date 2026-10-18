import { Injectable } from '@nestjs/common';
import type { OutboxEventType, OutboxPayloads } from './outbox.events';

/** Datos de un evento tal como llegan al handler en el worker. */
export interface DomainEvent<T extends OutboxEventType> {
  outboxId: string;
  aggregateId: string;
  payload: OutboxPayloads[T];
  /** Id de correlación de la petición de origen, si la hubo (ADR-0048). */
  requestId?: string;
}

type Handler<T extends OutboxEventType> = (event: DomainEvent<T>) => Promise<void>;

/**
 * Registro de handlers de la cola de eventos (worker). Cada módulo registra los suyos en
 * onModuleInit. Los handlers deben ser idempotentes: un evento puede llegar más de una vez.
 */
@Injectable()
export class EventHandlersRegistry {
  private readonly handlers = new Map<string, Handler<OutboxEventType>[]>();

  on<T extends OutboxEventType>(type: T, handler: Handler<T>): void {
    const list = this.handlers.get(type) ?? [];
    list.push(handler as unknown as Handler<OutboxEventType>);
    this.handlers.set(type, list);
  }

  async dispatch(type: string, event: DomainEvent<OutboxEventType>): Promise<number> {
    const list = this.handlers.get(type) ?? [];
    for (const handler of list) await handler(event);
    return list.length;
  }
}
