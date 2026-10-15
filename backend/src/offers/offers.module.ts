import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module';
import { DEBT_CAP_POLICY, NoDebtCapYetPolicy } from '../matching/debt-cap.policy';
import { matchingConfigProvider } from '../matching/matching-config.provider';
import { RequestStatusModule } from '../requests/request-status.module';
import { OffersController } from './offers.controller';
import { OffersRepository } from './offers.repository';
import { OffersService } from './offers.service';

/** Ofertas, aceptación y contacto (R5, ADR-0026). */
@Module({
  imports: [CategoriesModule, RequestStatusModule],
  controllers: [OffersController],
  providers: [
    OffersService,
    OffersRepository,
    matchingConfigProvider,
    { provide: DEBT_CAP_POLICY, useClass: NoDebtCapYetPolicy },
  ],
})
export class OffersModule {}
