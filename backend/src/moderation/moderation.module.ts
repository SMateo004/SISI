import { Module } from '@nestjs/common';
import { ModerationTermsController } from './moderation-terms.controller';
import { ModerationService } from './moderation.service';

@Module({
  controllers: [ModerationTermsController],
  providers: [ModerationService],
  exports: [ModerationService],
})
export class ModerationModule {}
