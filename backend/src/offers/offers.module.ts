import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module';
import { BillingCapModule } from '../billing/billing-cap.module';
import { matchingConfigProvider } from '../matching/matching-config.provider';
import { RequestStatusModule } from '../requests/request-status.module';
import { OffersController } from './offers.controller';
import { OffersRepository } from './offers.repository';
import { OffersService } from './offers.service';

/** Ofertas, aceptación y contacto (R5, ADR-0026). */
@Module({
  imports: [CategoriesModule, RequestStatusModule, BillingCapModule],
  controllers: [OffersController],
  providers: [OffersService, OffersRepository, matchingConfigProvider],
})
export class OffersModule {}
