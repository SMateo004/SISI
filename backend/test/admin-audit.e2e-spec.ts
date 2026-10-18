import { randomUUID } from 'node:crypto';
import request from 'supertest';
import { AdminAuditService } from '../src/audit/admin-audit.service';
import type { AdminContext } from '../src/audit/admin-context';
import type { AuditPageDto } from '../src/audit/dto/audit.dto';
import { Prisma } from '../src/generated/prisma/client';
import { bearer, createTestApp, loginAsAdmin, type TestApp } from './utils/test-app';

describe('Auditoría del panel (e2e, ADR-0041)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  const ctxOf = (adminId: string): AdminContext => ({
    adminId,
    ip: '10.0.0.1',
    forwardedFor: '190.0.0.1, 10.0.0.1',
    userAgent: 'jest',
  });

  it('se escribe en la transacción del cambio: si el cambio se revierte, la fila también', async () => {
    const admin = await loginAsAdmin(t);
    const audit = t.app.get(AdminAuditService);
    const targetId = randomUUID();
    await expect(
      t.prisma.$transaction(async (tx) => {
        await audit.record(tx, ctxOf(admin.user.id), {
          action: 'test.rollback',
          targetType: 'test',
          targetId,
        });
        throw new Error('el cambio falló');
      }),
    ).rejects.toThrow('el cambio falló');
    expect(await t.prisma.adminAuditLog.count({ where: { targetId } })).toBe(0);
  });

  it('es append-only: UPDATE y DELETE fallan', async () => {
    const admin = await loginAsAdmin(t);
    const targetId = randomUUID();
    await t.prisma.$transaction((tx) =>
      t.app.get(AdminAuditService).record(tx, ctxOf(admin.user.id), {
        action: 'test.append_only',
        targetType: 'test',
        targetId,
        before: { amountBs: new Prisma.Decimal('19.5') },
        after: { amountBs: new Prisma.Decimal('0') },
        reason: 'prueba',
      }),
    );
    const row = await t.prisma.adminAuditLog.findFirstOrThrow({ where: { targetId } });
    // Los montos quedan como texto con 2 decimales.
    expect(row.before).toEqual({ amountBs: '19.50' });
    expect(row.after).toEqual({ amountBs: '0.00' });
    await expect(
      t.prisma.adminAuditLog.update({ where: { id: row.id }, data: { reason: 'otro' } }),
    ).rejects.toThrow(/append-only/);
    await expect(t.prisma.adminAuditLog.delete({ where: { id: row.id } })).rejects.toThrow(
      /append-only/,
    );
  });

  it('GET /admin/audit filtra por admin, acción (prefijo), objetivo y fechas, y pagina', async () => {
    const admin = await loginAsAdmin(t);
    const other = await loginAsAdmin(t);
    const audit = t.app.get(AdminAuditService);
    const targetId = randomUUID();
    await t.prisma.$transaction(async (tx) => {
      for (let i = 0; i < 55; i++) {
        await audit.record(tx, ctxOf(admin.user.id), {
          action: i % 2 === 0 ? 'billing.payment' : 'billing.adjustment',
          targetType: 'worker',
          targetId,
        });
      }
      await audit.record(tx, ctxOf(other.user.id), {
        action: 'verification.approve',
        targetType: 'worker',
        targetId,
      });
    });

    const get = (query: Record<string, string>) =>
      request(t.app.getHttpServer())
        .get('/admin/audit')
        .query(query)
        .set(...bearer(admin.accessToken))
        .expect(200)
        .then((r) => r.body as AuditPageDto);

    const first = await get({ adminId: admin.user.id, targetId });
    expect(first.items).toHaveLength(50);
    expect(first.nextCursor).not.toBeNull();
    const second = await get({ adminId: admin.user.id, targetId, cursor: first.nextCursor ?? '' });
    expect(second.items).toHaveLength(5);
    expect(second.nextCursor).toBeNull();
    // Más nuevas primero, sin repetir entre páginas.
    const ids = [...first.items, ...second.items].map((i) => BigInt(i.id));
    expect(new Set(ids).size).toBe(55);
    expect([...ids].sort((a, b) => (a > b ? -1 : 1))).toEqual(ids);

    const payments = await get({ targetId, action: 'billing.payment' });
    expect(payments.items).toHaveLength(28);
    const billing = await get({ targetId, action: 'billing.' });
    expect(billing.items.every((i) => i.action.startsWith('billing.'))).toBe(true);
    const byOther = await get({ targetId, adminId: other.user.id });
    expect(byOther.items).toEqual([
      expect.objectContaining({
        action: 'verification.approve',
        adminPhone: other.user.phone,
        ip: '10.0.0.1',
        forwardedFor: '190.0.0.1, 10.0.0.1',
      }),
    ]);
    const future = await get({ targetId, from: new Date(Date.now() + 60_000).toISOString() });
    expect(future.items).toEqual([]);
  });
});
