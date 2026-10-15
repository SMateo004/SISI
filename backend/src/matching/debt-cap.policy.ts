import { Injectable } from '@nestjs/common';

/**
 * Tope de deuda (R7.5): quien supera el tope antes del corte no recibe solicitudes. Lo
 * implementa billing en la Fase 5; hasta entonces no hay comisiones, así que todos son
 * elegibles. Recibe un lote para no consultar trabajador por trabajador.
 */
export interface DebtCapPolicy {
  ineligible(workerIds: string[]): Promise<Set<string>>;
}

export const DEBT_CAP_POLICY = Symbol('DEBT_CAP_POLICY');

@Injectable()
export class NoDebtCapYetPolicy implements DebtCapPolicy {
  ineligible(): Promise<Set<string>> {
    return Promise.resolve(new Set());
  }
}
