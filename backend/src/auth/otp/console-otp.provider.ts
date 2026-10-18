import { Logger } from '@nestjs/common';
import { maskPhone } from '../../common/phone/phone';
import type { OtpProvider } from './otp-provider';

/**
 * Solo para local, test y staging: imprime el código en el log.
 * La fábrica impide usarlo con APP_ENV=production (ADR-0011) y, por si alguien lo
 * construyera por otro camino, el constructor también (ADR-0047).
 */
export class ConsoleOtpProvider implements OtpProvider {
  readonly name = 'console' as const;
  private readonly logger = new Logger('ConsoleOtpProvider');

  constructor(appEnv?: string) {
    if (appEnv === 'production') {
      throw new Error('El OTP por consola es imposible con APP_ENV=production.');
    }
  }

  send(phoneE164: string, code: string): Promise<void> {
    this.logger.warn(`Código OTP para ${maskPhone(phoneE164)}: ${code} (proveedor de consola)`);
    return Promise.resolve();
  }
}
