import { decimal, formatBs } from '../categories/effective-category';

const bs = (amount: string): string => formatBs(decimal(amount));

/**
 * Textos de los avisos, en español de Bolivia (ADR-0027). Cada aviso lleva `route`: la
 * pantalla de la app que se abre al tocarlo.
 */
export interface NotificationInputs {
  request_new: { requestId: string; category: string; distanceM: number; proposedPriceBs: string };
  offer_new: { requestId: string; workerShortName: string; amountBs: string };
  request_assigned_employer: { requestId: string; jobId: string; workerShortName: string };
  request_assigned_worker: { requestId: string; jobId: string; category: string };
  request_expired: { requestId: string; category: string };
  request_released: { requestId: string; category: string };
  request_rejected: { requestId: string; category: string };
}

export type NotificationType = keyof NotificationInputs;

export interface RenderedNotification {
  title: string;
  body: string;
  route: string;
}

const distance = (m: number): string =>
  m < 1000
    ? `a ${Math.max(Math.round(m / 10) * 10, 10)} m`
    : `a ${(m / 1000).toFixed(1).replace('.', ',')} km`;

const RENDER: { [T in NotificationType]: (d: NotificationInputs[T]) => RenderedNotification } = {
  request_new: (d) => ({
    title: 'Nueva solicitud cerca',
    body: `${d.category} ${distance(d.distanceM)} · ${bs(d.proposedPriceBs)}`,
    route: `/trabajo/solicitudes/${d.requestId}`,
  }),
  offer_new: (d) => ({
    title: 'Recibiste una oferta',
    body: `${d.workerShortName} ofrece ${bs(d.amountBs)}. Revísala y elige.`,
    route: `/solicitudes/${d.requestId}`,
  }),
  request_assigned_employer: (d) => ({
    title: `Elegiste a ${d.workerShortName}`,
    body: 'Ya puedes ver su contacto.',
    route: `/solicitudes/${d.requestId}`,
  }),
  request_assigned_worker: (d) => ({
    title: '¡Te eligieron!',
    body: `Para el trabajo de ${d.category}. Ya puedes ver el contacto.`,
    route: `/trabajo/solicitudes/${d.requestId}`,
  }),
  request_expired: (d) => ({
    title: 'Tu solicitud expiró',
    body: `Nadie tomó tu solicitud de ${d.category} a tiempo. Puedes publicarla de nuevo.`,
    route: `/solicitudes/${d.requestId}`,
  }),
  request_released: (d) => ({
    title: 'Tu solicitud fue publicada',
    body: `Ya estamos buscando trabajadores de ${d.category} cerca de ti.`,
    route: `/solicitudes/${d.requestId}`,
  }),
  request_rejected: (d) => ({
    title: 'Tu solicitud no fue publicada',
    body: 'No cumple las normas de uso de SISI.',
    route: `/solicitudes/${d.requestId}`,
  }),
};

export function renderNotification<T extends NotificationType>(
  type: T,
  data: NotificationInputs[T],
): RenderedNotification {
  return RENDER[type](data);
}
