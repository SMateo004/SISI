/**
 * Colas de BullMQ del proceso worker (ADR-0022). Los jobId son determinísticos: publicar
 * dos veces el mismo job no lo duplica mientras el job siga guardado en Redis.
 *
 * BullMQ no acepta ":" en ids propios (salvo con exactamente 3 partes), por eso "_".
 */
export const QUEUES = {
  /** Anillos, cierre y expiración de solicitudes, y el reconciliador. */
  matching: 'matching',
  /** Eventos de dominio que no son del matching (avisos, push, tiempo real). */
  events: 'events',
} as const;

export type QueueName = (typeof QUEUES)[keyof typeof QUEUES];

export const MATCHING_JOBS = {
  ring: 'ring',
  /** Fin de la búsqueda: expira o da plazo para elegir (R4.5). */
  close: 'close',
  /** Vence el plazo para elegir entre las ofertas. */
  expire: 'expire',
  reconcile: 'reconcile',
  /** Barrido de ubicaciones vencidas (ADR-0024). */
  sweepLocations: 'sweep_locations',
  /** Limpieza de eventos publicados del outbox (ADR-0022). */
  outboxCleanup: 'outbox_cleanup',
  /** Retención de datos, una vez por día si está encendida (ADR-0050). */
  retention: 'retention',
  /** Autoconfirmación de un trabajo (ADR-0029). */
  autoconfirm: 'autoconfirm',
} as const;

export const jobIds = {
  ring: (requestId: string, ring: number): string => `ring_${requestId}_${ring}`,
  close: (requestId: string, seq: number): string => `close_${requestId}_${seq}`,
  expire: (requestId: string, seq: number): string => `expire_${requestId}_${seq}`,
  event: (outboxId: bigint): string => `evt_${outboxId}`,
  autoconfirm: (jobId: string): string => `autoconfirm_${jobId}`,
};

/** Un job listo para encolar. */
export interface JobRoute {
  queue: QueueName;
  name: string;
  jobId: string;
  data: Record<string, unknown>;
  delayMs?: number;
}
