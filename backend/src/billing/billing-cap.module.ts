import { Module } from '@nestjs/common';
import { DEBT_CAP_POLICY } from '../matching/debt-cap.policy';
import { DebtCapService } from './debt-cap.service';

/** Tope de deuda (R7.5, ADR-0038): implementa el hook del matching y de las ofertas. */
@Module({
  providers: [DebtCapService, { provide: DEBT_CAP_POLICY, useExisting: DebtCapService }],
  exports: [DebtCapService, DEBT_CAP_POLICY],
})
export class BillingCapModule {}
