import { Injectable } from '@nestjs/common';

/**
 * Tope de deuda (R7.5): quien supera el tope no recibe solicitudes. Lo implementa billing
 * (DebtCapService, ADR-0038). Recibe un lote para no consultar trabajador por trabajador.
 * NoDebtCapYetPolicy queda para pruebas aisladas.
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
