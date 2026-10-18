import { Module } from '@nestjs/common';
import { LegalController } from './legal.controller';
import { LegalGuard } from './legal.guard';
import { LegalService } from './legal.service';

/** Textos legales y su aceptación (ADR-0051). Solo la API. */
@Module({
  controllers: [LegalController],
  providers: [LegalService, LegalGuard],
  exports: [LegalService, LegalGuard],
})
export class LegalModule {}
