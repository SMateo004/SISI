import { jobIds, type JobRoute, MATCHING_JOBS, QUEUES } from '../queues/queues';

/** Lo que el reconciliador necesita saber de una solicitud abierta. */
export interface OpenRequestState {
  id: string;
  status: 'buscando' | 'con_ofertas';
  ring: number | null;
  ringStartedAt: Date | null;
  expiresAt: Date | null;
  closeSeq: number;
}

/**
 * Qué job de matching debe existir para una solicitud abierta (ADR-0022, ADR-0025). Si no
 * existe, el reconciliador lo vuelve a encolar con el mismo jobId que usa el flujo normal,
 * y con la espera que le queda según la base.
 */
export function expectedMatchingJob(
  request: OpenRequestState,
  ctx: { totalRings: number; ringWaitMs: number; now: number },
): JobRoute {
  const data = { requestId: request.id };
  const seq = request.closeSeq;
  if (request.expiresAt) {
    return {
      queue: QUEUES.matching,
      name: MATCHING_JOBS.expire,
      jobId: jobIds.expire(request.id, seq),
      data: { ...data, seq },
      delayMs: Math.max(request.expiresAt.getTime() - ctx.now, 0),
    };
  }
  if (request.ring === null) {
    return {
      queue: QUEUES.matching,
      name: MATCHING_JOBS.ring,
      jobId: jobIds.ring(request.id, 1),
      data: { ...data, ring: 1 },
    };
  }
  const remaining = request.ringStartedAt
    ? Math.max(request.ringStartedAt.getTime() + ctx.ringWaitMs - ctx.now, 0)
    : 0;
  if (request.ring < ctx.totalRings) {
    const ring = request.ring + 1;
    return {
      queue: QUEUES.matching,
      name: MATCHING_JOBS.ring,
      jobId: jobIds.ring(request.id, ring),
      data: { ...data, ring },
      delayMs: remaining,
    };
  }
  return {
    queue: QUEUES.matching,
    name: MATCHING_JOBS.close,
    jobId: jobIds.close(request.id, seq),
    data: { ...data, seq },
    delayMs: remaining,
  };
}
