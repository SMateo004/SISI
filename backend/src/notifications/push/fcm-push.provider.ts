import { type App, cert, deleteApp, initializeApp, type ServiceAccount } from 'firebase-admin/app';
import { getMessaging, type Messaging } from 'firebase-admin/messaging';
import type { PushMessage, PushProvider, PushResult } from './push-provider';

/** Códigos de FCM que indican que el token ya no sirve. */
const INVALID_TOKEN_CODES = new Set([
  'messaging/registration-token-not-registered',
  'messaging/invalid-registration-token',
]);

/** FCM HTTP v1 con firebase-admin (ADR-0027). Credencial: FIREBASE_SERVICE_ACCOUNT. */
export class FcmPushProvider implements PushProvider {
  readonly name = 'fcm' as const;
  private readonly app: App;
  private readonly messaging: Messaging;

  constructor(serviceAccount: ServiceAccount) {
    this.app = initializeApp({ credential: cert(serviceAccount) }, 'sisi-push');
    this.messaging = getMessaging(this.app);
  }

  async send(tokens: string[], message: PushMessage): Promise<PushResult[]> {
    if (tokens.length === 0) return [];
    // Un mensaje por token (sendEachForMulticast con tokens está obsoleto en firebase-admin 14).
    const res = await this.messaging.sendEach(
      tokens.map((token) => ({
        token,
        notification: { title: message.title, body: message.body },
        data: message.data,
        android: { priority: 'high' as const, notification: { channelId: 'sisi_avisos' } },
        webpush: { headers: { Urgency: 'high' } },
      })),
    );
    return res.responses.map((r, i) => ({
      token: tokens[i] ?? '',
      ok: r.success,
      invalidToken: !r.success && INVALID_TOKEN_CODES.has(r.error?.code ?? ''),
    }));
  }

  async close(): Promise<void> {
    await deleteApp(this.app);
  }
}
