import type { WorkerStatus } from './worker-status.machine';

export type ModeSwitchCode =
  | 'WORKER_NOT_REQUESTED'
  | 'WORKER_UNDER_REVIEW'
  | 'WORKER_REJECTED'
  | 'WORKER_BLOCKED_DEBT'
  | 'WORKER_SUSPENDED';

export type NextAction =
  | 'COMPLETE_VERIFICATION'
  | 'VIEW_REVIEW_STATUS'
  | 'RESUBMIT_VERIFICATION'
  | 'PAY_COMMISSION'
  | 'CONTACT_SUPPORT';

export interface ModeSwitchDenial {
  code: ModeSwitchCode;
  message: string;
  nextAction: NextAction;
  /** Texto del botón de la acción siguiente en la app. */
  actionLabel: string;
}

const DENIALS: Record<Exclude<WorkerStatus, 'aprobado'>, ModeSwitchDenial> = {
  sin_solicitar: {
    code: 'WORKER_NOT_REQUESTED',
    message: 'Para trabajar en SISI primero tienes que verificar tu identidad.',
    nextAction: 'COMPLETE_VERIFICATION',
    actionLabel: 'Completa tu verificación',
  },
  pendiente_revision: {
    code: 'WORKER_UNDER_REVIEW',
    message: 'Tu solicitud está en revisión. Te avisaremos cuando esté lista.',
    nextAction: 'VIEW_REVIEW_STATUS',
    actionLabel: 'Ver el estado de tu solicitud',
  },
  rechazado: {
    code: 'WORKER_REJECTED',
    message: 'Tu solicitud fue rechazada. Revisa el motivo y vuelve a enviarla.',
    nextAction: 'RESUBMIT_VERIFICATION',
    actionLabel: 'Corregir y reenviar',
  },
  bloqueado_deuda: {
    code: 'WORKER_BLOCKED_DEBT',
    message: 'Tienes una comisión vencida. Págala para volver a recibir trabajos.',
    nextAction: 'PAY_COMMISSION',
    actionLabel: 'Paga tu comisión pendiente',
  },
  suspendido_moderacion: {
    code: 'WORKER_SUSPENDED',
    message: 'Tu cuenta de trabajador está suspendida mientras revisamos un reporte.',
    nextAction: 'CONTACT_SUPPORT',
    actionLabel: 'Contactar a soporte',
  },
};

export type ModeSwitchDecision = { allowed: true } | ({ allowed: false } & ModeSwitchDenial);

/**
 * R1.5 y R1.6: a employer siempre se puede cambiar; a worker solo con estado aprobado.
 * `status` null = la persona nunca solicitó el upgrade (equivale a sin_solicitar).
 */
export function decideModeSwitch(
  target: 'employer' | 'worker',
  status: WorkerStatus | null,
): ModeSwitchDecision {
  if (target === 'employer') return { allowed: true };
  const current = status ?? 'sin_solicitar';
  if (current === 'aprobado') return { allowed: true };
  return { allowed: false, ...DENIALS[current] };
}
