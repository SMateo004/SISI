import { Module } from '@nestjs/common';
import { BillingLedgerService } from './billing-ledger.service';

/** Núcleo de cobros (ledger y periodos): lo usan la API, el worker y el cron (ADR-0034). */
@Module({
  providers: [BillingLedgerService],
  exports: [BillingLedgerService],
})
export class BillingCoreModule {}
