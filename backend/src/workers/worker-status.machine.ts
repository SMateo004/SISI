import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';

/** Estados de R1.4. Lista cerrada: no se agregan estados nuevos. */
export const WORKER_STATUSES = [
  'sin_solicitar',
  'pendiente_revision',
  'aprobado',
  'rechazado',
  'bloqueado_deuda',
  'suspendido_moderacion',
] as const;
export type WorkerStatus = (typeof WORKER_STATUSES)[number];

/**
 * Eventos que mueven el estado. Quién los dispara:
 * SUBMIT (trabajador), APPROVE/REJECT (admin, Fase 6; script de desarrollo hoy),
 * BLOCK_FOR_DEBT/DEBT_PAID (billing, Fase 5), SUSPEND (3 reportes, Fase 6),
 * CONFIRM_SUSPENSION/LIFT_SUSPENSION (revisión de moderación, Fase 6).
 */
export type WorkerEvent =
  | { type: 'SUBMIT' }
  | { type: 'APPROVE' }
  | { type: 'REJECT'; reason: string }
  | { type: 'BLOCK_FOR_DEBT' }
  | { type: 'DEBT_PAID' }
  | { type: 'SUSPEND'; reason: string }
  | { type: 'CONFIRM_SUSPENSION'; resolution: string }
  | { type: 'LIFT_SUSPENSION'; resolution: string; hasOverdueDebt: boolean };

export type WorkerEventType = WorkerEvent['type'];

type Resolver<E extends WorkerEvent> = (event: E) => WorkerStatus;
type TransitionTable = {
  [T in WorkerEventType]: Partial<
    Record<WorkerStatus, Resolver<Extract<WorkerEvent, { type: T }>>>
  >;
};

/**
 * Tabla explícita de transiciones (ADR-0013). Todo lo que no figura aquí se rechaza.
 * - La suspensión tiene prioridad sobre la deuda: bloqueado_deuda → suspendido_moderacion.
 * - Confirmar la suspensión no cambia el estado (R1.4 es cerrado); solo registra la resolución.
 * - Levantar la suspensión vuelve a aprobado, salvo deuda vencida: entonces bloqueado_deuda.
 */
const TRANSITIONS: TransitionTable = {
  SUBMIT: {
    sin_solicitar: () => 'pendiente_revision',
    rechazado: () => 'pendiente_revision',
  },
  APPROVE: { pendiente_revision: () => 'aprobado' },
  REJECT: { pendiente_revision: () => 'rechazado' },
  BLOCK_FOR_DEBT: { aprobado: () => 'bloqueado_deuda' },
  DEBT_PAID: { bloqueado_deuda: () => 'aprobado' },
  SUSPEND: {
    aprobado: () => 'suspendido_moderacion',
    bloqueado_deuda: () => 'suspendido_moderacion',
  },
  CONFIRM_SUSPENSION: { suspendido_moderacion: () => 'suspendido_moderacion' },
  LIFT_SUSPENSION: {
    suspendido_moderacion: (e) => (e.hasOverdueDebt ? 'bloqueado_deuda' : 'aprobado'),
  },
};

export class WorkerTransitionError extends ApiError {
  constructor(
    readonly from: WorkerStatus,
    readonly event: WorkerEventType,
  ) {
    super(
      HttpStatus.CONFLICT,
      'WORKER_TRANSITION_NOT_ALLOWED',
      `No se puede aplicar ${event} a un perfil en estado ${from}.`,
      { from, event },
    );
  }
}

/** Calcula el siguiente estado o lanza WorkerTransitionError. Función pura. */
export function nextWorkerStatus(from: WorkerStatus, event: WorkerEvent): WorkerStatus {
  const resolver = TRANSITIONS[event.type][from] as Resolver<WorkerEvent> | undefined;
  if (!resolver) throw new WorkerTransitionError(from, event.type);
  return resolver(event);
}

export function canApply(from: WorkerStatus, type: WorkerEventType): boolean {
  return TRANSITIONS[type][from] !== undefined;
}

/** Estados en los que el trabajador no puede estar en modo worker (R1.6). */
export function forcesEmployerMode(status: WorkerStatus): boolean {
  return status === 'bloqueado_deuda' || status === 'suspendido_moderacion';
}

/** Lista de transiciones permitidas, para documentación y tests. */
export function allowedTransitions(): { from: WorkerStatus; event: WorkerEventType }[] {
  return (Object.keys(TRANSITIONS) as WorkerEventType[]).flatMap((event) =>
    (Object.keys(TRANSITIONS[event]) as WorkerStatus[]).map((from) => ({ from, event })),
  );
}
