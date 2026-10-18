import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { User } from '../generated/prisma/client';
import { WorkerAvailabilityService } from '../locations/worker-availability.service';
import { PrismaService } from '../prisma/prisma.service';
import { decideModeSwitch, hasName } from './mode-switch.rules';

/** Interruptor empleador / trabajador (R1.5, R1.6). */
@Injectable()
export class ModeService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly availability: WorkerAvailabilityService,
  ) {}

  async switchMode(userId: string, target: 'employer' | 'worker'): Promise<User> {
    if (target === 'employer') {
      // En modo empleador no recibe solicitudes: deja de estar disponible (ADR-0024).
      return this.prisma.$transaction(async (tx) => {
        await this.availability.markUnavailable(tx, userId);
        return tx.user.update({ where: { id: userId }, data: { activeMode: 'employer' } });
      });
    }

    // Condición atómica: solo pasa a worker si en este instante el perfil está aprobado y la
    // cuenta tiene nombre (R1.3 ampliada).
    const { count } = await this.prisma.user.updateMany({
      where: {
        id: userId,
        name: { not: null },
        workerProfile: { is: { status: 'aprobado' } },
      },
      data: { activeMode: 'worker' },
    });
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: userId },
      select: { name: true, workerProfile: { select: { status: true } } },
    });
    if (count === 0 || !hasName(user.name)) {
      if (count > 0) {
        // Un nombre en blanco no cuenta: se deshace el cambio.
        await this.prisma.user.update({ where: { id: userId }, data: { activeMode: 'employer' } });
      }
      const decision = decideModeSwitch(
        'worker',
        user.workerProfile?.status ?? null,
        hasName(user.name),
      );
      if (decision.allowed) {
        throw new ApiError(
          HttpStatus.CONFLICT,
          'WORKER_STATUS_CHANGED',
          'Tu estado cambió mientras se procesaba. Intenta de nuevo.',
        );
      }
      const { allowed: _allowed, code, message, ...extra } = decision;
      throw new ApiError(HttpStatus.CONFLICT, code, message, extra);
    }
    return this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
  }
}
