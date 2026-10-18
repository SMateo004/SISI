import { Module } from '@nestjs/common';
import { RequestsRepository } from '../requests/requests.repository';
import { UsersModule } from '../users/users.module';
import { AdminCategoriesService } from './admin-categories.service';
import { AdminCityAreaController } from './admin-city-area.controller';
import {
  AdminCategoriesController,
  AdminCitiesController,
  CategoriesController,
} from './categories.controller';
import { CategoryResolver } from './category-resolver';
import { CityAreaService } from './city-area.service';

@Module({
  imports: [UsersModule],
  controllers: [
    CategoriesController,
    AdminCategoriesController,
    AdminCitiesController,
    AdminCityAreaController,
  ],
  // RequestsRepository es solo SQL (sin estado): la zona se prueba con la misma regla que una
  // solicitud nueva, sin depender del módulo de solicitudes.
  providers: [CategoryResolver, AdminCategoriesService, CityAreaService, RequestsRepository],
  exports: [CategoryResolver],
})
export class CategoriesModule {}
