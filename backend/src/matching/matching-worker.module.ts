import { Module } from '@nestjs/common';
import { QueuesModule } from '../queues/queues.module';
import { MatchingProcessor } from './matching.processor';
import { MatchingReconciler } from './matching.reconciler';

/** Jobs de matching del proceso worker (ADR-0025). */
@Module({
  imports: [QueuesModule],
  providers: [MatchingProcessor, MatchingReconciler],
  exports: [MatchingReconciler],
})
export class MatchingWorkerModule {}
