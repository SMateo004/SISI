/** Mensaje push. `data` solo admite strings (limitación de FCM). */
export interface PushMessage {
  title: string;
  body: string;
  data: Record<string, string>;
}

export interface PushResult {
  token: string;
  ok: boolean;
  /** El token ya no sirve (app desinstalada, token rotado): se borra. */
  invalidToken: boolean;
}

/** Envío de push (ADR-0027). FCM en staging/production; falso en local y tests. */
export interface PushProvider {
  readonly name: 'fcm' | 'fake';
  send(tokens: string[], message: PushMessage): Promise<PushResult[]>;
}

export const PUSH_PROVIDER = Symbol('PUSH_PROVIDER');
