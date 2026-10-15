import type { JobRoute } from '../queues/queues';
import type { OutboxRecord } from './outbox.events';
import { routeEvent } from './outbox.routes';

/** Resultado de procesar un lote: qué se publicó y qué falló (con su error). */
export interface BatchResult {
  published: bigint[];
  failed: { id: bigint; error: string }[];
}

/**
 * Almacén del outbox. `withBatch` toma un lote sin publicar (bloqueado para que otra
 * instancia no lo tome), llama a `handle` y guarda el resultado en la misma transacción.
 */
export interface OutboxStore {
  withBatch(
    limit: number,
    handle: (events: OutboxRecord[]) => Promise<BatchResult>,
  ): Promise<number>;
}

/** Publica un job. Debe ser idempotente por jobId (BullMQ ignora un jobId que ya existe). */
export interface JobPublisher {
  publish(route: JobRoute): Promise<void>;
}

/** Espera antes de reintentar un evento que falló: 2^intentos s, máximo 5 min. */
export const retryDelayMs = (attempts: number): number =>
  Math.min(2 ** Math.min(attempts, 20) * 1000, 5 * 60_000);

/**
 * Lógica del relay (ADR-0022), sin infraestructura: toma un lote, publica cada evento y
 * devuelve cuántos procesó. Si el proceso cae entre publicar y marcar, el evento se
 * vuelve a publicar con el mismo jobId y BullMQ no lo duplica.
 */
export class OutboxRelayCore {
  constructor(
    private readonly store: OutboxStore,
    private readonly publisher: JobPublisher,
    private readonly batchSize: number,
  ) {}

  runOnce(): Promise<number> {
    return this.store.withBatch(this.batchSize, async (events) => {
      const result: BatchResult = { published: [], failed: [] };
      for (const event of events) {
        try {
          await this.publisher.publish(routeEvent(event));
          result.published.push(event.id);
        } catch (err) {
          result.failed.push({
            id: event.id,
            error: err instanceof Error ? err.message : String(err),
          });
        }
      }
      return result;
    });
  }
}
