import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import { Prisma } from '../generated/prisma/client';
import type { DebtCapPolicy } from '../matching/debt-cap.policy';
import { NotificationsService } from '../notifications/notifications.service';
import { PrismaService } from '../prisma/prisma.service';
import { capTransition } from './billing.rules';

/**
 * Tope de deuda (R7.5, ADR-0038). El saldo pendiente es la suma de todo el ledger del
 * trabajador, incluido el periodo abierto. Por encima del tope no recibe solicitudes nuevas
 * (hook del matching y de las ofertas); no cambia su estado. Pagar lo libera de inmediato.
 */
@Injectable()
export class DebtCapService implements DebtCapPolicy {
  readonly cap: Prisma.Decimal;

  constructor(
    private readonly prisma: PrismaService,
    private readonly notifications: NotificationsService,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.cap = new Prisma.Decimal(config.get('BILLING_DEBT_CAP_BS', { infer: true }));
  }

  /** Trabajadores del lote que superan el tope (una sola consulta). */
  async ineligible(workerIds: string[]): Promise<Set<string>> {
    if (workerIds.length === 0) return new Set();
    const rows = await this.prisma.$queryRaw<{ workerId: string }[]>`
      SELECT worker_id AS "workerId" FROM ledger_entries
      WHERE worker_id = ANY(${workerIds}::uuid[])
      GROUP BY worker_id
      HAVING SUM(amount_bs) > ${this.cap.toFixed(2)}::numeric`;
    return new Set(rows.map((r) => r.workerId));
  }

  /**
   * Aviso al cruzar el tope, una sola vez hasta que baje: la marca `debt_cap_reached_at` se
   * pone con un UPDATE condicional (solo uno gana) y se limpia al bajar. Idempotente.
   */
  async check(workerId: string): Promise<'notify' | 'clear' | 'none'> {
    const [row] = await this.prisma.$queryRaw<{ balance: string }[]>`
      SELECT COALESCE(SUM(amount_bs), 0)::text AS balance
      FROM ledger_entries WHERE worker_id = ${workerId}::uuid`;
    const balance = new Prisma.Decimal(row?.balance ?? '0');
    const profile = await this.prisma.workerProfile.findUnique({
      where: { userId: workerId },
      select: { debtCapReachedAt: true },
    });
    const action = capTransition(balance, this.cap, profile?.debtCapReachedAt != null);
    if (action === 'notify') {
      const now = new Date();
      const { count } = await this.prisma.workerProfile.updateMany({
        where: { userId: workerId, debtCapReachedAt: null },
        data: { debtCapReachedAt: now },
      });
      if (count === 0) return 'none';
      const user = await this.prisma.user.findUniqueOrThrow({
        where: { id: workerId },
        select: { cityId: true },
      });
      await this.notifications.notify({
        userId: workerId,
        cityId: user.cityId,
        type: 'billing_cap_reached',
        data: { balanceBs: balance.toFixed(2), capBs: this.cap.toFixed(2) },
        dedupeKey: `billing:cap:${workerId}:${now.toISOString()}`,
      });
    } else if (action === 'clear') {
      await this.prisma.workerProfile.updateMany({
        where: { userId: workerId, debtCapReachedAt: { not: null } },
        data: { debtCapReachedAt: null },
      });
    }
    return action;
  }
}
