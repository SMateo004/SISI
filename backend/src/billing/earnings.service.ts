import { Injectable } from '@nestjs/common';
import { FeatureFlagsService } from '../feature-flags/feature-flags.service';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { BillingFilesService } from './billing-files.service';
import { BillingLedgerService } from './billing-ledger.service';
import { amountToUnlockCap, periodWindow } from './billing.rules';
import { DebtCapService } from './debt-cap.service';
import type {
  EarningsSummaryDto,
  MyPaymentDto,
  PayInfoDto,
  PaymentPageDto,
  PeriodPageDto,
  PeriodSummaryDto,
} from './dto/earnings.dto';
import { PAYMENT_GATEWAY_FLAG } from './payment-gateway';

const ZERO = new Prisma.Decimal(0);
const PAGE = 20;
const money = (d: Prisma.Decimal): string => d.toFixed(2);

/**
 * Ganancias y pagos del trabajador (R8, ADR-0037). Solo sus propios datos. Montos siempre
 * como texto con 2 decimales. El saldo es la suma del ledger.
 */
@Injectable()
export class EarningsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly ledger: BillingLedgerService,
    private readonly cap: DebtCapService,
    private readonly files: BillingFilesService,
    private readonly flags: FeatureFlagsService,
  ) {}

  async summary(workerId: string, now: Date = new Date()): Promise<EarningsSummaryDto> {
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: workerId },
      select: {
        cityId: true,
        city: { select: { timezone: true } },
        workerProfile: { select: { status: true } },
      },
    });
    const window = periodWindow(now, this.ledger.calendar(user.city.timezone));
    const current = await this.prisma.billingPeriod.findUnique({
      where: { workerId_startAt: { workerId, startAt: window.startAt } },
    });
    const balances = await this.periodBalances(workerId);
    const balance = await this.ledger.workerBalance(this.prisma, workerId);
    const unpaid = await this.prisma.billingPeriod.findMany({
      where: { workerId, status: { in: ['cerrado_pendiente', 'vencido'] } },
      orderBy: { dueAt: 'asc' },
      select: { id: true, dueAt: true, status: true },
    });
    const catchUp = unpaid.reduce(
      (acc, p) => acc.add(Prisma.Decimal.max(balances.get(p.id) ?? ZERO, ZERO)),
      ZERO,
    );
    const gross = current?.grossBs ?? ZERO;
    const commission = current?.commissionBs ?? ZERO;
    return {
      currentPeriod: {
        id: current?.id ?? null,
        startAt: window.startAt.toISOString(),
        endAt: window.endAt.toISOString(),
        dueAt: window.dueAt.toISOString(),
        grossBs: money(gross),
        commissionBs: money(commission),
        netBs: money(gross.sub(commission)),
        paymentReference: current?.paymentReference ?? null,
      },
      balanceBs: money(balance),
      overdueOrPendingBs: money(catchUp),
      nextDueAt:
        unpaid[0]?.dueAt.toISOString() ??
        (balance.gt(0) && current ? current.dueAt.toISOString() : null),
      overdue: unpaid.some((p) => p.status === 'vencido'),
      blocked: user.workerProfile?.status === 'bloqueado_deuda',
      debtCap: {
        capBs: money(this.cap.cap),
        reached: balance.gt(this.cap.cap),
        amountToUnlockBs: money(amountToUnlockCap(balance, this.cap.cap)),
      },
    };
  }

  async periods(workerId: string, cursor?: string): Promise<PeriodPageDto> {
    const rows = await this.prisma.billingPeriod.findMany({
      where: { workerId },
      orderBy: [{ startAt: 'desc' }, { id: 'desc' }],
      take: PAGE + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, PAGE);
    const balances = await this.periodBalances(workerId);
    return {
      items: page.map((p): PeriodSummaryDto => ({
        id: p.id,
        startAt: p.startAt.toISOString(),
        endAt: p.endAt.toISOString(),
        dueAt: p.dueAt.toISOString(),
        status: p.status,
        grossBs: money(p.grossBs),
        commissionBs: money(p.commissionBs),
        netBs: money(p.grossBs.sub(p.commissionBs)),
        balanceBs: money(balances.get(p.id) ?? ZERO),
        paymentReference: p.paymentReference,
      })),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  async payments(workerId: string, cursor?: string): Promise<PaymentPageDto> {
    const rows = await this.prisma.payment.findMany({
      where: { workerId },
      orderBy: [{ paidAt: 'desc' }, { id: 'desc' }],
      take: PAGE + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
      include: {
        entries: {
          select: {
            amountBs: true,
            period: { select: { id: true, paymentReference: true, startAt: true } },
          },
        },
      },
    });
    const page = rows.slice(0, PAGE);
    return {
      items: await Promise.all(
        page.map(async (p): Promise<MyPaymentDto> => ({
          id: p.id,
          amountBs: money(p.amountBs),
          paidAt: p.paidAt.toISOString(),
          method: p.method,
          status: 'registrado',
          reference: p.reference,
          periods: [...p.entries]
            .sort((a, b) => a.period.startAt.getTime() - b.period.startAt.getTime())
            .map((e) => ({
              periodId: e.period.id,
              paymentReference: e.period.paymentReference,
              amountBs: money(e.amountBs.neg()),
            })),
          receiptUrl: p.receiptKey ? await this.files.signed(p.receiptKey) : null,
        })),
      ),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  /** Pantalla "Pagar comisión": QR, montos exactos, referencia e instrucciones. */
  async payInfo(workerId: string, now: Date = new Date()): Promise<PayInfoDto> {
    const summary = await this.summary(workerId, now);
    const oldest = await this.prisma.billingPeriod.findFirst({
      where: { workerId, status: { in: ['vencido', 'cerrado_pendiente'] } },
      orderBy: { startAt: 'asc' },
      select: { paymentReference: true, dueAt: true },
    });
    const reference = oldest?.paymentReference ?? summary.currentPeriod.paymentReference;
    const user = await this.prisma.user.findUniqueOrThrow({
      where: { id: workerId },
      select: { cityId: true },
    });
    return {
      qrUrl: await this.files.qrUrl(),
      catchUpAmountBs: summary.overdueOrPendingBs,
      unlockAmountBs: summary.debtCap.amountToUnlockBs,
      totalBalanceBs: summary.balanceBs,
      paymentReference: reference,
      dueAt: oldest?.dueAt.toISOString() ?? null,
      instructions: [
        'Abre la app de tu banco y escanea el QR de SISI.',
        'Paga el monto exacto que ves aquí.',
        reference
          ? `Escribe la referencia ${reference} en la glosa de la transferencia.`
          : 'Escribe tu número de celular en la glosa de la transferencia.',
        'Sube la foto de tu comprobante: lo verificamos y te avisamos.',
      ],
      gatewayEnabled: await this.flags.isEnabled(PAYMENT_GATEWAY_FLAG, user.cityId),
    };
  }

  private async periodBalances(workerId: string): Promise<Map<string, Prisma.Decimal>> {
    const rows = await this.prisma.$queryRaw<{ periodId: string; balance: string }[]>`
      SELECT period_id AS "periodId", SUM(amount_bs)::text AS balance
      FROM ledger_entries WHERE worker_id = ${workerId}::uuid GROUP BY period_id`;
    return new Map(rows.map((r) => [r.periodId, new Prisma.Decimal(r.balance)]));
  }
}
