import { Inject, Injectable, Logger } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import { PrismaService } from '../prisma/prisma.service';
import { DEBT_STATUS_PROVIDER, type DebtStatusProvider } from '../workers/worker.ports';
import { WorkerStatusService } from '../workers/worker-status.service';

/** Qué hacer con el estado del trabajador según su deuda vencida (R7.7). Función pura. */
export function debtTransition(
  status: string | null,
  hasOverdueDebt: boolean,
): 'BLOCK_FOR_DEBT' | 'DEBT_PAID' | null {
  if (hasOverdueDebt && status === 'aprobado') return 'BLOCK_FOR_DEBT';
  if (!hasOverdueDebt && status === 'bloqueado_deuda') return 'DEBT_PAID';
  // Suspendido: la suspensión tiene prioridad; al levantarla se mira la deuda (ADR-0013).
  return null;
}

/**
 * Bloqueo y desbloqueo por deuda (R7.7, ADR-0038). Idempotente: mira el estado actual y
 * aplica a lo sumo una transición con WorkerStatusService (que pasa a modo employer, quita
 * la disponibilidad y avisa con account:blocked / account:unblocked).
 */
@Injectable()
export class DebtStateService {
  private readonly logger = new Logger('DebtState');

  constructor(
    private readonly prisma: PrismaService,
    private readonly status: WorkerStatusService,
    @Inject(DEBT_STATUS_PROVIDER) private readonly debts: DebtStatusProvider,
  ) {}

  async reconcile(workerId: string): Promise<'BLOCK_FOR_DEBT' | 'DEBT_PAID' | null> {
    const profile = await this.prisma.workerProfile.findUnique({
      where: { userId: workerId },
      select: { status: true },
    });
    const action = debtTransition(
      profile?.status ?? null,
      await this.debts.hasOverdueDebt(workerId),
    );
    if (!action) return null;
    try {
      await this.status.apply(workerId, { type: action }, null);
      this.logger.log(`Trabajador ${workerId}: ${action}`);
      return action;
    } catch (error) {
      // Otro proceso cambió el estado a la vez: el próximo evento o el barrido lo resuelve.
      if (error instanceof ApiError && error.getStatus() === 409) return null;
      throw error;
    }
  }

  /**
   * Respaldo periódico: trabajadores aprobados con algún periodo vencido, o bloqueados por
   * deuda sin ninguno. Cubre un evento perdido o un reintento agotado.
   */
  async sweep(): Promise<number> {
    const rows = await this.prisma.$queryRaw<{ workerId: string }[]>`
      SELECT wp.user_id AS "workerId" FROM worker_profiles wp
      WHERE (wp.status = 'aprobado' AND EXISTS (
               SELECT 1 FROM billing_periods p
               WHERE p.worker_id = wp.user_id AND p.status = 'vencido'))
         OR (wp.status = 'bloqueado_deuda' AND NOT EXISTS (
               SELECT 1 FROM billing_periods p
               WHERE p.worker_id = wp.user_id AND p.status = 'vencido'))
      LIMIT 200`;
    let changed = 0;
    for (const { workerId } of rows) {
      if (await this.reconcile(workerId)) changed += 1;
    }
    return changed;
  }
}
