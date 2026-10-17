/** Qué hacer con el reportado al validar un reporte (R9.3, ADR-0033). Función pura. */
export type SuspensionDecision = 'suspend' | 'flag' | 'none';

export function suspensionDecision(input: {
  /** Personas distintas con un reporte válido contra el usuario. */
  validReporters: number;
  threshold: number;
  workerStatus: string | null;
  alreadyFlagged: boolean;
}): SuspensionDecision {
  if (input.validReporters < input.threshold) return 'none';
  // La suspensión de R9.3 es un estado del trabajador: solo si trabaja (o está bloqueado por deuda).
  if (input.workerStatus === 'aprobado' || input.workerStatus === 'bloqueado_deuda') {
    return 'suspend';
  }
  if (input.workerStatus === 'suspendido_moderacion') return 'none';
  // Solo empleador: no hay estado que suspender; se marca para que lo revise el admin.
  return input.alreadyFlagged ? 'none' : 'flag';
}

export const REPORT_REASONS = [
  'servicios_sexuales',
  'drogas',
  'armas',
  'ilegal',
  'inmoral',
  'venta_productos',
  'acoso',
  'fraude',
  'no_se_presento',
  'suplantacion',
  'otro',
] as const;
export type ReportReasonValue = (typeof REPORT_REASONS)[number];

export const REPORT_TARGETS = ['request', 'user', 'chat_message', 'job'] as const;
export type ReportTargetValue = (typeof REPORT_TARGETS)[number];
