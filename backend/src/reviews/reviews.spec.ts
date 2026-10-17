import { canReview, reviewDeadline } from './review.rules';

const WEEK = 7 * 24 * 3600_000;
const done = new Date('2026-10-16T12:00:00Z');

describe('plazo y permiso para calificar (ADR-0032)', () => {
  it('el plazo es de 7 días desde que terminó', () => {
    expect(reviewDeadline(done, WEEK)).toEqual(new Date('2026-10-23T12:00:00Z'));
    expect(reviewDeadline(null, WEEK)).toBeNull();
  });

  it('solo terminado, dentro del plazo y una vez', () => {
    const job = { status: 'terminado', completedAt: done };
    expect(canReview(job, false, done.getTime() + 1000, WEEK)).toBe(true);
    expect(canReview(job, true, done.getTime() + 1000, WEEK)).toBe(false);
    expect(canReview(job, false, done.getTime() + WEEK, WEEK)).toBe(false);
    for (const status of ['asignado', 'en_camino', 'en_curso', 'cancelado']) {
      expect(canReview({ status, completedAt: null }, false, done.getTime(), WEEK)).toBe(false);
    }
  });
});
