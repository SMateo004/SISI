import { Global, Inject, Module, type OnApplicationShutdown } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { FcmPushProvider } from './push/fcm-push.provider';
import { PUSH_PROVIDER, type PushProvider } from './push/push-provider';
import { createPushProvider } from './push/push-provider.factory';

/** Avisos y push (ADR-0027). Global: los usan los handlers del worker. */
@Global()
@Module({
  providers: [
    {
      provide: PUSH_PROVIDER,
      inject: [ConfigService],
      useFactory: (config: AppConfigService): PushProvider =>
        createPushProvider({
          APP_ENV: config.get('APP_ENV', { infer: true }),
          PUSH_PROVIDER: config.get('PUSH_PROVIDER', { infer: true }),
          FIREBASE_SERVICE_ACCOUNT: config.get('FIREBASE_SERVICE_ACCOUNT', { infer: true }),
        }),
    },
    NotificationsService,
  ],
  exports: [NotificationsService, PUSH_PROVIDER],
})
export class NotificationsCoreModule implements OnApplicationShutdown {
  constructor(@Inject(PUSH_PROVIDER) private readonly push: PushProvider) {}

  async onApplicationShutdown(): Promise<void> {
    if (this.push instanceof FcmPushProvider) await this.push.close();
  }
}

/** Endpoints de dispositivos y avisos (API). */
@Module({
  imports: [NotificationsCoreModule],
  controllers: [NotificationsController],
})
export class NotificationsModule {}
