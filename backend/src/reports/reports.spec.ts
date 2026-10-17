import { suspensionDecision } from './report.rules';

const base = { threshold: 3, alreadyFlagged: false };

describe('suspensión por reportes (R9.3, ADR-0033)', () => {
  it('con menos de 3 reportes válidos no pasa nada', () => {
    expect(suspensionDecision({ ...base, validReporters: 2, workerStatus: 'aprobado' })).toBe(
      'none',
    );
  });

  it.each(['aprobado', 'bloqueado_deuda'])('con 3 suspende a un trabajador %s', (status) => {
    expect(suspensionDecision({ ...base, validReporters: 3, workerStatus: status })).toBe(
      'suspend',
    );
  });

  it('ya suspendido: nada', () => {
    expect(
      suspensionDecision({ ...base, validReporters: 5, workerStatus: 'suspendido_moderacion' }),
    ).toBe('none');
  });

  it.each(['sin_solicitar', 'pendiente_revision', 'rechazado', null])(
    'solo empleador (%s): se marca para el admin, una vez',
    (status) => {
      expect(suspensionDecision({ ...base, validReporters: 3, workerStatus: status })).toBe('flag');
      expect(
        suspensionDecision({
          ...base,
          validReporters: 4,
          workerStatus: status,
          alreadyFlagged: true,
        }),
      ).toBe('none');
    },
  );
});
