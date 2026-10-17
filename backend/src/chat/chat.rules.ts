/** Lo que importa del trabajo para la ventana del chat. */
export interface ChatJobState {
  status: string;
  completedAt: Date | null;
  cancelledAt: Date | null;
}

export interface ChatWindow {
  open: boolean;
  /** Cuándo pasa a solo lectura; null mientras el trabajo sigue activo. */
  closesAt: Date | null;
}

/**
 * Ventana del chat (ADR-0031): abierto desde que se asigna y hasta `openAfterMs` después
 * de terminado o cancelado; después queda en solo lectura. Función pura.
 */
export function chatWindow(job: ChatJobState, now: number, openAfterMs: number): ChatWindow {
  const endedAt = job.completedAt ?? job.cancelledAt;
  if (job.status !== 'terminado' && job.status !== 'cancelado') {
    return { open: true, closesAt: null };
  }
  if (!endedAt) return { open: false, closesAt: null };
  const closesAt = new Date(endedAt.getTime() + openAfterMs);
  return { open: now < closesAt.getTime(), closesAt };
}

/** Texto del aviso: los primeros caracteres del mensaje, en una línea. */
export function chatPreview(body: string, max = 80): string {
  const line = body.replace(/\s+/g, ' ').trim();
  return line.length <= max ? line : `${line.slice(0, max - 1)}…`;
}

export const HELD_NOTICE = 'Tu mensaje no se envió porque no cumple las normas de uso de SISI.';
