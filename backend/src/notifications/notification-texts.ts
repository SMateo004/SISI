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
  job_on_the_way: { jobId: string; workerShortName: string };
  job_started: { jobId: string; workerShortName: string };
  job_finished: { jobId: string; workerShortName: string };
  job_completed: { jobId: string; netBs: string; commissionBs: string; auto: boolean };
  job_disputed: { jobId: string };
  job_resolved: { jobId: string; status: string };
  chat_message: { jobId: string; senderShortName: string; preview: string };
  billing_due: { periodId: string; amountBs: string; reference: string; dueLabel: string };
  billing_reminder: {
    periodId: string;
    amountBs: string;
    reference: string;
    dueLabel: string;
    today: boolean;
  };
  review_request: { jobId: string; counterpartShortName: string; toWorker: boolean };
  job_cancelled: {
    jobId: string;
    requestId: string;
    by: 'worker' | 'employer';
    reason: string;
    /** El aviso es para el empleador (puede volver a publicar). */
    toEmployer: boolean;
  };
}

/** Motivos de cancelación de un trabajo, como los ve la contraparte. */
export const CANCEL_REASON_LABELS: Record<string, string> = {
  cambio_de_planes: 'Cambio de planes',
  no_llega_o_no_responde: 'No llega o no responde',
  desacuerdo_de_precio: 'Desacuerdo con el precio',
  emergencia: 'Emergencia',
  otro: 'Otro motivo',
};

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
  job_on_the_way: (d) => ({
    title: `${d.workerShortName} va en camino`,
    body: 'Puedes seguir su ubicación en el mapa.',
    route: `/trabajos/${d.jobId}`,
  }),
  job_started: (d) => ({
    title: 'Empezó el trabajo',
    body: `${d.workerShortName} marcó que empezó.`,
    route: `/trabajos/${d.jobId}`,
  }),
  job_finished: (d) => ({
    title: `${d.workerShortName} terminó el trabajo`,
    body: 'Confírmalo o avísanos si hubo un problema. Si no respondes, se confirmará solo.',
    route: `/trabajos/${d.jobId}`,
  }),
  job_completed: (d) => ({
    title: d.auto ? 'El trabajo se confirmó solo' : 'El empleador confirmó el trabajo',
    body: `Recibes ${bs(d.netBs)} (comisión ${bs(d.commissionBs)}).`,
    route: `/trabajos/${d.jobId}`,
  }),
  job_disputed: (d) => ({
    title: 'El empleador reportó un problema',
    body: 'El equipo de SISI revisará el trabajo y te avisará.',
    route: `/trabajos/${d.jobId}`,
  }),
  job_resolved: (d) => ({
    title: 'Se resolvió la revisión del trabajo',
    body:
      d.status === 'terminado' ? 'El trabajo quedó como terminado.' : 'El trabajo quedó cancelado.',
    route: `/trabajos/${d.jobId}`,
  }),
  billing_due: (d) => ({
    title: 'Tu comisión de la semana',
    body: `Paga ${bs(d.amountBs)} hasta el ${d.dueLabel}. Referencia: ${d.reference}.`,
    route: '/ganancias/pagar',
  }),
  billing_reminder: (d) => ({
    title: d.today ? 'Hoy vence tu comisión' : 'Mañana vence tu comisión',
    body: `Paga ${bs(d.amountBs)} hasta el ${d.dueLabel} para seguir recibiendo trabajos. Referencia: ${d.reference}.`,
    route: '/ganancias/pagar',
  }),
  review_request: (d) => ({
    title: d.toWorker ? 'Califica al empleador' : `Califica a ${d.counterpartShortName}`,
    body: `¿Cómo te fue con ${d.counterpartShortName}? Tu calificación ayuda a toda la comunidad.`,
    route: `/trabajos/${d.jobId}`,
  }),
  chat_message: (d) => ({
    title: `Mensaje de ${d.senderShortName}`,
    body: d.preview,
    route: `/trabajos/${d.jobId}/chat`,
  }),
  job_cancelled: (d) => ({
    title:
      d.by === 'worker' ? 'El trabajador canceló el trabajo' : 'El empleador canceló el trabajo',
    body: `Motivo: ${CANCEL_REASON_LABELS[d.reason] ?? 'Otro motivo'}.${d.toEmployer ? ' Puedes volver a publicar tu solicitud.' : ''}`,
    route: `/trabajos/${d.jobId}`,
  }),
};

export function renderNotification<T extends NotificationType>(
  type: T,
  data: NotificationInputs[T],
): RenderedNotification {
  return RENDER[type](data);
}
