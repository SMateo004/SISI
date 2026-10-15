import {
  type CandidateRow,
  exclusionOf,
  selectCandidates,
  type SelectionContext,
} from './candidates';
import { expectedMatchingJob } from './expected-job';
import { parseRings } from './matching.config';
import { closeDecision, closeDelay, nextStep, shouldExpand } from './ring-plan';

const NOW = 1_800_000_000_000;
const RINGS = parseRings('2:5,5:10,10:10');

const row = (over: Partial<CandidateRow> = {}): CandidateRow => ({
  workerId: 'w1',
  status: 'aprobado',
  activeMode: 'worker',
  available: true,
  locatedAt: new Date(NOW - 60_000),
  hasCategory: true,
  maxRadiusKm: 10,
  distanceM: 800,
  ratingAvg: 4.5,
  alreadyNotified: false,
  ...over,
});

const ctx = (over: Partial<SelectionContext> = {}): SelectionContext => ({
  ring: { maxKm: 2, limit: 5 },
  employerId: 'empleador',
  now: NOW,
  staleLocationMs: 600_000,
  debtEligible: () => true,
  ...over,
});

describe('Selección de candidatos (R4.1, ADR-0025)', () => {
  it('un trabajador que cumple todo es candidato', () => {
    expect(exclusionOf(row(), ctx())).toBeNull();
  });

  it.each([
    ['no_aprobado', row({ status: 'pendiente_revision' })],
    ['no_aprobado', row({ status: 'bloqueado_deuda' })],
    ['no_aprobado', row({ status: 'suspendido_moderacion' })],
    ['no_modo_trabajador', row({ activeMode: 'employer' })],
    ['no_disponible', row({ available: false })],
    ['ubicacion_vencida', row({ locatedAt: new Date(NOW - 600_001) })],
    ['ubicacion_vencida', row({ locatedAt: null })],
    ['sin_categoria', row({ hasCategory: false })],
    ['fuera_de_su_radio', row({ maxRadiusKm: 1, distanceM: 1500 })],
    ['fuera_de_su_radio', row({ maxRadiusKm: null })],
    ['fuera_del_anillo', row({ distanceM: 2001 })],
    ['ya_notificado', row({ alreadyNotified: true })],
  ] as const)('excluye: %s', (reason, candidate) => {
    expect(exclusionOf(candidate, ctx())).toBe(reason);
  });

  it('excluye al propio empleador (la misma cuenta tiene los dos modos)', () => {
    expect(exclusionOf(row({ workerId: 'empleador' }), ctx())).toBe('es_el_empleador');
  });

  it('el hook de tope de deuda puede excluir (Fase 5)', () => {
    expect(exclusionOf(row(), ctx({ debtEligible: (id) => id !== 'w1' }))).toBe('tope_de_deuda');
  });

  it('en el límite del radio del trabajador y del anillo todavía entra', () => {
    expect(exclusionOf(row({ maxRadiusKm: 2, distanceM: 2000 }), ctx())).toBeNull();
  });

  it('ordena por distancia y desempata por calificación; corta al límite del anillo', () => {
    const rows = [
      row({ workerId: 'lejos', distanceM: 1900 }),
      row({ workerId: 'cerca-3', distanceM: 300, ratingAvg: 3 }),
      row({ workerId: 'cerca-5', distanceM: 300, ratingAvg: 5 }),
      row({ workerId: 'medio', distanceM: 900 }),
      row({ workerId: 'empleador', distanceM: 10 }),
      row({ workerId: 'otro', distanceM: 1000 }),
      row({ workerId: 'mas', distanceM: 1100 }),
      row({ workerId: 'ocupado', distanceM: 50, available: false }),
    ];
    const chosen = selectCandidates(rows, ctx());
    expect(chosen.map((c) => c.workerId)).toEqual(['cerca-5', 'cerca-3', 'medio', 'otro', 'mas']);
  });

  it('anillo 2: hasta 5 km y hasta 10 candidatos nuevos', () => {
    const rows = Array.from({ length: 14 }, (_, i) =>
      row({ workerId: `w${String(i).padStart(2, '0')}`, distanceM: 2500 + i * 100 }),
    );
    rows.push(row({ workerId: 'ya', distanceM: 100, alreadyNotified: true }));
    const chosen = selectCandidates(rows, ctx({ ring: { maxKm: 5, limit: 10 } }));
    expect(chosen).toHaveLength(10);
    expect(chosen.some((c) => c.workerId === 'ya')).toBe(false);
  });
});

