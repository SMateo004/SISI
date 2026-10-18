import { Global, Module } from '@nestjs/common';
import { AppSettingsService } from './app-settings.service';

/** Parámetros de negocio (ADR-0043). Global: los leen la API, el worker y el cron. */
@Global()
@Module({
  providers: [AppSettingsService],
  exports: [AppSettingsService],
})
export class SettingsModule {}
