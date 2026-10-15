import request from 'supertest';
import type { LoginResponseDto } from '../../src/auth/dto/auth.dto';
import { WorkerStatusService } from '../../src/workers/worker-status.service';
import { CENTRO } from './requests';
import { bearer, login, type TestApp } from './test-app';

export interface TestWorker extends LoginResponseDto {
  id: string;
}

/**
 * Trabajador aprobado y en modo worker. El estado cambia solo con WorkerStatusService
 * (ADR-0013): SUBMIT con sus datos y APPROVE, como haría la revisión.
 */
export async function createApprovedWorker(
  t: TestApp,
  opts: {
    categorySlugs?: string[];
    transport?: 'a_pie' | 'bicicleta' | 'moto' | 'auto' | 'transporte_publico';
    maxRadiusKm?: number;
  } = {},
): Promise<TestWorker> {
  const session = await login(t);
  const userId = session.user.id;
  const categories = await t.prisma.category.findMany({
    where: { slug: { in: opts.categorySlugs ?? ['plomeria'] } },
    select: { id: true },
  });
  const statuses = t.app.get(WorkerStatusService);
  await statuses.apply(userId, { type: 'SUBMIT' }, null, async (tx) => {
    await tx.workerProfile.update({
      where: { userId },
      data: {
        transport: opts.transport ?? 'moto',
        maxRadiusKm: opts.maxRadiusKm ?? 10,
        birthDate: new Date('1995-05-10'),
        categories: { create: categories.map((c) => ({ categoryId: c.id })) },
      },
    });
  });
  await statuses.apply(userId, { type: 'APPROVE' }, null);
  await request(t.app.getHttpServer())
    .patch('/me/mode')
    .set(...bearer(session.accessToken))
    .send({ mode: 'worker' })
    .expect(200);
  return Object.assign(session, { id: userId });
}

/** Activa "Disponible" en el punto dado (por defecto, el centro de Santa Cruz). */
export async function makeAvailable(
  t: TestApp,
  worker: TestWorker,
  at: { latitude: number; longitude: number } = CENTRO,
): Promise<void> {
  await request(t.app.getHttpServer())
    .put('/worker/availability')
    .set(...bearer(worker.accessToken))
    .send({ available: true, ...at })
    .expect(200);
}
