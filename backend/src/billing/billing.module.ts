import { Module } from '@nestjs/common';
import { AdminBillingController } from './admin-billing.controller';
import { BillingAdminService } from './billing-admin.service';
import { BillingFilesService } from './billing-files.service';
import { BillingMeController } from './billing-me.controller';
import { NoPaymentGateway, PAYMENT_GATEWAY } from './payment-gateway';
import { BillingCapModule } from './billing-cap.module';
import { BillingCoreModule } from './billing-core.module';
import { EarningsController } from './earnings.controller';
import { EarningsService } from './earnings.service';

/** Cobros en la API (R7, R8): admin y, más adelante, las ganancias del trabajador. */
@Module({
  imports: [BillingCoreModule, BillingCapModule],
  controllers: [AdminBillingController, BillingMeController, EarningsController],
  providers: [
    BillingAdminService,
    BillingFilesService,
    EarningsService,
    // Pasarela automática: sin implementar, detrás del flag payments.gateway (ADR-0037).
    { provide: PAYMENT_GATEWAY, useClass: NoPaymentGateway },
  ],
})
export class BillingModule {}
