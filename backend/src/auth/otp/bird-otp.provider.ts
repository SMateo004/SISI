import { HttpStatus, Logger } from '@nestjs/common';
import { ApiError } from '../../common/errors/api-error';
import { maskPhone } from '../../common/phone/phone';
import { type OtpProvider, otpMessage } from './otp-provider';

const KEY_FORMAT = /^bk_([a-z]+\d+)_[A-Za-z0-9]+$/;

export interface BirdOtpOptions {
  apiKey: string;
  sender: string;
  ttlMinutes: number;
  /** Para tests; por defecto fetch nativo. */
  fetchFn?: typeof fetch;
}

/**
 * SMS por Bird.com (POST /v1/sms/messages, categoría "authentication").
 * Sin SDK: fetch nativo (ADR-0011). El host regional sale del prefijo de la clave
 * (bk_us1_... → https://us1.platform.bird.com).
 */
export class BirdOtpProvider implements OtpProvider {
  readonly name = 'bird' as const;
  private readonly logger = new Logger('BirdOtpProvider');
  private readonly baseUrl: string;
  private readonly fetchFn: typeof fetch;

  constructor(private readonly options: BirdOtpOptions) {
    const region = KEY_FORMAT.exec(options.apiKey)?.[1];
    if (!region) {
      throw new Error(
        'OTP_PROVIDER_KEY no tiene el formato de una clave de Bird (bk_{región}_...)',
      );
    }
    this.baseUrl = `https://${region}.platform.bird.com`;
    this.fetchFn = options.fetchFn ?? fetch;
  }

  async send(phoneE164: string, code: string): Promise<void> {
    let response: Response;
    try {
      response = await this.fetchFn(`${this.baseUrl}/v1/sms/messages`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${this.options.apiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          to: phoneE164,
          from: this.options.sender,
          text: otpMessage(code, this.options.ttlMinutes),
          category: 'authentication',
        }),
        signal: AbortSignal.timeout(10_000),
      });
    } catch (error) {
      this.logger.error(`Bird no respondió para ${maskPhone(phoneE164)}: ${String(error)}`);
      throw unavailable();
    }
    if (!response.ok) {
      const detail = await response.text().catch(() => '');
      this.logger.error(
        `Bird rechazó el SMS a ${maskPhone(phoneE164)}: ${response.status} ${detail.slice(0, 300)}`,
      );
      throw unavailable();
    }
  }
}

const unavailable = (): ApiError =>
  new ApiError(
    HttpStatus.SERVICE_UNAVAILABLE,
    'OTP_SEND_FAILED',
    'No pudimos enviar el código. Intenta de nuevo en unos minutos.',
  );
