import { Module } from '@nestjs/common';
import { AdminSettingsController } from './admin-settings.controller';

/** Parámetros en el panel (solo la API). */
@Module({ controllers: [AdminSettingsController] })
export class SettingsAdminModule {}
