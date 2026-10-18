import { Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { EventHandlersRegistry } from '../outbox/event-handlers.registry';
import { StorageService } from '../storage/storage.service';

/**
 * Worker: borra del bucket los archivos de una cuenta eliminada (ADR-0049). Idempotente: borrar
 * un objeto que ya no existe no falla, así que un reintento no cambia nada.
 */
@Injectable()
export class AccountDeletionHandlers implements OnModuleInit {
  private readonly logger = new Logger(AccountDeletionHandlers.name);

  constructor(
    private readonly registry: EventHandlersRegistry,
    private readonly storage: StorageService,
  ) {}

  onModuleInit(): void {
    this.registry.on('account.deleted', async ({ payload }) => {
      for (const key of payload.fileKeys) await this.storage.delete(key);
      this.logger.log(
        `Archivos de una cuenta eliminada borrados: ${String(payload.fileKeys.length)}`,
      );
    });
  }
}
