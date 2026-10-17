import { Injectable, Logger } from '@nestjs/common';
import type { WorkerStatus } from './worker-status.machine';

/**
 * ¿El trabajador tiene comisión vencida? Lo implementa billing (Fase 5,
 * BillingDebtStatusProvider). NoBillingYetDebtProvider queda para pruebas aisladas.
 */
export interface DebtStatusProvider {
  hasOverdueDebt(userId: string): Promise<boolean>;
}
export const DEBT_STATUS_PROVIDER = Symbol('DEBT_STATUS_PROVIDER');

@Injectable()
export class NoBillingYetDebtProvider implements DebtStatusProvider {
  hasOverdueDebt(): Promise<boolean> {
    return Promise.resolve(false);
  }
}

/**
 * Avisos al trabajador por cambios de estado: account:blocked / account:unblocked y push
 * (Fase 5, RealtimeWorkerNotifier). LoggingWorkerNotifier queda para dev-tools.
 */
export interface WorkerNotifier {
  /** El estado obligó a pasar la cuenta a modo employer (R1.6). */
  modeForcedToEmployer(userId: string, status: WorkerStatus): Promise<void>;
  /** El estado cambió (después de confirmar la transacción). */
  statusChanged(userId: string, from: WorkerStatus, to: WorkerStatus): Promise<void>;
}
export const WORKER_NOTIFIER = Symbol('WORKER_NOTIFIER');

@Injectable()
export class LoggingWorkerNotifier implements WorkerNotifier {
  private readonly logger = new Logger('WorkerNotifier');

  modeForcedToEmployer(userId: string, status: WorkerStatus): Promise<void> {
    this.logger.log(`Usuario ${userId} pasó a modo employer por estado ${status}`);
    return Promise.resolve();
  }

  statusChanged(userId: string, from: WorkerStatus, to: WorkerStatus): Promise<void> {
    this.logger.log(`Usuario ${userId}: ${from} → ${to}`);
    return Promise.resolve();
  }
}
