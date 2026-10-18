import { Module } from '@nestjs/common';
import { WorkerStatusModule } from '../workers/worker-status.module';
import { VerificationsController } from './verifications.controller';
import { VerificationsService } from './verifications.service';

@Module({
  imports: [WorkerStatusModule],
  controllers: [VerificationsController],
  providers: [VerificationsService],
})
export class VerificationsModule {}
