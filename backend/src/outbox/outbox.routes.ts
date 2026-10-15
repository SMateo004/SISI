import { jobIds, type JobRoute, MATCHING_JOBS, QUEUES } from '../queues/queues';
import type { OutboxRecord } from './outbox.events';

/**
 * A qué job va cada evento del outbox (ADR-0022).
 * - request.searching arranca el anillo 1 con el mismo jobId que usa el reconciliador
 *   (`ring_{id}_1`): relay y reconciliador convergen en un solo job.
 * - El resto va a la cola de eventos con un jobId derivado del id del outbox.
 */
export function routeEvent(event: OutboxRecord): JobRoute {
  if (event.type === 'request.searching') {
    return {
      queue: QUEUES.matching,
      name: MATCHING_JOBS.ring,
      jobId: jobIds.ring(event.aggregateId, 1),
      data: { requestId: event.aggregateId, ring: 1 },
    };
  }
  return {
    queue: QUEUES.events,
    name: event.type,
    jobId: jobIds.event(event.id),
    data: {
      outboxId: event.id.toString(),
      aggregateId: event.aggregateId,
      payload: event.payload,
    },
  };
}
