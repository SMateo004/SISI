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
  // R1.3 ampliada: sin nombre no se pasa a modo trabajador.
  await t.prisma.user.update({ where: { id: userId }, data: { name: 'Trabajador de prueba' } });
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

/**
 * Solicitud de trabajador enviada (pendiente_revision), con documentos registrados (las
 * claves no necesitan existir en el bucket para firmar una URL).
 */
export async function createPendingWorker(
  t: TestApp,
  opts: { birthDate?: string; categorySlugs?: string[] } = {},
): Promise<TestWorker> {
  const session = await login(t);
  const userId = session.user.id;
  await t.prisma.user.update({ where: { id: userId }, data: { name: 'Trabajador de prueba' } });
  const categories = await t.prisma.category.findMany({
    where: { slug: { in: opts.categorySlugs ?? ['plomeria'] } },
    select: { id: true },
  });
  await t.app.get(WorkerStatusService).apply(userId, { type: 'SUBMIT' }, null, async (tx) => {
    await tx.workerProfile.update({
      where: { userId },
      data: {
        transport: 'moto',
        maxRadiusKm: 5,
        birthDate: new Date(opts.birthDate ?? '1995-05-10'),
        submittedAt: new Date(),
        categories: { create: categories.map((c) => ({ categoryId: c.id })) },
        documents: {
          create: (['ci_front', 'ci_back', 'selfie'] as const).map((type) => ({
            type,
            fileKey: `identity/${userId}/${type}-e2e.jpg`,
            contentType: 'image/jpeg',
            sizeBytes: 1000,
          })),
        },
      },
    });
  });
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
