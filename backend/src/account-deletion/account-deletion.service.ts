import { createHmac } from 'node:crypto';
import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import { EarningsService } from '../billing/earnings.service';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { ACTIVE_JOB_STATUSES } from '../jobs/job-status.machine';
import { WorkerAvailabilityService } from '../locations/worker-availability.service';
import { closeActiveOffers } from '../offers/offer-events';
import { withdrawLockedOffer } from '../offers/offer-withdrawal';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { lockRequest } from '../requests/request-lock';
import { RequestStatusService } from '../requests/request-status.service';

/** Clave de Redis que corta al instante los tokens de acceso vigentes de una cuenta eliminada. */
export const deletedKey = (userId: string) => `account:deleted:${userId}`;

export type DeletionBlocker =
  | { code: 'ACCOUNT_IS_ADMIN'; message: string }
  | { code: 'ACCOUNT_HAS_ACTIVE_JOB'; message: string }
  | { code: 'ACCOUNT_HAS_PENDING_PAYMENT'; message: string }
  | {
      code: 'ACCOUNT_HAS_DEBT';
      message: string;
      balanceBs: string;
      paymentReference: string | null;
    };

const OPEN_REQUEST = ['borrador', 'retenida', 'buscando', 'con_ofertas'] as const;

/**
 * Eliminación de cuenta (ADR-0049): las tiendas la exigen y convive con el ledger y las
 * auditorías inmutables. No se borra la fila del usuario: se anonimiza (nombre, teléfono, foto,
 * documentos, fecha de nacimiento y ubicación) y se conservan con su id los movimientos
 * contables, los trabajos y los historiales. No se puede con deuda, con un trabajo activo o con
 * un comprobante por revisar: primero se resuelve.
 */
