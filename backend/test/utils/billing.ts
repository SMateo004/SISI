import type { TestApp } from './test-app';

interface Mismatch {
  periodId: string;
  field: string;
  stored: string;
  fromLedger: string;
}

/**
 * Consistencia de cobros (ADR-0034): los totales derivados de cada periodo coinciden con el
 * ledger. commission_bs = Σ comisiones del periodo; gross_bs = Σ precio final de esos
 * trabajos. Devuelve las diferencias (vacío = consistente).
 */
export async function ledgerMismatches(t: TestApp, workerIds?: string[]): Promise<Mismatch[]> {
  const filter = workerIds && workerIds.length > 0;
  const rows = await t.prisma.$queryRaw<
    {
      periodId: string;
      storedGross: string;
      storedCommission: string;
      gross: string;
      commission: string;
    }[]
  >`
    SELECT p.id AS "periodId",
           p.gross_bs::text AS "storedGross",
           p.commission_bs::text AS "storedCommission",
           COALESCE((SELECT SUM(j.final_price_bs) FROM ledger_entries e
                     JOIN jobs j ON j.id = e.job_id
                     WHERE e.period_id = p.id AND e.type = 'comision'), 0)::numeric(12,2)::text AS gross,
           COALESCE((SELECT SUM(e.amount_bs) FROM ledger_entries e
                     WHERE e.period_id = p.id AND e.type = 'comision'), 0)::numeric(12,2)::text AS commission
    FROM billing_periods p
    WHERE ${!filter} OR p.worker_id = ANY(${workerIds ?? []}::uuid[])`;
  const out: Mismatch[] = [];
  for (const r of rows) {
    if (r.storedGross !== r.gross) {
      out.push({
        periodId: r.periodId,
        field: 'gross_bs',
        stored: r.storedGross,
        fromLedger: r.gross,
      });
    }
    if (r.storedCommission !== r.commission) {
      out.push({
        periodId: r.periodId,
        field: 'commission_bs',
        stored: r.storedCommission,
        fromLedger: r.commission,
      });
    }
  }
  return out;
}

/** Saldo del trabajador = Σ ledger (positivo = debe), como texto con 2 decimales. */
export async function ledgerBalance(t: TestApp, workerId: string): Promise<string> {
  const [row] = await t.prisma.$queryRaw<{ balance: string }[]>`
    SELECT COALESCE(SUM(amount_bs), 0)::numeric(12,2)::text AS balance
    FROM ledger_entries WHERE worker_id = ${workerId}::uuid`;
  return row?.balance ?? '0.00';
}
