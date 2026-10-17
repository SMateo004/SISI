/** Enlaces del contacto (Fase 4): llamar y WhatsApp a partir del teléfono E.164. */
export function contactLinks(phone: string): { telUri: string; whatsappUri: string } {
  const digits = phone.replace(/\D/g, '');
  return { telUri: `tel:+${digits}`, whatsappUri: `https://wa.me/${digits}` };
}

/**
 * Hasta cuándo se ve el contacto: `afterMs` después de terminado o cancelado; null
 * mientras el trabajo sigue activo. Función pura.
 */
export function contactVisibleUntil(
  job: { completedAt: Date | null; cancelledAt: Date | null },
  afterMs: number,
): Date | null {
  const endedAt = job.completedAt ?? job.cancelledAt;
  return endedAt ? new Date(endedAt.getTime() + afterMs) : null;
}
