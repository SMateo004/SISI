import { Module } from '@nestjs/common';
import { AdminBillingController } from './admin-billing.controller';
import { BillingAdminService } from './billing-admin.service';
import { BillingFilesService } from './billing-files.service';
import { BillingMeController } from './billing-me.controller';
import { NoPaymentGateway, PAYMENT_GATEWAY } from './payment-gateway';
import { BillingCoreModule } from './billing-core.module';

/** Cobros en la API (R7, R8): admin y, más adelante, las ganancias del trabajador. */
@Module({
  imports: [BillingCoreModule],
  controllers: [AdminBillingController, BillingMeController],
  providers: [
    BillingAdminService,
    BillingFilesService,
    // Pasarela automática: sin implementar, detrás del flag payments.gateway (ADR-0037).
    { provide: PAYMENT_GATEWAY, useClass: NoPaymentGateway },
  ],
})
export class BillingModule {}
