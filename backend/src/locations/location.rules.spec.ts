import { canBeAvailable, shouldPersist } from './location.rules';

describe('Ubicación del trabajador (ADR-0024)', () => {
  const limits = { persistMs: 30_000, persistM: 100 };
  const base = { lat: -17.7834, lng: -63.1821 };
  // ~0,00095° de longitud ≈ 100 m a esta latitud.
  const east = (m: number) => ({ lat: base.lat, lng: base.lng + m / 106_000 });

  it('sin punto previo, persiste', () => {
    expect(shouldPersist(null, base, 0, limits)).toBe(true);
  });

  it('quieto: persiste solo cuando pasan 30 s', () => {
    const last = { ...base, at: 1_000 };
    expect(shouldPersist(last, base, 1_000 + 29_999, limits)).toBe(false);
    expect(shouldPersist(last, base, 1_000 + 30_000, limits)).toBe(true);
  });

  it('en movimiento: persiste al pasar los 100 m aunque no hayan pasado 30 s', () => {
    const last = { ...base, at: 1_000 };
    expect(shouldPersist(last, east(50), 2_000, limits)).toBe(false);
    expect(shouldPersist(last, east(120), 2_000, limits)).toBe(true);
  });

  it('disponible exige perfil aprobado y modo worker', () => {
    expect(canBeAvailable({ activeMode: 'worker', status: 'aprobado' })).toEqual({ allowed: true });
    expect(canBeAvailable({ activeMode: 'employer', status: 'aprobado' })).toMatchObject({
      allowed: false,
      code: 'WORKER_MODE_REQUIRED',
    });
    expect(canBeAvailable({ activeMode: 'worker', status: 'bloqueado_deuda' })).toMatchObject({
      allowed: false,
      code: 'WORKER_BLOCKED_DEBT',
    });
    expect(canBeAvailable({ activeMode: 'employer', status: null })).toMatchObject({
      code: 'WORKER_NOT_REQUESTED',
    });
  });
});
