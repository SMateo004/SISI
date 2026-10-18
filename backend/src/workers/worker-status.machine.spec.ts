import { decideModeSwitch, hasName } from './mode-switch.rules';
import {
  allowedTransitions,
  canApply,
  forcesEmployerMode,
  nextWorkerStatus,
  WORKER_STATUSES,
  type WorkerEvent,
  type WorkerEventType,
  type WorkerStatus,
  WorkerTransitionError,
} from './worker-status.machine';

const EVENTS: Record<WorkerEventType, WorkerEvent> = {
  SUBMIT: { type: 'SUBMIT' },
  APPROVE: { type: 'APPROVE' },
  REJECT: { type: 'REJECT', reason: 'Foto borrosa' },
  BLOCK_FOR_DEBT: { type: 'BLOCK_FOR_DEBT' },
  DEBT_PAID: { type: 'DEBT_PAID' },
  SUSPEND: { type: 'SUSPEND', reason: '3 reportes válidos' },
  CONFIRM_SUSPENSION: { type: 'CONFIRM_SUSPENSION', resolution: 'Falta confirmada' },
  LIFT_SUSPENSION: {
    type: 'LIFT_SUSPENSION',
    resolution: 'Reporte infundado',
    hasOverdueDebt: false,
  },
};

/** Transiciones esperadas (from, evento) → to. Cualquier otra combinación debe rechazarse. */
const EXPECTED: [WorkerStatus, WorkerEventType, WorkerStatus][] = [
  ['sin_solicitar', 'SUBMIT', 'pendiente_revision'],
  ['rechazado', 'SUBMIT', 'pendiente_revision'],
  ['pendiente_revision', 'APPROVE', 'aprobado'],
  ['pendiente_revision', 'REJECT', 'rechazado'],
  ['aprobado', 'BLOCK_FOR_DEBT', 'bloqueado_deuda'],
  ['bloqueado_deuda', 'DEBT_PAID', 'aprobado'],
  ['aprobado', 'SUSPEND', 'suspendido_moderacion'],
  ['bloqueado_deuda', 'SUSPEND', 'suspendido_moderacion'],
  ['suspendido_moderacion', 'CONFIRM_SUSPENSION', 'suspendido_moderacion'],
  ['suspendido_moderacion', 'LIFT_SUSPENSION', 'aprobado'],
];

describe('máquina de estados del trabajador (R1.4)', () => {
  it('usa exactamente los 6 estados de R1.4', () => {
    expect(WORKER_STATUSES).toEqual([
      'sin_solicitar',
      'pendiente_revision',
      'aprobado',
      'rechazado',
      'bloqueado_deuda',
      'suspendido_moderacion',
    ]);
  });

  it.each(EXPECTED)('%s --%s--> %s', (from, event, to) => {
    expect(nextWorkerStatus(from, EVENTS[event])).toBe(to);
  });

  it('la tabla no tiene transiciones fuera de las esperadas', () => {
    expect(
      allowedTransitions()
        .map(({ from, event }) => `${from}:${event}`)
        .sort(),
    ).toEqual(EXPECTED.map(([from, event]) => `${from}:${event}`).sort());
  });

  it('rechaza todas las demás combinaciones', () => {
    const allowed = new Set(EXPECTED.map(([from, event]) => `${from}:${event}`));
    let rejected = 0;
    for (const from of WORKER_STATUSES) {
      for (const event of Object.keys(EVENTS) as WorkerEventType[]) {
        if (allowed.has(`${from}:${event}`)) continue;
        expect(canApply(from, event)).toBe(false);
        expect(() => nextWorkerStatus(from, EVENTS[event])).toThrow(WorkerTransitionError);
        rejected++;
      }
    }
    expect(rejected).toBe(6 * 8 - EXPECTED.length);
  });

  it('el error de transición es un 409 con código estable', () => {
    try {
      nextWorkerStatus('aprobado', EVENTS.SUBMIT);
      fail('debió lanzar');
    } catch (error) {
      expect(error).toBeInstanceOf(WorkerTransitionError);
      expect((error as WorkerTransitionError).getStatus()).toBe(409);
      expect((error as WorkerTransitionError).getResponse()).toMatchObject({
        code: 'WORKER_TRANSITION_NOT_ALLOWED',
        from: 'aprobado',
        event: 'SUBMIT',
      });
    }
  });

  describe('suspensión y deuda', () => {
    it('la suspensión tiene prioridad sobre la deuda', () => {
      expect(nextWorkerStatus('bloqueado_deuda', EVENTS.SUSPEND)).toBe('suspendido_moderacion');
    });

    it('al levantar la suspensión con deuda vencida pasa a bloqueado_deuda, no a aprobado', () => {
      expect(
        nextWorkerStatus('suspendido_moderacion', {
          type: 'LIFT_SUSPENSION',
          resolution: 'Reporte infundado',
          hasOverdueDebt: true,
        }),
      ).toBe('bloqueado_deuda');
    });

    it('al levantar la suspensión sin deuda vencida vuelve a aprobado', () => {
      expect(nextWorkerStatus('suspendido_moderacion', EVENTS.LIFT_SUSPENSION)).toBe('aprobado');
    });

    it('confirmar la suspensión no crea estados nuevos', () => {
      expect(nextWorkerStatus('suspendido_moderacion', EVENTS.CONFIRM_SUSPENSION)).toBe(
        'suspendido_moderacion',
      );
    });

    it('pagar la deuda no levanta una suspensión', () => {
      expect(() => nextWorkerStatus('suspendido_moderacion', EVENTS.DEBT_PAID)).toThrow(
        WorkerTransitionError,
      );
    });
  });

  it('bloqueado_deuda y suspendido_moderacion fuerzan el modo employer (R1.6)', () => {
    expect(WORKER_STATUSES.filter(forcesEmployerMode)).toEqual([
      'bloqueado_deuda',
      'suspendido_moderacion',
    ]);
  });
});

