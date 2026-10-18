import { HttpStatus, Injectable } from '@nestjs/common';
import type { AdminContext } from '../audit/admin-context';
import { assertNotSelf } from '../common/admin/self-review';
import { ApiError } from '../common/errors/api-error';
import { calendarDateIn } from '../common/time/age';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { BillingLedgerService } from './billing-ledger.service';
import { allocatePayment, periodStatus, periodWindow } from './billing.rules';
import type {
  AdjustmentPreviewDto,
  BalancePreviewDto,
  LedgerPageDto,
  OverdueListDto,
  PanelPeriodDto,
  PanelPeriodPageDto,
  PaymentPreviewDto,
  PeriodsQueryDto,
  PreviewAllocationDto,
} from './dto/billing-panel.dto';

const PAGE = 25;
const LEDGER_PAGE = 50;
const ZERO = new Prisma.Decimal(0);
const DAY_MS = 86_400_000;
const SELF = 'No puedes registrar pagos ni ajustes sobre tu propia cuenta de trabajador.';

/**
 * Lunes 00:00 UTC de una semana ISO ("2026-W42"). Un periodo empieza el lunes 00:00 local:
 * en cualquier zona cae entre 12 h antes y 15 h después de ese instante.
 */
export function isoWeekRange(week: string): { gte: Date; lt: Date } {
  const [y, w] = week.split('-W').map(Number) as [number, number];
  const jan4 = new Date(Date.UTC(y, 0, 4));
  const weekday = jan4.getUTCDay() === 0 ? 7 : jan4.getUTCDay();
  const monday = Date.UTC(y, 0, 4 - weekday + 1 + (w - 1) * 7);
  return { gte: new Date(monday - 12 * 3600_000), lt: new Date(monday + 15 * 3600_000) };
}

/** Días de atraso: el día siguiente al plazo (jueves, si vence el "miércoles 23:59") es 1. */
export function daysLate(dueAt: Date, now: Date, timeZone: string): number {
  const due = calendarDateIn(dueAt, timeZone);
  const today = calendarDateIn(now, timeZone);
  const days =
    (Date.UTC(today.year, today.month - 1, today.day) -
      Date.UTC(due.year, due.month - 1, due.day)) /
    DAY_MS;
  return Math.max(0, days + 1);
}

