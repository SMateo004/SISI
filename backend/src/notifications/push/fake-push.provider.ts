import { Logger } from '@nestjs/common';
import type { PushMessage, PushProvider, PushResult } from './push-provider';

/**
 * Push falso para local y tests (ADR-0027): guarda lo enviado y lo deja en el log.
 * Los tokens que empiezan con "invalid" simulan un token vencido.
 */
export class FakePushProvider implements PushProvider {
  readonly name = 'fake' as const;
  readonly sent: { tokens: string[]; message: PushMessage }[] = [];
  private readonly logger = new Logger('FakePush');

  send(tokens: string[], message: PushMessage): Promise<PushResult[]> {
    this.sent.push({ tokens, message });
    this.logger.log(`Push a ${tokens.length} dispositivo(s): ${message.title} · ${message.body}`);
    return Promise.resolve(
      tokens.map((token) => {
        const invalid = token.startsWith('invalid');
        return { token, ok: !invalid, invalidToken: invalid };
      }),
    );
  }
}
