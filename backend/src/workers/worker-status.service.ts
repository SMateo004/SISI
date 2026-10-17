import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { Prisma, WorkerProfile } from '../generated/prisma/client';
import { WorkerAvailabilityService } from '../locations/worker-availability.service';
import { PrismaService } from '../prisma/prisma.service';
import {
  DEBT_STATUS_PROVIDER,
  type DebtStatusProvider,
  WORKER_NOTIFIER,
  type WorkerNotifier,
} from './worker.ports';
import { forcesEmployerMode, nextWorkerStatus, type WorkerEvent } from './worker-status.machine';

/** LIFT_SUSPENSION llega sin hasOverdueDebt: lo resuelve el servicio consultando billing. */
export type WorkerEventInput =
  | Exclude<WorkerEvent, { type: 'LIFT_SUSPENSION' }>
  | { type: 'LIFT_SUSPENSION'; resolution: string };

export interface StatusChange {
  profile: WorkerProfile;
  /** La cuenta estaba en modo worker y se pasó a employer (R1.6). */
  modeForcedToEmployer: boolean;
}

/**
 * Único punto que cambia worker_profiles.status (ADR-0013). En una transacción:
 * valida con la máquina de estados, actualiza con control de concurrencia, registra
 * el evento en worker_status_events y, si corresponde, pasa la cuenta a employer.
 */
@Injectable()
export class WorkerStatusService {
  constructor(
    private readonly prisma: PrismaService,
    @Inject(DEBT_STATUS_PROVIDER) private readonly debts: DebtStatusProvider,
    @Inject(WORKER_NOTIFIER) private readonly notifier: WorkerNotifier,
    private readonly availability: WorkerAvailabilityService,
  ) {}

  async apply(
    userId: string,
    input: WorkerEventInput,
    actorId: string | null,
    /** Cambios extra que deben quedar en la misma transacción (p. ej. datos del upgrade). */
    alsoInTransaction?: (tx: Prisma.TransactionClient) => Promise<void>,
  ): Promise<StatusChange> {
    const event: WorkerEvent =
      input.type === 'LIFT_SUSPENSION'
        ? { ...input, hasOverdueDebt: await this.debts.hasOverdueDebt(userId) }
        : input;

    const change = await this.prisma.$transaction(async (tx) => {
      const current =
        (await tx.workerProfile.findUnique({ where: { userId } })) ??
        (await tx.workerProfile.create({ data: { userId } }));
      const next = nextWorkerStatus(current.status, event);
      const now = new Date();
      if (alsoInTransaction) await alsoInTransaction(tx);

      const { count } = await tx.workerProfile.updateMany({
        where: { userId, status: current.status },
        data: { status: next, statusChangedAt: now, ...fieldsFor(event, actorId, now) },
      });
      if (count === 0) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'WORKER_STATUS_CHANGED',
          'El estado del perfil cambió mientras se procesaba. Intenta de nuevo.',
        );
      }

      await tx.workerStatusEvent.create({
        data: {
          workerId: userId,
          event: event.type,
          fromStatus: current.status,
          toStatus: next,
          reason: reasonOf(event),
          actorId,
        },
      });

      // Fuera de "aprobado" no recibe solicitudes (R4.1, ADR-0024).
      if (next !== 'aprobado') await this.availability.markUnavailable(tx, userId);

      let modeForcedToEmployer = false;
      if (forcesEmployerMode(next)) {
        const forced = await tx.user.updateMany({
          where: { id: userId, activeMode: 'worker' },
          data: { activeMode: 'employer' },
        });
        modeForcedToEmployer = forced.count > 0;
      }

      const profile = await tx.workerProfile.findUniqueOrThrow({ where: { userId } });
      return { profile, modeForcedToEmployer, from: current.status };
    });

    if (change.modeForcedToEmployer) {
      await this.notifier.modeForcedToEmployer(userId, change.profile.status);
    }
    if (change.from !== change.profile.status) {
      await this.notifier.statusChanged(userId, change.from, change.profile.status);
    }
    return { profile: change.profile, modeForcedToEmployer: change.modeForcedToEmployer };
  }
}

function fieldsFor(
  event: WorkerEvent,
  actorId: string | null,
  now: Date,
): Prisma.WorkerProfileUpdateManyMutationInput & { reviewedById?: string | null } {
  switch (event.type) {
    case 'SUBMIT':
      return { submittedAt: now };
    case 'APPROVE':
      return { reviewedAt: now, reviewedById: actorId, rejectionReason: null };
    case 'REJECT':
      return { reviewedAt: now, reviewedById: actorId, rejectionReason: event.reason };
    case 'CONFIRM_SUSPENSION':
    case 'LIFT_SUSPENSION':
      return { moderationResolution: event.resolution };
    default:
      return {};
  }
}

function reasonOf(event: WorkerEvent): string | null {
  switch (event.type) {
    case 'REJECT':
    case 'SUSPEND':
      return event.reason;
    case 'CONFIRM_SUSPENSION':
    case 'LIFT_SUSPENSION':
      return event.resolution;
    default:
      return null;
  }
}
