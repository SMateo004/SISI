import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { LegalService } from '../legal/legal.service';
import { AppSettingsService } from '../settings/app-settings.service';
import type { AppConfigDto } from './dto/app-config.dto';
import { type AppPlatform, compareVersions } from './semver';

const MIN_VERSION_KEY = {
  android: 'APP_MIN_VERSION_ANDROID',
  ios: 'APP_MIN_VERSION_IOS',
  web: 'APP_MIN_VERSION_WEB',
} as const;

/** Lo que la app necesita saber al abrirse (ADR-0052, ADR-0054). */
@Injectable()
export class ClientAppService {
  constructor(
    private readonly settings: AppSettingsService,
    private readonly legal: LegalService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  minVersion(platform: AppPlatform): string {
    return this.settings.value(MIN_VERSION_KEY[platform]);
  }

  storeUrl(platform: AppPlatform): string | null {
    if (platform === 'android') {
      return this.config.get('APP_STORE_URL_ANDROID', { infer: true }) || null;
    }
    if (platform === 'ios') return this.config.get('APP_STORE_URL_IOS', { infer: true }) || null;
    return null;
  }

  /** true si esa versión ya no puede usar la API. */
  mustUpgrade(platform: AppPlatform, version: string): boolean {
    return compareVersions(version, this.minVersion(platform)) < 0;
  }

  /** Enlace de WhatsApp de soporte, o null si no está configurado. */
  support(): { whatsapp: string; url: string } | null {
    const phone = this.settings.value('SUPPORT_WHATSAPP');
    if (!phone) return null;
    const text = encodeURIComponent('Hola, necesito ayuda con la app.');
    return { whatsapp: phone, url: `https://wa.me/${phone.replace('+', '')}?text=${text}` };
  }

  async appConfig(platform: AppPlatform, version?: string): Promise<AppConfigDto> {
    const minVersion = this.minVersion(platform);
    return {
      platform,
      minVersion,
      upgradeRequired: version !== undefined && compareVersions(version, minVersion) < 0,
      storeUrl: this.storeUrl(platform),
      support: this.support(),
      legal: (await this.legal.currentDocuments()).map((d) => ({
        type: d.type,
        version: d.version,
      })),
    };
  }
}