describe('interruptor de modo (R1.5, R1.6)', () => {
  it('cambiar a employer siempre está permitido, también bloqueado o suspendido', () => {
    for (const status of [...WORKER_STATUSES, null]) {
      expect(decideModeSwitch('employer', status)).toEqual({ allowed: true });
    }
  });

  it('a worker solo con estado aprobado', () => {
    expect(decideModeSwitch('worker', 'aprobado')).toEqual({ allowed: true });
  });

  it('aprobado pero sin nombre: completar el perfil (R1.3 ampliada)', () => {
    expect(decideModeSwitch('worker', 'aprobado', false)).toMatchObject({
      allowed: false,
      code: 'NAME_REQUIRED',
      nextAction: 'COMPLETE_PROFILE',
    });
    // Sin aprobar, manda el estado (la solicitud también pide el nombre).
    expect(decideModeSwitch('worker', 'rechazado', false)).toMatchObject({
      code: 'WORKER_REJECTED',
    });
    expect(hasName('  ')).toBe(false);
    expect(hasName('Ana')).toBe(true);
    expect(hasName(null)).toBe(false);
  });

  it.each([
    [null, 'WORKER_NOT_REQUESTED', 'COMPLETE_VERIFICATION', 'Completa tu verificación'],
    ['sin_solicitar', 'WORKER_NOT_REQUESTED', 'COMPLETE_VERIFICATION', 'Completa tu verificación'],
    [
      'pendiente_revision',
      'WORKER_UNDER_REVIEW',
      'VIEW_REVIEW_STATUS',
      'Ver el estado de tu solicitud',
    ],
    ['rechazado', 'WORKER_REJECTED', 'RESUBMIT_VERIFICATION', 'Corregir y reenviar'],
    ['bloqueado_deuda', 'WORKER_BLOCKED_DEBT', 'PAY_COMMISSION', 'Paga tu comisión pendiente'],
    ['suspendido_moderacion', 'WORKER_SUSPENDED', 'CONTACT_SUPPORT', 'Contactar a soporte'],
  ] as const)('%s → %s con acción %s', (status, code, nextAction, actionLabel) => {
    const decision = decideModeSwitch('worker', status);
    expect(decision).toMatchObject({ allowed: false, code, nextAction, actionLabel });
    expect(decision.allowed || decision.message.length > 10).toBe(true);
  });
});
