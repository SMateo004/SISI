import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { S3StorageService } from './s3-storage.service';
import { StorageService } from './storage.service';

/** Solo lo importa la API: worker y billing-cron no exigen credenciales de almacenamiento. */
@Global()
@Module({
  providers: [
    {
      provide: StorageService,
      inject: [ConfigService],
      useFactory: (config: AppConfigService) =>
        new S3StorageService({
          APP_ENV: config.get('APP_ENV', { infer: true }),
          STORAGE_ENDPOINT: config.get('STORAGE_ENDPOINT', { infer: true }),
          STORAGE_REGION: config.get('STORAGE_REGION', { infer: true }),
          STORAGE_FORCE_PATH_STYLE: config.get('STORAGE_FORCE_PATH_STYLE', { infer: true }),
          STORAGE_BUCKET: config.get('STORAGE_BUCKET', { infer: true }),
          STORAGE_ACCESS_KEY: config.get('STORAGE_ACCESS_KEY', { infer: true }),
          STORAGE_SECRET_KEY: config.get('STORAGE_SECRET_KEY', { infer: true }),
        }),
    },
  ],
  exports: [StorageService],
})
export class StorageModule {}
