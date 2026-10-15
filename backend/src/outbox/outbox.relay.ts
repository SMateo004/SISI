import {
  Inject,
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type BeforeApplicationShutdown,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { BullJobPublisher } from '../queues/bull-job.publisher';
import { OutboxRelayCore } from './outbox-relay.core';
import { PrismaOutboxStore } from './prisma-outbox.store';

/**
 * Relay del outbox en el proceso worker (ADR-0022). Revisa la tabla cada OUTBOX_POLL_MS;
 * si el lote vino lleno, sigue de inmediato. `stop()`/`start()` permiten simular un
 * reinicio en los e2e.
 */
@Injectable()
export class OutboxRelay implements OnApplicationBootstrap, BeforeApplicationShutdown {
  private readonly logger = new Logger('OutboxRelay');
  private readonly core: OutboxRelayCore;
  private readonly pollMs: number;
  private readonly batchSize: number;
  private timer: NodeJS.Timeout | undefined;
  private running: Promise<void> | undefined;
  private active = false;

  constructor(
    store: PrismaOutboxStore,
    publisher: BullJobPublisher,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.pollMs = config.get('OUTBOX_POLL_MS', { infer: true });
    this.batchSize = config.get('OUTBOX_BATCH_SIZE', { infer: true });
    this.core = new OutboxRelayCore(store, publisher, this.batchSize);
  }

  onApplicationBootstrap(): void {
    this.start();
  }

  /** Antes de cerrar conexiones: termina el lote en curso y no toma otro. */
  async beforeApplicationShutdown(): Promise<void> {
    await this.stop();
  }

  start(): void {
    if (this.active) return;
    this.active = true;
    this.schedule(0);
  }

  async stop(): Promise<void> {
    this.active = false;
    if (this.timer) clearTimeout(this.timer);
    this.timer = undefined;
    await this.running;
  }

  /** Procesa un lote ya (para tests y para vaciar el outbox al arrancar). */
  runOnce(): Promise<number> {
    return this.core.runOnce();
  }

  private schedule(delayMs: number): void {
    if (!this.active) return;
    this.timer = setTimeout(() => {
      this.running = this.tick();
    }, delayMs);
  }

  private async tick(): Promise<void> {
    let processed = 0;
    try {
      processed = await this.core.runOnce();
    } catch (err) {
      this.logger.error(`No se pudo procesar el outbox: ${String(err)}`);
    }
    this.schedule(processed >= this.batchSize ? 0 : this.pollMs);
  }
}
