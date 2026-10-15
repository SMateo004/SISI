import { Module } from '@nestjs/common';
import { CategoriesModule } from '../categories/categories.module';
import { ModerationModule } from '../moderation/moderation.module';
import { RequestStatusService } from './request-status.service';
import { AdminRequestsController, RequestsController } from './requests.controller';
import { RequestsRepository } from './requests.repository';
import { RequestsService } from './requests.service';

@Module({
  imports: [CategoriesModule, ModerationModule],
  controllers: [RequestsController, AdminRequestsController],
  providers: [RequestsService, RequestsRepository, RequestStatusService],
  exports: [RequestStatusService],
})
export class RequestsModule {}