/** Consultas de cobros para el panel (permiso `cobros`). No cambian nada. */
@Injectable()
export class BillingPanelService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly ledger: BillingLedgerService,
  ) {}

  async periods(query: PeriodsQueryDto): Promise<PanelPeriodPageDto> {
    const rows = await this.prisma.billingPeriod.findMany({
      where: {
        ...(query.status ? { status: query.status } : {}),
        ...(query.cityId ? { cityId: query.cityId } : {}),
        ...(query.week ? { startAt: isoWeekRange(query.week) } : {}),
      },
      orderBy: [{ startAt: 'desc' }, { id: 'asc' }],
      take: PAGE + 1,
      ...(query.cursor ? { cursor: { id: query.cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, PAGE);
    const [balances, workers] = await Promise.all([
      this.balances(page.map((p) => p.id)),
      this.workers(page.map((p) => p.workerId)),
    ]);
    return {
      items: page.map((p) => this.toRow(p, balances, workers)),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id ?? null) : null,
    };
  }

  /** Vencidos (R7.7), del que más atraso tiene al que menos. */
  async overdue(now: Date = new Date()): Promise<OverdueListDto> {
    const rows = await this.prisma.billingPeriod.findMany({
      where: { status: 'vencido' },
      orderBy: { dueAt: 'asc' },
      take: 500,
    });
    const [balances, workers] = await Promise.all([
      this.balances(rows.map((p) => p.id)),
      this.workers(rows.map((p) => p.workerId)),
    ]);
    const items = rows.map((p) =>
      Object.assign(this.toRow(p, balances, workers), {
        daysLate: daysLate(p.dueAt, now, p.timezone),
        workerStatus: workers.get(p.workerId)?.status ?? 'sin_solicitar',
      }),
    );
    const total = rows.reduce((acc, p) => acc.add(balances.get(p.id) ?? ZERO), ZERO);
    return { items, totalBs: total.toFixed(2) };
  }

  /** Ledger completo con saldo acumulado (ventana sobre todos los movimientos anteriores). */
  async ledgerOf(workerId: string, cursor?: string): Promise<LedgerPageDto> {
    await this.requireWorker(workerId);
    const before = cursor ? BigInt(cursor) : null;
    const rows = await this.prisma.$queryRaw<
      {
        id: bigint;
        type: string;
        amountBs: Prisma.Decimal;
        runningBs: Prisma.Decimal;
        paymentReference: string;
        jobId: string | null;
        paymentId: string | null;
        correctsEntryId: bigint | null;
        reason: string | null;
        createdAt: Date;
      }[]
    >`
      SELECT * FROM (
        SELECT e.id, e.type::text AS type, e.amount_bs AS "amountBs",
               SUM(e.amount_bs) OVER (ORDER BY e.id) AS "runningBs",
               p.payment_reference AS "paymentReference", e.job_id AS "jobId",
               e.payment_id AS "paymentId", e.corrects_entry_id AS "correctsEntryId",
               e.reason, e.created_at AS "createdAt"
        FROM ledger_entries e JOIN billing_periods p ON p.id = e.period_id
        WHERE e.worker_id = ${workerId}::uuid
      ) l
      WHERE ${before}::bigint IS NULL OR l.id < ${before}::bigint
      ORDER BY l.id DESC
      LIMIT ${LEDGER_PAGE + 1}`;
    const page = rows.slice(0, LEDGER_PAGE);
    return {
      balanceBs: (await this.ledger.workerBalance(this.prisma, workerId)).toFixed(2),
      items: page.map((r) => ({
        id: r.id.toString(),
        type: r.type,
        amountBs: new Prisma.Decimal(r.amountBs).toFixed(2),
        runningBs: new Prisma.Decimal(r.runningBs).toFixed(2),
        paymentReference: r.paymentReference,
        jobId: r.jobId,
        paymentId: r.paymentId,
        correctsEntryId: r.correctsEntryId?.toString() ?? null,
        reason: r.reason,
        createdAt: r.createdAt.toISOString(),
      })),
      nextCursor: rows.length > LEDGER_PAGE ? (page.at(-1)?.id.toString() ?? null) : null,
    };
  }

  /**
   * Qué pasaría con un pago, sin guardarlo: misma regla de asignación que el registro
   * (más antiguos primero; lo que sobra, al periodo actual, ADR-0037).
   */
  async previewPayment(
    ctx: AdminContext,
    dto: PaymentPreviewDto,
    now: Date = new Date(),
  ): Promise<BalancePreviewDto> {
    assertNotSelf(ctx.adminId, [dto.workerId], SELF);
    const amount = new Prisma.Decimal(dto.amountBs);
    if (amount.lte(0)) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'AMOUNT_INVALID', 'El monto debe ser mayor a 0.');
    }
    const { open, current } = await this.openPeriods(dto.workerId, now);
    const older = open.filter((p) => p.startAt < current.window.startAt);
    const allocations = allocatePayment(
      amount,
      older.map((p) => ({ periodId: p.id, balance: p.balance })),
      current.id ?? 'actual',
    );
    const changes = new Map(allocations.map((a) => [a.periodId, a.amount.neg()]));
    return this.preview(dto.workerId, amount.neg(), open, current, changes, now);
  }

  /** Qué pasaría con un ajuste, sin guardarlo. */
  async previewAdjustment(
    ctx: AdminContext,
    dto: AdjustmentPreviewDto,
    now: Date = new Date(),
  ): Promise<BalancePreviewDto> {
    assertNotSelf(ctx.adminId, [dto.workerId], SELF);
    const amount = new Prisma.Decimal(dto.amountBs);
    if (amount.isZero()) {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'AMOUNT_INVALID', 'El ajuste no puede ser 0.');
    }
    const { open, current } = await this.openPeriods(dto.workerId, now, true);
    let target = current.id ?? 'actual';
    if (dto.correctsEntryId) {
      const entry = await this.prisma.ledgerEntry.findUnique({
        where: { id: BigInt(dto.correctsEntryId) },
        select: { workerId: true, periodId: true },
      });
      if (entry?.workerId !== dto.workerId) {
        throw new ApiError(HttpStatus.NOT_FOUND, 'ENTRY_NOT_FOUND', 'El movimiento no existe.');
      }
      target = entry.periodId;
    } else if (dto.periodId) {
      if (!open.some((p) => p.id === dto.periodId)) {
        throw new ApiError(HttpStatus.NOT_FOUND, 'PERIOD_NOT_FOUND', 'El periodo no existe.');
      }
      target = dto.periodId;
    }
    return this.preview(dto.workerId, amount, open, current, new Map([[target, amount]]), now);
  }

  private async preview(
    workerId: string,
    delta: Prisma.Decimal,
    periods: OpenPeriod[],
    current: CurrentPeriod,
    changes: Map<string, Prisma.Decimal>,
    now: Date,
  ): Promise<BalancePreviewDto> {
    const balance = await this.ledger.workerBalance(this.prisma, workerId);
    const profile = await this.prisma.workerProfile.findUnique({
      where: { userId: workerId },
      select: { status: true },
    });
    const statusAfter = new Map<string, string>();
    const allocations: PreviewAllocationDto[] = [];
    for (const [periodId, change] of changes) {
      const period = periods.find((p) => p.id === periodId);
      const window = period ?? { ...current.window, balance: ZERO };
      const after = window.balance.add(change);
      const status = periodStatus({
        endAt: window.endAt,
        dueAt: window.dueAt,
        balance: after,
        now,
      });
      statusAfter.set(periodId, status);
      allocations.push({
        periodId: periodId === 'actual' ? null : periodId,
        paymentReference: period?.paymentReference ?? null,
        amountBs: change.abs().toFixed(2),
        periodBalanceAfterBs: after.toFixed(2),
        statusAfter: status,
      });
    }
    const overdueAfter = periods.some((p) => (statusAfter.get(p.id) ?? p.status) === 'vencido');
    const blockedNow = profile?.status === 'bloqueado_deuda';
    return {
      balanceBeforeBs: balance.toFixed(2),
      balanceAfterBs: balance.add(delta).toFixed(2),
      allocations,
      blockedNow,
      unblocks: blockedNow && !overdueAfter,
    };
  }

  /** Periodos con saldo (o todos, para un ajuste) y la ventana del periodo actual. */
  private async openPeriods(
    workerId: string,
    now: Date,
    includePaid = false,
  ): Promise<{ open: OpenPeriod[]; current: CurrentPeriod }> {
    const user = await this.requireWorker(workerId);
    const window = periodWindow(now, this.ledger.calendar(user.city.timezone));
    const rows = await this.prisma.billingPeriod.findMany({
      where: { workerId, ...(includePaid ? {} : { status: { not: 'pagado' } }) },
      orderBy: { startAt: 'asc' },
    });
    const all = await this.prisma.billingPeriod.findFirst({
      where: { workerId, startAt: window.startAt },
      select: { id: true },
    });
    const balances = await this.balances(rows.map((r) => r.id));
    return {
      open: rows.map((r) => ({
        id: r.id,
        status: r.status,
        startAt: r.startAt,
        endAt: r.endAt,
        dueAt: r.dueAt,
        paymentReference: r.paymentReference,
        balance: balances.get(r.id) ?? ZERO,
      })),
      current: { id: all?.id ?? null, window },
    };
  }

  private async balances(periodIds: string[]): Promise<Map<string, Prisma.Decimal>> {
    if (periodIds.length === 0) return new Map();
    const rows = await this.prisma.ledgerEntry.groupBy({
      by: ['periodId'],
      where: { periodId: { in: periodIds } },
      _sum: { amountBs: true },
    });
    return new Map(rows.map((r) => [r.periodId, r._sum.amountBs ?? ZERO]));
  }

  private toRow(
    p: {
      id: string;
      workerId: string;
      status: string;
      paymentReference: string;
      startAt: Date;
      endAt: Date;
      dueAt: Date;
      grossBs: Prisma.Decimal;
      commissionBs: Prisma.Decimal;
    },
    balances: Map<string, Prisma.Decimal>,
    workers: Map<string, WorkerInfo>,
  ): PanelPeriodDto {
    const worker = workers.get(p.workerId);
    return {
      id: p.id,
      workerId: p.workerId,
      workerName: worker?.name ?? null,
      workerPhone: worker?.phone ?? '',
      status: p.status,
      paymentReference: p.paymentReference,
      startAt: p.startAt.toISOString(),
      endAt: p.endAt.toISOString(),
      dueAt: p.dueAt.toISOString(),
      grossBs: p.grossBs.toFixed(2),
      commissionBs: p.commissionBs.toFixed(2),
      balanceBs: (balances.get(p.id) ?? ZERO).toFixed(2),
    };
  }

  private async workers(ids: string[]): Promise<Map<string, WorkerInfo>> {
    const users = await this.prisma.user.findMany({
      where: { id: { in: [...new Set(ids)] } },
      select: { id: true, name: true, phone: true, workerProfile: { select: { status: true } } },
    });
    return new Map(
      users.map((u) => [
        u.id,
        { name: u.name, phone: u.phone, status: u.workerProfile?.status ?? 'sin_solicitar' },
      ]),
    );
  }

  private async requireWorker(workerId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: workerId },
      select: { city: { select: { timezone: true } }, workerProfile: { select: { status: true } } },
    });
    if (!user?.workerProfile) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'WORKER_NOT_FOUND', 'El trabajador no existe.');
    }
    return user;
  }
}

interface OpenPeriod {
  id: string;
  status: string;
  startAt: Date;
  endAt: Date;
  dueAt: Date;
  paymentReference: string;
  balance: Prisma.Decimal;
}

interface CurrentPeriod {
  id: string | null;
  window: { startAt: Date; endAt: Date; dueAt: Date };
}

interface WorkerInfo {
  name: string | null;
  phone: string;
  status: string;
}