describe('Progresión de anillos (R4.2, R4.3)', () => {
  const config = { rings: RINGS, ringWaitMs: 300 };

  it('lee MATCHING_RINGS y exige radios crecientes', () => {
    expect(RINGS).toEqual([
      { maxKm: 2, limit: 5 },
      { maxKm: 5, limit: 10 },
      { maxKm: 10, limit: 10 },
    ]);
    expect(() => parseRings('5:5,2:10')).toThrow(/más lejos/);
    expect(() => parseRings('2')).toThrow(/km:límite/);
    expect(() => parseRings('2:0')).toThrow(/km:límite/);
  });

  it('con avisos, espera el tiempo del anillo antes de ampliar', () => {
    expect(nextStep({ ring: 1, notifiedNow: 3, now: NOW, lastNotifiedAt: NOW, config })).toEqual({
      kind: 'ring',
      ring: 2,
      delayMs: 300,
    });
  });

  it('un anillo sin candidatos nuevos amplía de inmediato', () => {
    expect(nextStep({ ring: 1, notifiedNow: 0, now: NOW, lastNotifiedAt: null, config })).toEqual({
      kind: 'ring',
      ring: 2,
      delayMs: 0,
    });
  });

  it('tras el último anillo cierra, respetando el plazo del último aviso', () => {
    expect(nextStep({ ring: 3, notifiedNow: 2, now: NOW, lastNotifiedAt: NOW, config })).toEqual({
      kind: 'close',
      delayMs: 300,
    });
    // Último anillo vacío, pero el anillo 2 avisó hace 100 ms: quedan 200 ms.
    expect(
      nextStep({ ring: 3, notifiedNow: 0, now: NOW, lastNotifiedAt: NOW - 100, config }),
    ).toEqual({ kind: 'close', delayMs: 200 });
    // Nadie fue avisado en ningún anillo: cierra ya.
    expect(closeDelay(NOW, null, 300)).toBe(0);
  });

  it('con ofertas suficientes no amplía (el anillo 1 siempre corre)', () => {
    expect(shouldExpand(1, 5, 3)).toBe(true);
    expect(shouldExpand(2, 2, 3)).toBe(true);
    expect(shouldExpand(2, 3, 3)).toBe(false);
  });
});

describe('Cierre y expiración (R4.5)', () => {
  it('sin ofertas expira de inmediato', () => {
    expect(closeDecision(0, NOW, 600_000)).toEqual({ expireNow: true });
  });

  it('con ofertas sin elegir da el plazo de gracia', () => {
    expect(closeDecision(2, NOW, 600_000)).toEqual({ expireNow: false, expiresAt: NOW + 600_000 });
  });
});

describe('Reconciliador: job esperado (ADR-0022)', () => {
  const ctxR = { totalRings: 3, ringWaitMs: 45_000, now: NOW };
  const base = { id: 'r1', status: 'buscando' as const, ringStartedAt: null, expiresAt: null };

  it('sin anillo: el anillo 1', () => {
    expect(expectedMatchingJob({ ...base, ring: null }, ctxR)).toMatchObject({
      name: 'ring',
      jobId: 'ring_r1_1',
      data: { requestId: 'r1', ring: 1 },
    });
  });

  it('a mitad de búsqueda: el anillo siguiente con la espera que le queda', () => {
    const job = expectedMatchingJob(
      { ...base, ring: 1, ringStartedAt: new Date(NOW - 40_000) },
      ctxR,
    );
    expect(job).toMatchObject({ jobId: 'ring_r1_2', delayMs: 5_000 });
  });

  it('tras el último anillo: el cierre; con plazo de elección: la expiración', () => {
    expect(
      expectedMatchingJob({ ...base, ring: 3, ringStartedAt: new Date(NOW - 60_000) }, ctxR),
    ).toMatchObject({ name: 'close', jobId: 'close_r1', delayMs: 0 });
    expect(
      expectedMatchingJob(
        { ...base, status: 'con_ofertas', ring: 3, expiresAt: new Date(NOW + 1_000) },
        ctxR,
      ),
    ).toMatchObject({ name: 'expire', jobId: 'expire_r1', delayMs: 1_000 });
  });
});
