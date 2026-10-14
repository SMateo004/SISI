import { Injectable, Logger } from '@nestjs/common';
import type { WorkerStatus } from './worker-status.machine';

/**
 * ¿El trabajador tiene comisión vencida? Lo implementa billing en la Fase 5.
 * Hasta entonces no existen cortes, así que nadie tiene deuda vencida.
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
 * Avisos al trabajador por cambios de estado. En la Fase 4 se conecta a push (FCM)
 * y Socket.IO (account:blocked / account:unblocked); hoy deja constancia en el log.
 */
export interface WorkerNotifier {
  /** El estado obligó a pasar la cuenta a modo employer (R1.6). */
  modeForcedToEmployer(userId: string, status: WorkerStatus): Promise<void>;
}
export const WORKER_NOTIFIER = Symbol('WORKER_NOTIFIER');

@Injectable()
export class LoggingWorkerNotifier implements WorkerNotifier {
  private readonly logger = new Logger('WorkerNotifier');

  modeForcedToEmployer(userId: string, status: WorkerStatus): Promise<void> {
    this.logger.log(
      `Usuario ${userId} pasó a modo employer por estado ${status} (aviso pendiente de Fase 4)`,
    );
    return Promise.resolve();
  }
}
