import { Logger } from '@nestjs/common';
import { maskPhone } from '../../common/phone/phone';
import type { OtpProvider } from './otp-provider';

/**
 * Solo para local, test y staging: imprime el código en el log.
 * La fábrica impide usarlo con APP_ENV=production (ADR-0011).
 */
export class ConsoleOtpProvider implements OtpProvider {
  readonly name = 'console' as const;
  private readonly logger = new Logger('ConsoleOtpProvider');

  send(phoneE164: string, code: string): Promise<void> {
    this.logger.warn(`Código OTP para ${maskPhone(phoneE164)}: ${code} (proveedor de consola)`);
    return Promise.resolve();
  }
}
