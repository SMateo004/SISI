import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiError } from '../../common/errors/api-error';
import { normalizePhone, PhoneValidationError } from '../../common/phone/phone';
import { RateLimitStore } from '../../common/rate-limit/rate-limit.store';
import { RateLimitedException } from '../../common/rate-limit/rate-limited.exception';
import type { AppConfigService } from '../../config/app-config';
import { OtpHasher } from './otp-hasher';
import { OTP_PROVIDER, type OtpProvider } from './otp-provider';
import { OTP_STORE, type OtpStore } from './otp.store';

export interface OtpRequested {
  expiresInSec: number;
  resendInSec: number;
}

/** Generador de códigos inyectable para tests. */
export const OTP_CODE_GENERATOR = Symbol('OTP_CODE_GENERATOR');
export type OtpCodeGenerator = () => string;

/**
 * Flujo de OTP (ADR-0009): 6 dígitos, solo el hash en Redis, vence en OTP_TTL_SEC
 * y se invalida al llegar a OTP_MAX_ATTEMPTS intentos fallidos. Las respuestas no
 * revelan si el número ya tiene cuenta.
 */
@Injectable()
export class OtpService {
  private readonly hasher: OtpHasher;

  constructor(
    @Inject(ConfigService) private readonly config: AppConfigService,
    @Inject(OTP_STORE) private readonly store: OtpStore,
    @Inject(OTP_PROVIDER) private readonly provider: OtpProvider,
    @Inject(OTP_CODE_GENERATOR) private readonly generateCode: OtpCodeGenerator,
    private readonly rateLimits: RateLimitStore,
  ) {
    this.hasher = new OtpHasher(config.get('JWT_SECRET', { infer: true }));
  }

  normalize(rawPhone: string): string {
    try {
      return normalizePhone(
        rawPhone,
        this.config.get('PHONE_ALLOWED_COUNTRY_CODES', { infer: true }),
      );
    } catch (error) {
      if (error instanceof PhoneValidationError) {
        throw new ApiError(HttpStatus.BAD_REQUEST, error.code, error.message);
      }
      throw error;
    }
  }

  async request(rawPhone: string): Promise<OtpRequested> {
    const phone = this.normalize(rawPhone);
    const phoneKey = this.hasher.phoneKey(phone);
    const cooldown = this.config.get('RATE_OTP_PHONE_COOLDOWN_SEC', { infer: true });

    const decision = await this.rateLimits.consume([
      { key: `otp:phone:${phoneKey}:cooldown`, limit: 1, windowSec: cooldown },
      {
        key: `otp:phone:${phoneKey}:hour`,
        limit: this.config.get('RATE_OTP_PHONE_PER_HOUR', { infer: true }),
        windowSec: 3600,
      },
      {
        key: `otp:phone:${phoneKey}:day`,
        limit: this.config.get('RATE_OTP_PHONE_PER_DAY', { infer: true }),
        windowSec: 86_400,
      },
    ]);
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);

    const ttl = this.config.get('OTP_TTL_SEC', { infer: true });
    const code = this.generateCode();
    await this.store.save(phoneKey, this.hasher.hash(phone, code), ttl);
    try {
      await this.provider.send(phone, code);
    } catch (error) {
      await this.store.delete(phoneKey);
      throw error;
    }
    return { expiresInSec: ttl, resendInSec: cooldown };
  }

  /** Devuelve el teléfono normalizado si el código es correcto. */
  async verify(rawPhone: string, code: string): Promise<string> {
    const phone = this.normalize(rawPhone);
    const result = await this.store.check(
      this.hasher.phoneKey(phone),
      this.hasher.hash(phone, code),
      this.config.get('OTP_MAX_ATTEMPTS', { infer: true }),
    );
    switch (result) {
      case 'ok':
        return phone;
      case 'exhausted':
        throw new ApiError(
          HttpStatus.BAD_REQUEST,
          'OTP_TOO_MANY_ATTEMPTS',
          'Demasiados intentos con este código. Solicita uno nuevo.',
        );
      case 'expired':
      case 'invalid':
        throw new ApiError(HttpStatus.BAD_REQUEST, 'OTP_INVALID', 'Código incorrecto o vencido.');
    }
  }
}
