/** Plazo para calificar (ADR-0032): desde que terminó el trabajo. Función pura. */
export function reviewDeadline(completedAt: Date | null, windowMs: number): Date | null {
  return completedAt ? new Date(completedAt.getTime() + windowMs) : null;
}

/** Se puede calificar: terminado, dentro del plazo y todavía sin calificación propia. */
export function canReview(
  job: { status: string; completedAt: Date | null },
  alreadyReviewed: boolean,
  now: number,
  windowMs: number,
): boolean {
  const deadline = reviewDeadline(job.completedAt, windowMs);
  return job.status === 'terminado' && !alreadyReviewed && !!deadline && now < deadline.getTime();
}
