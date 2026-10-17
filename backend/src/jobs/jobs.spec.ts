import { Prisma } from '../generated/prisma/client';
import { commissionOf, netOf } from './commission';
import {
  allowedJobActions,
  JobActionForbiddenError,
  type JobSnapshot,
  nextJobStatus,
  JobTransitionError,
} from './job-status.machine';

const at = new Date('2026-10-16T12:00:00Z');
const job = (over: Partial<JobSnapshot> = {}): JobSnapshot => ({
  status: 'asignado',
  workerFinishedAt: null,
  disputedAt: null,
  ...over,
});

describe('máquina de estados del trabajo (R6.1, ADR-0029)', () => {
  it('ciclo completo con los actores correctos', () => {
    expect(nextJobStatus(job(), 'START_TRIP', 'worker')).toBe('en_camino');
    expect(nextJobStatus(job({ status: 'en_camino' }), 'START_WORK', 'worker')).toBe('en_curso');
    expect(nextJobStatus(job({ status: 'en_curso' }), 'FINISH', 'worker')).toBe('en_curso');
    expect(
      nextJobStatus(job({ status: 'en_curso', workerFinishedAt: at }), 'CONFIRM', 'employer'),
    ).toBe('terminado');
  });

  it('el empleador no mueve el trabajo por el trabajador, ni al revés (403)', () => {
    expect(() => nextJobStatus(job(), 'START_TRIP', 'employer')).toThrow(JobActionForbiddenError);
    expect(() => nextJobStatus(job({ status: 'en_camino' }), 'START_WORK', 'employer')).toThrow(
      JobActionForbiddenError,
    );
    expect(() => nextJobStatus(job({ status: 'en_curso' }), 'CONFIRM', 'worker')).toThrow(
      JobActionForbiddenError,
    );
    expect(() => nextJobStatus(job({ status: 'en_curso' }), 'AUTO_CONFIRM', 'employer')).toThrow(
      JobActionForbiddenError,
    );
    expect(() =>
      nextJobStatus(job({ status: 'en_curso', disputedAt: at }), 'RESOLVE_CONFIRM', 'employer'),
    ).toThrow(JobActionForbiddenError);
  });

  it.each(['asignado', 'en_camino', 'terminado', 'cancelado'] as const)(
    '"Terminé" solo desde en_curso: rechazado desde %s (409)',
    (status) => {
      expect(() => nextJobStatus(job({ status }), 'FINISH', 'worker')).toThrow(JobTransitionError);
    },
  );

  it('"Terminé" dos veces no vale', () => {
    expect(() =>
      nextJobStatus(job({ status: 'en_curso', workerFinishedAt: at }), 'FINISH', 'worker'),
    ).toThrow('Ya marcaste el trabajo como terminado.');
  });

  it('no se salta pasos', () => {
    expect(() => nextJobStatus(job(), 'START_WORK', 'worker')).toThrow(JobTransitionError);
    expect(() => nextJobStatus(job(), 'CONFIRM', 'employer')).toThrow(JobTransitionError);
    expect(() => nextJobStatus(job({ status: 'en_camino' }), 'CONFIRM', 'employer')).toThrow(
      JobTransitionError,
    );
  });

  it('autoconfirmación: solo con "Terminé" y sin disputa', () => {
    expect(() => nextJobStatus(job({ status: 'en_curso' }), 'AUTO_CONFIRM', 'system')).toThrow(
      JobTransitionError,
    );
    expect(
      nextJobStatus(job({ status: 'en_curso', workerFinishedAt: at }), 'AUTO_CONFIRM', 'system'),
    ).toBe('terminado');
    expect(() =>
      nextJobStatus(
        job({ status: 'en_curso', workerFinishedAt: at, disputedAt: at }),
        'AUTO_CONFIRM',
        'system',
      ),
    ).toThrow(JobTransitionError);
  });

  it('disputa: después del "Terminé"; frena la confirmación y la resuelve el admin', () => {
    expect(() => nextJobStatus(job({ status: 'en_curso' }), 'DISPUTE', 'employer')).toThrow(
      JobTransitionError,
    );
    const finished = job({ status: 'en_curso', workerFinishedAt: at });
    expect(nextJobStatus(finished, 'DISPUTE', 'employer')).toBe('en_curso');
    const disputed = { ...finished, disputedAt: at };
    expect(() => nextJobStatus(disputed, 'DISPUTE', 'employer')).toThrow(JobTransitionError);
    expect(() => nextJobStatus(disputed, 'CONFIRM', 'employer')).toThrow(JobTransitionError);
    expect(nextJobStatus(disputed, 'RESOLVE_CONFIRM', 'admin')).toBe('terminado');
    expect(nextJobStatus(disputed, 'RESOLVE_CANCEL', 'admin')).toBe('cancelado');
    expect(() => nextJobStatus(finished, 'RESOLVE_CONFIRM', 'admin')).toThrow(JobTransitionError);
  });

  it('acciones permitidas por rol (para los botones de la app)', () => {
    expect(allowedJobActions(job(), 'worker')).toEqual(['START_TRIP', 'CANCEL']);
    expect(allowedJobActions(job(), 'employer')).toEqual(['CANCEL']);
    expect(allowedJobActions(job({ status: 'en_curso' }), 'worker')).toEqual(['FINISH']);
    expect(allowedJobActions(job({ status: 'en_curso' }), 'employer')).toEqual(['CONFIRM']);
    expect(
      allowedJobActions(job({ status: 'en_curso', workerFinishedAt: at }), 'employer'),
    ).toEqual(['CONFIRM', 'DISPUTE']);
    expect(allowedJobActions(job({ status: 'terminado' }), 'worker')).toEqual([]);
  });
});

describe('comisión (R6.3, ADR-0030)', () => {
  const d = (v: string): Prisma.Decimal => new Prisma.Decimal(v);
  const commission = (price: string, pct: string): string =>
    commissionOf(d(price), d(pct)).toFixed(2);

  it('150 al 13 % → 19,50 de comisión y 130,50 neto', () => {
    const c = commissionOf(d('150.00'), d('13.00'));
    expect(c.toFixed(2)).toBe('19.50');
    expect(netOf(d('150.00'), c).toFixed(2)).toBe('130.50');
  });

  it.each([
    ['99.99', '13.00', '13.00'], // 12,9987 → 13,00
    ['10.05', '13.00', '1.31'], // 1,3065 → 1,31
    ['0.50', '13.00', '0.07'], // 0,065 → 0,07 (HALF_UP: la mitad sube)
    ['0.10', '13.00', '0.01'], // 0,013 → 0,01
    ['80.00', '13.00', '10.40'],
    ['123.45', '12.50', '15.43'], // 15,43125 → 15,43
    ['1.00', '0.00', '0.00'],
  ])('%s al %s %% → %s', (price, pct, expected) => {
    expect(commission(price, pct)).toBe(expected);
  });

  it('no pierde centavos con number: 0,1 + 0,2', () => {
    expect(commission('0.30', '100.00')).toBe('0.30');
  });
});
