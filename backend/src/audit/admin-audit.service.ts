import { Injectable } from '@nestjs/common';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type { AdminContext } from './admin-context';
import type { AuditEntryDto, AuditQueryDto } from './dto/audit.dto';

export interface AuditEntry {
  /** área.verbo, p. ej. verification.approve. */
  action: string;
  targetType: string;
  targetId: string;
  before?: unknown;
  after?: unknown;
  reason?: string | null;
  cityId?: string | null;
}

/** Lo que un servicio de dominio recibe para auditar dentro de su transacción. */
export interface AuditHook {
  ctx: AdminContext;
  record: (tx: Prisma.TransactionClient, entry: AuditEntry) => Promise<void>;
}

/** Decimal, Date y BigInt a JSON estable (montos como texto con 2 decimales, ADR-0034). */
export function toAuditJson(value: unknown): Prisma.InputJsonValue | typeof Prisma.DbNull {
  if (value === undefined || value === null) return Prisma.DbNull;
  return normalize(value) as Prisma.InputJsonValue;
}

function normalize(value: unknown): unknown {
  if (value === null || value === undefined) return null;
  if (Prisma.Decimal.isDecimal(value)) return value.toFixed(2);
  if (typeof value === 'bigint') return value.toString();
  if (value instanceof Date) return value.toISOString();
  if (Array.isArray(value)) return value.map(normalize);
  if (typeof value === 'object') {
    return Object.fromEntries(
      Object.entries(value)
        .filter(([, v]) => v !== undefined)
        .map(([k, v]) => [k, normalize(v)]),
    );
  }
  return value;
}

const PAGE = 50;

/**
 * Auditoría del panel (ADR-0041). `record` se llama SIEMPRE con el cliente de la transacción
 * del cambio: si el cambio se revierte, la fila también, y nunca queda un cambio sin fila.
 */
@Injectable()
export class AdminAuditService {
  constructor(private readonly prisma: PrismaService) {}

  async record(tx: Prisma.TransactionClient, ctx: AdminContext, entry: AuditEntry): Promise<void> {
    await tx.adminAuditLog.create({
      data: {
        adminId: ctx.adminId,
        action: entry.action,
        targetType: entry.targetType,
        targetId: entry.targetId,
        before: toAuditJson(entry.before),
        after: toAuditJson(entry.after),
        reason: entry.reason ?? null,
        ip: ctx.ip,
        forwardedFor: ctx.forwardedFor,
        userAgent: ctx.userAgent,
        cityId: entry.cityId ?? null,
      },
    });
  }

  /** Atajo para los servicios: `audit.hook(ctx)` se pasa como parámetro opcional. */
  hook(ctx: AdminContext): AuditHook {
    return { ctx, record: (tx, entry) => this.record(tx, ctx, entry) };
  }

  /** Consulta con filtros, de la más nueva a la más vieja, paginada por id. */
  async list(query: AuditQueryDto): Promise<{ items: AuditEntryDto[]; nextCursor: string | null }> {
    const where: Prisma.AdminAuditLogWhereInput = {
      ...(query.adminId ? { adminId: query.adminId } : {}),
      ...(query.action ? { action: { startsWith: query.action } } : {}),
      ...(query.targetType ? { targetType: query.targetType } : {}),
      ...(query.targetId ? { targetId: query.targetId } : {}),
      ...(query.from || query.to
        ? {
            createdAt: {
              ...(query.from ? { gte: new Date(query.from) } : {}),
              ...(query.to ? { lt: new Date(query.to) } : {}),
            },
          }
        : {}),
      ...(query.cursor ? { id: { lt: BigInt(query.cursor) } } : {}),
    };
    const rows = await this.prisma.adminAuditLog.findMany({
      where,
      orderBy: { id: 'desc' },
      take: PAGE + 1,
      include: { admin: { select: { name: true, phone: true } } },
    });
    const page = rows.slice(0, PAGE);
    return {
      items: page.map((r) => ({
        id: r.id.toString(),
        adminId: r.adminId,
        adminName: r.admin.name,
        adminPhone: r.admin.phone,
        action: r.action,
        targetType: r.targetType,
        targetId: r.targetId,
        before: r.before ?? null,
        after: r.after ?? null,
        reason: r.reason,
        ip: r.ip,
        forwardedFor: r.forwardedFor,
        userAgent: r.userAgent,
        cityId: r.cityId,
        createdAt: r.createdAt.toISOString(),
      })),
      nextCursor: rows.length > PAGE ? (page.at(-1)?.id.toString() ?? null) : null,
    };
  }
}
