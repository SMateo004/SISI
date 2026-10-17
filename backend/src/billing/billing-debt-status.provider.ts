import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import type { DebtStatusProvider } from '../workers/worker.ports';

/**
 * Deuda vencida (R7.7, ADR-0038): algún periodo `vencido`. Un periodo vencido siempre tiene
 * saldo > 0: los pagos y ajustes lo recalculan y pasa a `pagado` al cubrirse.
 */
@Injectable()
export class BillingDebtStatusProvider implements DebtStatusProvider {
  constructor(private readonly prisma: PrismaService) {}

  async hasOverdueDebt(userId: string): Promise<boolean> {
    const overdue = await this.prisma.billingPeriod.count({
      where: { workerId: userId, status: 'vencido' },
    });
    return overdue > 0;
  }
}
