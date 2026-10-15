import { jobIds, type JobRoute, MATCHING_JOBS, QUEUES } from '../queues/queues';

/** Lo que el reconciliador necesita saber de una solicitud abierta. */
export interface OpenRequestState {
  id: string;
  status: 'buscando' | 'con_ofertas';
  ring: number | null;
}

/**
 * Qué job de matching debe existir para una solicitud abierta (ADR-0022). Si no existe,
 * el reconciliador lo vuelve a encolar con el mismo jobId que usa el flujo normal.
 */
export function expectedMatchingJob(request: OpenRequestState): JobRoute | null {
  if (request.ring === null) {
    return {
      queue: QUEUES.matching,
      name: MATCHING_JOBS.ring,
      jobId: jobIds.ring(request.id, 1),
      data: { requestId: request.id, ring: 1 },
    };
  }
  return null;
}
