import { Module } from '@nestjs/common';
import { BillingDebtModule } from '../billing/billing-debt.module';
import { JobStatusModule } from '../jobs/job-status.module';
import { WorkerAvailabilityModule } from '../locations/locations.module';
import { OutboxRelayModule } from '../outbox/outbox-relay.module';
import { QueuesModule } from '../queues/queues.module';
import { RequestStatusModule } from '../requests/request-status.module';
import { ReviewPublisherModule } from '../reviews/reviews.module';
import { DEBT_CAP_POLICY, NoDebtCapYetPolicy } from './debt-cap.policy';
import { matchingConfigProvider } from './matching-config.provider';
import { MatchingEventsHandlers } from './matching-events.handlers';
import { MatchingProcessor } from './matching.processor';
import { MatchingReconciler } from './matching.reconciler';
import { MatchingRepository } from './matching.repository';
import { MatchingService } from './matching.service';

/** Jobs de matching del proceso worker (ADR-0025). */
@Module({
  imports: [
    QueuesModule,
    OutboxRelayModule,
    WorkerAvailabilityModule,
    RequestStatusModule,
    JobStatusModule,
    ReviewPublisherModule,
    BillingDebtModule,
  ],
  providers: [
    matchingConfigProvider,
    { provide: DEBT_CAP_POLICY, useClass: NoDebtCapYetPolicy },
    MatchingRepository,
    MatchingService,
    MatchingProcessor,
    MatchingReconciler,
    MatchingEventsHandlers,
  ],
  exports: [MatchingReconciler, MatchingService],
})
export class MatchingWorkerModule {}
