import { Module } from '@nestjs/common';
import { ModerationModule } from '../moderation/moderation.module';
import { ReviewPublisher } from './review-publisher.service';
import { ReviewsController } from './reviews.controller';
import { ReviewsService } from './reviews.service';

/** Publicación de calificaciones y promedios (API y worker, ADR-0032). */
@Module({
  providers: [ReviewPublisher],
  exports: [ReviewPublisher],
})
export class ReviewPublisherModule {}

/** Calificaciones en la API (R6.2, ADR-0032). */
@Module({
  imports: [ModerationModule, ReviewPublisherModule],
  controllers: [ReviewsController],
  providers: [ReviewsService],
})
export class ReviewsModule {}
