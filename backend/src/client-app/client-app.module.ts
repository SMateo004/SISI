import { Module } from '@nestjs/common';
import { LegalModule } from '../legal/legal.module';
import { AppVersionGuard } from './app-version.guard';
import { ClientAppController } from './client-app.controller';
import { ClientAppService } from './client-app.service';

/** Configuración pública de la app y versión mínima (ADR-0054). */
@Module({
  imports: [LegalModule],
  controllers: [ClientAppController],
  providers: [ClientAppService, AppVersionGuard],
  exports: [ClientAppService, AppVersionGuard],
})
export class ClientAppModule {}
