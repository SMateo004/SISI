import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';

/** Estados de R6.1. Lista cerrada. */
export const JOB_STATUSES = [
  'asignado',
  'en_camino',
  'en_curso',
  'terminado',
  'cancelado',
] as const;
export type JobStatus = (typeof JOB_STATUSES)[number];

export type JobActorRole = 'worker' | 'employer' | 'system' | 'admin';

/**
 * Acciones sobre un trabajo (ADR-0029) y quién puede hacerlas:
 * START_TRIP / START_WORK: el trabajador (asignado → en_camino → en_curso).
 * FINISH: el trabajador marca "Terminé", solo en curso; no cambia el estado.
 * CONFIRM: el empleador confirma el término (R6.2) → terminado.
 * AUTO_CONFIRM: el sistema, pasado el plazo desde FINISH y sin disputa → terminado.
 * DISPUTE: el empleador reporta un problema después de FINISH; frena la autoconfirmación.
 * RESOLVE_CONFIRM / RESOLVE_CANCEL: el admin resuelve una disputa.
 * CANCEL: cualquiera de las dos partes antes de empezar (asignado o en camino).
 */
export const JOB_ACTIONS = [
  'START_TRIP',
  'START_WORK',
  'FINISH',
  'CONFIRM',
  'AUTO_CONFIRM',
  'DISPUTE',
  'RESOLVE_CONFIRM',
  'RESOLVE_CANCEL',
  'CANCEL',
] as const;
export type JobAction = (typeof JOB_ACTIONS)[number];

/** Lo que importa del trabajo para decidir. */
export interface JobSnapshot {
  status: JobStatus;
  workerFinishedAt: Date | null;
  disputedAt: Date | null;
}

interface Rule {
  actors: readonly JobActorRole[];
  from: readonly JobStatus[];
  to: JobStatus | 'same';
  /** Condición extra sobre el trabajo; si falla, el mensaje del 409. */
  guard?: (job: JobSnapshot) => string | null;
  /** Mensaje cuando el estado no corresponde. */
  wrongState: string;
}

const notDisputed = (job: JobSnapshot): string | null =>
  job.disputedAt ? 'El trabajo está en revisión por un problema reportado.' : null;

const RULES: Record<JobAction, Rule> = {
  START_TRIP: {
    actors: ['worker'],
    from: ['asignado'],
    to: 'en_camino',
    wrongState: 'Ya saliste hacia este trabajo.',
  },
  START_WORK: {
    actors: ['worker'],
    from: ['en_camino'],
    to: 'en_curso',
    wrongState: 'Primero marca que vas en camino.',
  },
  FINISH: {
    actors: ['worker'],
    from: ['en_curso'],
    to: 'same',
    guard: (job) =>
      job.workerFinishedAt ? 'Ya marcaste el trabajo como terminado.' : notDisputed(job),
    wrongState: 'Solo puedes marcar terminado un trabajo en curso.',
  },
  CONFIRM: {
    actors: ['employer'],
    from: ['en_curso'],
    to: 'terminado',
    guard: notDisputed,
    wrongState: 'Solo puedes confirmar un trabajo en curso.',
  },
  AUTO_CONFIRM: {
    actors: ['system'],
    from: ['en_curso'],
    to: 'terminado',
    guard: (job) => (job.workerFinishedAt ? notDisputed(job) : 'El trabajador no marcó terminado.'),
    wrongState: 'El trabajo ya no está en curso.',
  },
  DISPUTE: {
    actors: ['employer'],
    from: ['en_curso'],
    to: 'same',
    guard: (job) =>
      !job.workerFinishedAt
        ? 'Puedes reportar un problema cuando el trabajador marque terminado.'
        : job.disputedAt
          ? 'Ya reportaste un problema con este trabajo.'
          : null,
    wrongState: 'Solo puedes reportar un problema de un trabajo en curso.',
  },
  RESOLVE_CONFIRM: {
    actors: ['admin'],
    from: ['en_curso'],
    to: 'terminado',
    guard: (job) => (job.disputedAt ? null : 'El trabajo no tiene una disputa abierta.'),
    wrongState: 'El trabajo ya no está en curso.',
  },
  RESOLVE_CANCEL: {
    actors: ['admin'],
    from: ['en_curso'],
    to: 'cancelado',
    guard: (job) => (job.disputedAt ? null : 'El trabajo no tiene una disputa abierta.'),
    wrongState: 'El trabajo ya no está en curso.',
  },
  CANCEL: {
    actors: ['worker', 'employer'],
    from: ['asignado', 'en_camino'],
    to: 'cancelado',
    wrongState: 'Un trabajo en curso o terminado ya no se puede cancelar.',
  },
};

export class JobTransitionError extends ApiError {
  constructor(
    readonly from: JobStatus,
    readonly action: JobAction,
    message: string,
  ) {
    super(HttpStatus.CONFLICT, 'JOB_TRANSITION_NOT_ALLOWED', message, { from, action });
  }
}

export class JobActionForbiddenError extends ApiError {
  constructor(readonly action: JobAction) {
    super(HttpStatus.FORBIDDEN, 'JOB_ACTION_FORBIDDEN', 'No puedes hacer esto en este trabajo.', {
      action,
    });
  }
}

/** Siguiente estado, o error 403 (actor) / 409 (estado o condición). Función pura. */
export function nextJobStatus(job: JobSnapshot, action: JobAction, actor: JobActorRole): JobStatus {
  const rule = RULES[action];
  if (!rule.actors.includes(actor)) throw new JobActionForbiddenError(action);
  if (!rule.from.includes(job.status))
    throw new JobTransitionError(job.status, action, rule.wrongState);
  const blocked = rule.guard?.(job);
  if (blocked) throw new JobTransitionError(job.status, action, blocked);
  return rule.to === 'same' ? job.status : rule.to;
}

export function canApplyJob(job: JobSnapshot, action: JobAction, actor: JobActorRole): boolean {
  const rule = RULES[action];
  return rule.actors.includes(actor) && rule.from.includes(job.status) && !rule.guard?.(job);
}

/** Acciones que esa parte puede hacer ahora (para la app). */
export function allowedJobActions(job: JobSnapshot, actor: JobActorRole): JobAction[] {
  return JOB_ACTIONS.filter((action) => canApplyJob(job, action, actor));
}

/** Activo = ocupa al trabajador (el matching lo excluye). */
export const ACTIVE_JOB_STATUSES: readonly JobStatus[] = ['asignado', 'en_camino', 'en_curso'];
