import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module';
import { ModerationModule } from '../moderation/moderation.module';
import { RequestStatusModule } from './request-status.module';
import { AdminRequestsController, RequestsController } from './requests.controller';
import { RequestsRepository } from './requests.repository';
import { RequestsService } from './requests.service';

@Module({
  imports: [CategoriesModule, ModerationModule, RequestStatusModule],
  controllers: [RequestsController, AdminRequestsController],
  providers: [RequestsService, RequestsRepository],
  exports: [RequestStatusModule],
})
export class RequestsModule {}
