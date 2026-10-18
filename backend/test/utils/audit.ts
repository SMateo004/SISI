import type { TestApp } from './test-app';

/** Filas de auditoría de un objetivo (las más nuevas primero). */
export function auditRows(t: TestApp, targetType: string, targetId: string) {
  return t.prisma.adminAuditLog.findMany({
    where: { targetType, targetId },
    orderBy: { id: 'desc' },
  });
}

/** La última fila de auditoría de ese objetivo, con la acción esperada. */
export async function expectAudited(
  t: TestApp,
  {
    action,
    targetType,
    targetId,
    adminId,
  }: {
    action: string;
    targetType: string;
    targetId: string;
    adminId: string;
  },
) {
  const [row] = await auditRows(t, targetType, targetId);
  expect(row).toMatchObject({ action, targetType, targetId, adminId });
  return row;
}
