import { Module } from '@nestjs/common';
import { UsersModule } from '../users/users.module';
import { AdminCategoriesService } from './admin-categories.service';
import { AdminCategoriesController, CategoriesController } from './categories.controller';
import { CategoryResolver } from './category-resolver';

@Module({
  imports: [UsersModule],
  controllers: [CategoriesController, AdminCategoriesController],
  providers: [CategoryResolver, AdminCategoriesService],
  exports: [CategoryResolver],
})
export class CategoriesModule {}
