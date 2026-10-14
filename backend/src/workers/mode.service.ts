import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { User } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { decideModeSwitch } from './mode-switch.rules';

/** Interruptor empleador / trabajador (R1.5, R1.6). */
@Injectable()
export class ModeService {
  constructor(private readonly prisma: PrismaService) {}

  async switchMode(userId: string, target: 'employer' | 'worker'): Promise<User> {
    if (target === 'employer') {
      return this.prisma.user.update({ where: { id: userId }, data: { activeMode: 'employer' } });
    }

    // Condición atómica: solo pasa a worker si en este instante el perfil está aprobado.
    const { count } = await this.prisma.user.updateMany({
      where: { id: userId, workerProfile: { is: { status: 'aprobado' } } },
      data: { activeMode: 'worker' },
    });
    if (count === 0) {
      const profile = await this.prisma.workerProfile.findUnique({
        where: { userId },
        select: { status: true },
      });
      const decision = decideModeSwitch('worker', profile?.status ?? null);
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
