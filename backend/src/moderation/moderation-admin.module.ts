import { Module } from '@nestjs/common';
import { ModerationTermsController } from './moderation-terms.controller';
import { ModerationTermsService } from './moderation-terms.service';
import { ModerationModule } from './moderation.module';

/** Términos del filtro en el panel (solo la API: audita con AdminAuditService). */
@Module({
  imports: [ModerationModule],
  controllers: [ModerationTermsController],
  providers: [ModerationTermsService],
})
export class ModerationAdminModule {}
