import type { ServiceAccount } from 'firebase-admin/app';
import type { Env } from '../../config/env.schema';
import { FakePushProvider } from './fake-push.provider';
import { FcmPushProvider } from './fcm-push.provider';
import type { PushProvider } from './push-provider';

type PushEnv = Pick<Env, 'APP_ENV' | 'PUSH_PROVIDER' | 'FIREBASE_SERVICE_ACCOUNT'>;

/**
 * Credencial de la cuenta de servicio: el JSON tal cual o en base64 (más cómodo en Render).
 * Nunca se registra en logs.
 */
export function parseServiceAccount(raw: string): ServiceAccount {
  const text = raw.trim().startsWith('{') ? raw : Buffer.from(raw, 'base64').toString('utf8');
  let json: { project_id?: string; client_email?: string; private_key?: string };
  try {
    json = JSON.parse(text) as typeof json;
  } catch {
    throw new Error('FIREBASE_SERVICE_ACCOUNT no es un JSON válido (ni en base64).');
  }
  if (!json.project_id || !json.client_email || !json.private_key) {
    throw new Error('FIREBASE_SERVICE_ACCOUNT debe tener project_id, client_email y private_key.');
  }
  return {
    projectId: json.project_id,
    clientEmail: json.client_email,
    privateKey: json.private_key,
  };
}

/**
 * Elige el proveedor de push (ADR-0027):
 * - APP_ENV=production nunca usa el falso (los avisos son parte del servicio).
 * - fcm exige FIREBASE_SERVICE_ACCOUNT.
 */
export function createPushProvider(env: PushEnv): PushProvider {
  if (env.PUSH_PROVIDER === 'fake') {
    if (env.APP_ENV === 'production') {
      throw new Error(
        'PUSH_PROVIDER=fake no está permitido con APP_ENV=production. Configura PUSH_PROVIDER=fcm.',
      );
    }
    return new FakePushProvider();
  }
  if (!env.FIREBASE_SERVICE_ACCOUNT) {
    throw new Error('PUSH_PROVIDER=fcm requiere FIREBASE_SERVICE_ACCOUNT.');
  }
  return new FcmPushProvider(parseServiceAccount(env.FIREBASE_SERVICE_ACCOUNT));
}