@Injectable()
export class AccountDeletionService {
  private readonly logger = new Logger(AccountDeletionService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly earnings: EarningsService,
    private readonly status: RequestStatusService,
    private readonly outbox: OutboxService,
    private readonly availability: WorkerAvailabilityService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  /** Lo que impide eliminar la cuenta hoy (vacío: se puede). */
  async blockers(userId: string): Promise<DeletionBlocker[]> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: { workerProfile: { select: { userId: true } } },
    });
    if (!user || user.deletedAt) return [];
    const blockers: DeletionBlocker[] = [];
    if (user.role === 'admin') {
      blockers.push({
        code: 'ACCOUNT_IS_ADMIN',
        message:
          'Una cuenta de administrador no se elimina desde la app. Pide que te quiten el rol.',
      });
    }
    const activeJob = await this.prisma.job.findFirst({
      where: {
        status: { in: [...ACTIVE_JOB_STATUSES] },
        OR: [{ workerId: userId }, { employerId: userId }],
      },
      select: { id: true },
    });
    if (activeJob) {
      blockers.push({
        code: 'ACCOUNT_HAS_ACTIVE_JOB',
        message: 'Tienes un trabajo en curso. Termínalo o cancélalo antes de eliminar tu cuenta.',
      });
    }
    if (user.workerProfile) {
      const pending = await this.prisma.paymentSubmission.count({
        where: { workerId: userId, status: 'pendiente' },
      });
      if (pending > 0) {
        blockers.push({
          code: 'ACCOUNT_HAS_PENDING_PAYMENT',
          message:
            'Estamos revisando un comprobante tuyo. Espera la respuesta antes de eliminar tu cuenta.',
        });
      }
      const info = await this.earnings.payInfo(userId);
      if (Number(info.totalBalanceBs) > 0) {
        blockers.push({
          code: 'ACCOUNT_HAS_DEBT',
          message: `Tienes una comisión pendiente de Bs ${info.totalBalanceBs.replace('.', ',')}. Págala para poder eliminar tu cuenta.`,
          balanceBs: info.totalBalanceBs,
          paymentReference: info.paymentReference,
        });
      }
    }
    return blockers;
  }

  /** Elimina y anonimiza. Idempotente: una cuenta ya eliminada no cambia. */
  async delete(userId: string, source: 'app' | 'web'): Promise<void> {
    const blockers = await this.blockers(userId);
    const [first] = blockers;
    if (first) {
      throw new ApiError(HttpStatus.CONFLICT, first.code, first.message, { blockers });
    }
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      include: { workerProfile: { include: { documents: true } } },
    });
    if (user.deletedAt) return;

    const files: string[] = [];
    await this.prisma.$transaction(async (tx) => {
      // Solicitudes abiertas como empleador: se cancelan como lo haría él (ADR-0019).
      const open = await tx.serviceRequest.findMany({
        where: { employerId: userId, status: { in: [...OPEN_REQUEST] } },
        select: { id: true },
      });
      for (const r of open) {
        await this.status.apply(
          r.id,
          'CANCEL',
          userId,
          {
            data: { cancelReason: 'empleador', cancelledAt: new Date() },
            reason: 'cuenta eliminada',
          },
          tx,
        );
        await closeActiveOffers(tx, r.id);
        await this.outbox.add(tx, 'request.cancelled', r.id, { requestId: r.id });
      }

      // Ofertas activas como trabajador: se retiran (si era la única, la solicitud vuelve a buscar).
      const offers = await tx.offer.findMany({
        where: { workerId: userId, status: 'activa' },
        select: { id: true, requestId: true },
      });
      for (const offer of offers) {
        const request = await lockRequest(tx, offer.requestId);
        if (!request) continue;
        await withdrawLockedOffer(
          tx,
          { status: this.status, outbox: this.outbox },
          request,
          offer.id,
          userId,
        );
      }

      // Fotos de sus solicitudes (casas, objetos): fuera del bucket; la dirección se borra y el
      // punto queda a ~1 km (sirve para las métricas por zona, no para ubicar a nadie).
      const photos = await tx.serviceRequestPhoto.findMany({
        where: { request: { employerId: userId } },
        select: { id: true, fileKey: true },
      });
      files.push(...photos.map((p) => p.fileKey));
      await tx.serviceRequestPhoto.deleteMany({ where: { id: { in: photos.map((p) => p.id) } } });
      await tx.$executeRaw`
        UPDATE service_requests
        SET address = 'Dirección eliminada',
            geog = ST_SnapToGrid(geog::geometry, 0.01)::geography
        WHERE employer_id = ${userId}::uuid`;

      // Trabajador: documentos, fecha de nacimiento y ubicación.
      if (user.workerProfile) {
        await this.availability.markUnavailable(tx, userId);
        const locations = await tx.workerLocation.findMany({
          where: { workerId: userId },
          select: { cityId: true },
        });
        for (const l of locations) this.availability.dropLive(userId, l.cityId);
        await tx.workerLocation.deleteMany({ where: { workerId: userId } });
        files.push(...user.workerProfile.documents.map((d) => d.fileKey));
        await tx.workerDocument.deleteMany({ where: { workerId: userId } });
        await tx.workerProfile.update({ where: { userId }, data: { birthDate: null } });
      }

      if (user.photoKey) files.push(user.photoKey);
      await tx.refreshToken.deleteMany({ where: { userId } });
      await tx.deviceToken.deleteMany({ where: { userId } });
      await tx.notification.deleteMany({ where: { userId } });
      await tx.user.update({
        where: { id: userId },
        data: {
          phone: `eliminado:${userId}`,
          name: null,
          photoKey: null,
          activeMode: 'employer',
          deletedAt: new Date(),
        },
      });
      await tx.accountDeletion.create({
        data: {
          userId,
          phoneHmac: this.phoneHmac(user.phone),
          source,
          hadWorkerProfile: user.workerProfile !== null,
        },
      });
      // Los archivos se borran en el worker (idempotente, con reintentos).
      await this.outbox.add(tx, 'account.deleted', userId, { userId, fileKeys: files });
    });

    // Corta los tokens de acceso vigentes (los refresh ya se borraron).
    await this.redis.set(
      deletedKey(userId),
      '1',
      'EX',
      this.config.get('JWT_ACCESS_TTL_SEC', { infer: true }),
    );
    this.logger.log(
      `Cuenta ${userId} eliminada y anonimizada (${source}, ${String(files.length)} archivos)`,
    );
  }

  /** HMAC del teléfono: permite reconocer que el número volvió sin guardar el número. */
  phoneHmac(phoneE164: string): string {
    return createHmac('sha256', this.config.get('JWT_REFRESH_SECRET', { infer: true }))
      .update(`account-deletion:${phoneE164}`)
      .digest('hex');
  }
}
