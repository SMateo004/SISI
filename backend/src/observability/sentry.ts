import * as Sentry from '@sentry/node';
import { redactText, redactValue } from '../common/logging/redact';
import { releaseInfo, releaseName } from '../common/release/release';
import { currentRequestId, currentUserId } from './request-context';

export type SisiService = 'api' | 'worker' | 'billing-cron';

let enabled = false;

/**
 * Sentry en api, worker y cron (ADR-0048), con release y ambiente. Sin SENTRY_DSN no hace nada
 * (local y test); producción lo exige al validar el entorno (ADR-0047). Nunca datos
 * personales: sin IP ni cookies y con todo el evento redactado.
 */
export function initSentry(service: SisiService, env: NodeJS.ProcessEnv = process.env): boolean {
  const dsn = env.SENTRY_DSN;
  if (!dsn) return false;
  const info = releaseInfo(env.RENDER_GIT_COMMIT);
  Sentry.init({
    dsn,
    environment: env.APP_ENV ?? 'local',
    release: releaseName(info),
    // Nada que identifique a alguien: sin usuario automático, cookies, headers, cuerpos ni query.
    dataCollection: {
      userInfo: false,
      cookies: false,
      httpHeaders: false,
      httpBodies: [],
      urlQueryParams: false,
    },
    tracesSampleRate: 0,
    initialScope: { tags: { service } },
    beforeSend: (event) => scrub(event),
    beforeBreadcrumb: (breadcrumb) => ({
      ...breadcrumb,
      message: breadcrumb.message ? redactText(breadcrumb.message) : breadcrumb.message,
      data: breadcrumb.data ? (redactValue(breadcrumb.data) as typeof breadcrumb.data) : undefined,
    }),
  });
  enabled = true;
  return true;
}

/** Quita lo que pueda identificar a alguien antes de enviar. Exportada para los tests. */
export function scrub<E extends Sentry.ErrorEvent>(event: E): E {
  if (event.request) {
    delete event.request.cookies;
    delete event.request.data;
    delete event.request.query_string;
    if (event.request.headers) {
      event.request.headers = redactValue(event.request.headers) as Record<string, string>;
    }
  }
  if (event.user) event.user = event.user.id ? { id: event.user.id } : undefined;
  if (event.message) event.message = redactText(event.message);
  for (const ex of event.exception?.values ?? []) {
    if (ex.value) ex.value = redactText(ex.value);
  }
  if (event.extra) event.extra = redactValue(event.extra) as typeof event.extra;
  if (event.contexts) event.contexts = redactValue(event.contexts) as typeof event.contexts;
  return event;
}

/** Error inesperado (5xx, job fallido): con el id de correlación y el usuario si lo hay. */
export function reportError(error: unknown, tags: Record<string, string> = {}): void {
  if (!enabled) return;
  Sentry.withScope((scope) => {
    const requestId = currentRequestId();
    const userId = currentUserId();
    if (requestId) scope.setTag('requestId', requestId);
    if (userId) scope.setUser({ id: userId });
    for (const [k, v] of Object.entries(tags)) scope.setTag(k, v);
    Sentry.captureException(error);
  });
}

/**
 * Alerta operativa (OpsMonitor): un mensaje de nivel error con fingerprint estable, así cada
 * tipo de alerta es una sola issue en Sentry y la regla de alerta avisa una vez.
 */
export function reportAlert(kind: string, message: string, extra: Record<string, unknown>): void {
  if (!enabled) return;
  Sentry.withScope((scope) => {
    scope.setLevel('error');
    scope.setFingerprint(['ops-alert', kind]);
    scope.setTag('alert', kind);
    scope.setExtras(extra);
    Sentry.captureMessage(message);
  });
}

/** Check-in de un monitor de cron de Sentry (heartbeat del cron y del worker). */
export function checkIn(
  monitorSlug: string,
  status: 'in_progress' | 'ok' | 'error',
  schedule: { crontab: string; checkinMargin: number; maxRuntime: number },
  checkInId?: string,
): string | undefined {
  if (!enabled) return undefined;
  // Sin id es un latido (heartbeat): un ok suelto basta para el monitor del worker.
  let payload: Parameters<typeof Sentry.captureCheckIn>[0];
  if (status === 'in_progress') payload = { monitorSlug, status };
  else if (checkInId === undefined) payload = { monitorSlug, status };
  else payload = { monitorSlug, status, checkInId };
  return Sentry.captureCheckIn(payload, {
    schedule: { type: 'crontab', value: schedule.crontab },
    checkinMargin: schedule.checkinMargin,
    maxRuntime: schedule.maxRuntime,
    timezone: 'Etc/UTC',
  });
}

/** Antes de salir (cron): espera a que se envíe lo pendiente. */
export async function flushSentry(timeoutMs = 2000): Promise<void> {
  if (enabled) await Sentry.flush(timeoutMs);
}
