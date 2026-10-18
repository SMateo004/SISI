/**
 * Motivos de rechazo de una verificación (Fase 6, propuesta aprobada; en pendientes para
 * validar). Lista cerrada: el admin elige uno y siempre agrega una nota.
 */
export const REJECTION_REASONS = [
  'documento_ilegible',
  'documento_no_coincide',
  'selfie_no_coincide',
  'menor_de_edad',
  'documento_vencido',
  'requisitos_de_categoria',
  'datos_incompletos',
  'otro',
] as const;

export type RejectionReason = (typeof REJECTION_REASONS)[number];

/** Cómo lo lee el trabajador (en el aviso y en el estado de su solicitud). */
export const REJECTION_LABELS: Readonly<Record<RejectionReason, string>> = {
  documento_ilegible: 'Una foto del carnet no se lee bien',
  documento_no_coincide: 'Los datos del carnet no coinciden con los de tu cuenta',
  selfie_no_coincide: 'La selfie no coincide con la foto del carnet',
  menor_de_edad: 'Debes tener al menos 18 años',
  documento_vencido: 'El carnet está vencido',
  requisitos_de_categoria: 'Falta un requisito de una de tus categorías',
  datos_incompletos: 'Faltan datos en tu solicitud',
  otro: 'Revisa la nota del equipo',
};

/** Texto guardado en worker_profiles.rejection_reason: motivo y nota del admin. */
export const rejectionText = (reason: RejectionReason, note: string): string =>
  `${REJECTION_LABELS[reason]}. ${note.trim()}`;
