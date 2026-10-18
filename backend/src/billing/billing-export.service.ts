import { HttpStatus, Injectable } from '@nestjs/common';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { ApiError } from '../common/errors/api-error';
import { PrismaService } from '../prisma/prisma.service';
import { amountCell, CSV_BOM, csvLine, localCell, textCell } from './csv';

const BATCH = 1000;
const MAX_RANGE_DAYS = 400;

export interface ExportRange {
  from: Date;
  to: Date;
}

export function exportRange(fromIso: string, toIso: string): ExportRange {
  const from = new Date(fromIso);
  const to = new Date(toIso);
  if (!(from < to)) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'RANGE_INVALID',
      '"Desde" debe ser antes de "hasta".',
    );
  }
  if (to.getTime() - from.getTime() > MAX_RANGE_DAYS * 86_400_000) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'RANGE_TOO_LONG',
      `El rango admite hasta ${String(MAX_RANGE_DAYS)} días.`,
    );
  }
  return { from, to };
}

/**
 * Exportaciones CSV para el contador (Fase 6): ledger y pagos por rango de fechas [desde,
 * hasta). Por lotes con cursor por id (sin cargar todo en memoria). Fechas en la hora local
 * de la ciudad; montos con punto decimal. Cada exportación queda auditada.
 */
@Injectable()
export class BillingExportService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AdminAuditService,
  ) {}

  async *ledger(ctx: AdminContext, range: ExportRange): AsyncGenerator<string> {
    await this.auditExport(ctx, 'billing.export_ledger', range);
    yield CSV_BOM +
      csvLine([
        'movimiento',
        'fecha_local',
        'ciudad',
        'trabajador',
        'telefono',
        'tipo',
        'monto_bs',
        'referencia_periodo',
        'trabajo',
        'pago',
        'corrige',
        'motivo',
      ]);
    let cursor: bigint | null = null;
    for (;;) {
      const rows = await this.ledgerBatch(range, cursor);
      if (rows.length === 0) return;
      const people = await this.people(
        rows.map((r) => r.workerId),
        rows.map((r) => r.cityId),
      );
      let chunk = '';
      for (const r of rows) {
        const worker = people.users.get(r.workerId);
        chunk += csvLine([
          r.id.toString(),
          localCell(r.createdAt, r.period.timezone),
          textCell(people.cities.get(r.cityId)),
          textCell(worker?.name),
          textCell(worker?.phone),
          r.type,
          amountCell(r.amountBs),
          textCell(r.period.paymentReference),
          r.jobId ?? '',
          r.paymentId ?? '',
          r.correctsEntryId?.toString() ?? '',
          textCell(r.reason),
        ]);
      }
      yield chunk;
      cursor = rows.at(-1)?.id ?? null;
      if (rows.length < BATCH) return;
    }
  }

  async *payments(ctx: AdminContext, range: ExportRange): AsyncGenerator<string> {
    await this.auditExport(ctx, 'billing.export_payments', range);
    yield CSV_BOM +
      csvLine([
        'pago',
        'fecha_pago_local',
        'registrado_local',
        'ciudad',
        'trabajador',
        'telefono',
        'monto_bs',
        'metodo',
        'referencia',
        'factura',
        'periodos',
      ]);
    let cursor: { paidAt: Date; id: string } | null = null;
    for (;;) {
      const rows = await this.paymentBatch(range, cursor);
      if (rows.length === 0) return;
      const people = await this.people(
        rows.map((r) => r.workerId),
        rows.map((r) => r.cityId),
      );
      let chunk = '';
      for (const p of rows) {
        const worker = people.users.get(p.workerId);
        const tz = p.period.timezone;
        chunk += csvLine([
          p.id,
          localCell(p.paidAt, tz),
          localCell(p.createdAt, tz),
          textCell(people.cities.get(p.cityId)),
          textCell(worker?.name),
          textCell(worker?.phone),
          amountCell(p.amountBs),
          p.method,
          textCell(p.reference),
          textCell(p.invoiceNumber),
          textCell([...new Set(p.entries.map((e) => e.period.paymentReference))].join(' ')),
        ]);
      }
      yield chunk;
      const last = rows.at(-1);
      cursor = last ? { paidAt: last.paidAt, id: last.id } : null;
      if (rows.length < BATCH) return;
    }
  }

  private ledgerBatch(range: ExportRange, cursor: bigint | null) {
    return this.prisma.ledgerEntry.findMany({
      where: {
        createdAt: { gte: range.from, lt: range.to },
        ...(cursor === null ? {} : { id: { gt: cursor } }),
      },
      orderBy: { id: 'asc' },
      take: BATCH,
      include: { period: { select: { paymentReference: true, timezone: true } } },
    });
  }

  private paymentBatch(range: ExportRange, cursor: { paidAt: Date; id: string } | null) {
    return this.prisma.payment.findMany({
      where: {
        paidAt: { gte: range.from, lt: range.to },
        ...(cursor
          ? {
              OR: [
                { paidAt: { gt: cursor.paidAt } },
                { paidAt: cursor.paidAt, id: { gt: cursor.id } },
              ],
            }
          : {}),
      },
      orderBy: [{ paidAt: 'asc' }, { id: 'asc' }],
      take: BATCH,
      include: {
        period: { select: { timezone: true } },
        entries: { select: { period: { select: { paymentReference: true } } } },
      },
    });
  }

  private async people(userIds: string[], cityIds: string[]) {
    const [users, cities] = await Promise.all([
      this.prisma.user.findMany({
        where: { id: { in: [...new Set(userIds)] } },
        select: { id: true, name: true, phone: true },
      }),
      this.prisma.city.findMany({
        where: { id: { in: [...new Set(cityIds)] } },
        select: { id: true, name: true },
      }),
    ]);
    return {
      users: new Map(users.map((u) => [u.id, u])),
      cities: new Map(cities.map((c) => [c.id, c.name])),
    };
  }

  private async auditExport(ctx: AdminContext, action: string, range: ExportRange): Promise<void> {
    await this.prisma.$transaction((tx) =>
      this.audit.record(tx, ctx, {
        action,
        targetType: 'export',
        targetId: `${range.from.toISOString()}/${range.to.toISOString()}`,
        after: { from: range.from, to: range.to },
      }),
    );
  }
}
