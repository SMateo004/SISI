import { Module } from '@nestjs/common';
import { AdminBillingController } from './admin-billing.controller';
import { BillingAdminService } from './billing-admin.service';
import { BillingCoreModule } from './billing-core.module';

/** Cobros en la API (R7, R8): admin y, más adelante, las ganancias del trabajador. */
@Module({
  imports: [BillingCoreModule],
  controllers: [AdminBillingController],
  providers: [BillingAdminService],
})
export class BillingModule {}
