import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../errors/api-error';

/**
 * Ningún admin actúa sobre su propia cuenta desde el panel (Fase 6): verificación, reportes,
 * disputas, pagos, ajustes, comprobantes, suspensión y marca de revisión. `involved` son las
 * cuentas afectadas por la acción (p. ej. en una disputa, el empleador y el trabajador).
 */
export function assertNotSelf(
  adminId: string | null,
  involved: readonly (string | null | undefined)[],
  message = 'No puedes hacer esta acción sobre tu propia cuenta.',
): void {
  if (adminId !== null && involved.includes(adminId)) {
    throw new ApiError(HttpStatus.FORBIDDEN, 'SELF_REVIEW_FORBIDDEN', message);
  }
}
