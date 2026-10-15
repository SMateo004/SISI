import { Global, Module } from '@nestjs/common';
import { OutboxService } from './outbox.service';

/** Escritura en el outbox (API y worker). La publicación la hace OutboxRelayModule. */
@Global()
@Module({
  providers: [OutboxService],
  exports: [OutboxService],
})
export class OutboxModule {}
