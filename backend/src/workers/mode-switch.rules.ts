import type { WorkerStatus } from './worker-status.machine';

export type ModeSwitchCode =
  | 'WORKER_NOT_REQUESTED'
  | 'WORKER_UNDER_REVIEW'
  | 'WORKER_REJECTED'
  | 'WORKER_BLOCKED_DEBT'
  | 'WORKER_SUSPENDED'
  | 'NAME_REQUIRED';

export type NextAction =
  | 'COMPLETE_VERIFICATION'
  | 'VIEW_REVIEW_STATUS'
  | 'RESUBMIT_VERIFICATION'
  | 'PAY_COMMISSION'
  | 'CONTACT_SUPPORT'
  | 'COMPLETE_PROFILE';

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

/** R1.3 ampliada (Fase 7): sin nombre no se trabaja; el empleador lo ve en cada oferta. */
export const NAME_REQUIRED: ModeSwitchDenial = {
  code: 'NAME_REQUIRED',
  message: 'Para trabajar en SISI tu cuenta tiene que tener tu nombre. Cárgalo en tu perfil.',
  nextAction: 'COMPLETE_PROFILE',
  actionLabel: 'Completar mi perfil',
};

export type ModeSwitchDecision = { allowed: true } | ({ allowed: false } & ModeSwitchDenial);

/**
 * R1.5 y R1.6: a employer siempre se puede cambiar; a worker solo con estado aprobado y, desde
 * la Fase 7 (R1.3 ampliada), con el nombre cargado. Primero el estado: un perfil sin aprobar
 * tiene otro camino (la solicitud, que también pide el nombre).
 * `status` null = la persona nunca solicitó el upgrade (equivale a sin_solicitar).
 */
export function decideModeSwitch(
  target: 'employer' | 'worker',
  status: WorkerStatus | null,
  hasName = true,
): ModeSwitchDecision {
  if (target === 'employer') return { allowed: true };
  const current = status ?? 'sin_solicitar';
  if (current !== 'aprobado') return { allowed: false, ...DENIALS[current] };
  if (!hasName) return { allowed: false, ...NAME_REQUIRED };
  return { allowed: true };
}

/** Un nombre cargado (PATCH /me exige 2 letras; una cuenta eliminada queda sin nombre). */
export const hasName = (name: string | null | undefined): boolean =>
  (name?.trim().length ?? 0) >= 2;
