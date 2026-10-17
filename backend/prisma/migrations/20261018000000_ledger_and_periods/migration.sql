-- Ledger inmutable y periodos de cobro (R7, ADR-0034, ADR-0035).
-- CreateEnum
CREATE TYPE "ledger_entry_type" AS ENUM ('comision', 'pago', 'ajuste');

-- CreateEnum
CREATE TYPE "billing_period_status" AS ENUM ('abierto', 'cerrado_pendiente', 'pagado', 'vencido');

-- AlterTable
ALTER TABLE "worker_profiles" ADD COLUMN     "billing_code" VARCHAR(8),
ADD COLUMN     "debt_cap_reached_at" TIMESTAMPTZ(3);

-- CreateTable
CREATE TABLE "billing_periods" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "timezone" TEXT NOT NULL,
    "start_at" TIMESTAMPTZ(3) NOT NULL,
    "end_at" TIMESTAMPTZ(3) NOT NULL,
    "due_at" TIMESTAMPTZ(3) NOT NULL,
    "status" "billing_period_status" NOT NULL DEFAULT 'abierto',
    "gross_bs" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "commission_bs" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "payment_reference" TEXT NOT NULL,
    "closed_at" TIMESTAMPTZ(3),
    "paid_at" TIMESTAMPTZ(3),
    "overdue_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "billing_periods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ledger_entries" (
    "id" BIGSERIAL NOT NULL,
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "period_id" UUID NOT NULL,
    "type" "ledger_entry_type" NOT NULL,
    "amount_bs" DECIMAL(12,2) NOT NULL,
    "job_id" UUID,
    "payment_id" UUID,
    "corrects_entry_id" BIGINT,
    "reason" TEXT,
    "created_by_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ledger_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "billing_notices" (
    "period_id" UUID NOT NULL,
    "kind" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "billing_notices_pkey" PRIMARY KEY ("period_id","kind")
);

-- CreateIndex
CREATE UNIQUE INDEX "billing_periods_payment_reference_key" ON "billing_periods"("payment_reference");

-- CreateIndex
CREATE INDEX "billing_periods_status_end_at_idx" ON "billing_periods"("status", "end_at");

-- CreateIndex
CREATE INDEX "billing_periods_status_due_at_idx" ON "billing_periods"("status", "due_at");

-- CreateIndex
CREATE UNIQUE INDEX "billing_periods_worker_id_start_at_key" ON "billing_periods"("worker_id", "start_at");

-- CreateIndex
CREATE INDEX "ledger_entries_worker_id_id_idx" ON "ledger_entries"("worker_id", "id");

-- CreateIndex
CREATE INDEX "ledger_entries_period_id_idx" ON "ledger_entries"("period_id");

-- CreateIndex
CREATE UNIQUE INDEX "worker_profiles_billing_code_key" ON "worker_profiles"("billing_code");

-- AddForeignKey
ALTER TABLE "ledger_entries" ADD CONSTRAINT "ledger_entries_period_id_fkey" FOREIGN KEY ("period_id") REFERENCES "billing_periods"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_notices" ADD CONSTRAINT "billing_notices_period_id_fkey" FOREIGN KEY ("period_id") REFERENCES "billing_periods"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- Convención de signo (ADR-0034): comisión > 0, pago < 0, ajuste distinto de 0 y con motivo.
ALTER TABLE "ledger_entries" ADD CONSTRAINT "ledger_entries_sign_check" CHECK (
  ("type" = 'comision' AND "amount_bs" > 0 AND "job_id" IS NOT NULL) OR
  ("type" = 'pago' AND "amount_bs" < 0 AND "payment_id" IS NOT NULL) OR
  ("type" = 'ajuste' AND "amount_bs" <> 0 AND "reason" IS NOT NULL AND "created_by_id" IS NOT NULL)
);

-- Una sola comisión por trabajo: job.completed es idempotente.
CREATE UNIQUE INDEX "ledger_entries_one_commission_per_job" ON "ledger_entries"("job_id")
  WHERE "type" = 'comision';

-- El ledger es append-only: se rechaza cualquier UPDATE o DELETE (R7.9).
CREATE FUNCTION ledger_entries_append_only() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'ledger_entries es append-only: % no permitido', TG_OP
    USING ERRCODE = 'insufficient_privilege';
END;
$$;

CREATE TRIGGER ledger_entries_no_update_delete
  BEFORE UPDATE OR DELETE ON "ledger_entries"
  FOR EACH ROW EXECUTE FUNCTION ledger_entries_append_only();

ALTER TABLE "billing_periods" ADD CONSTRAINT "billing_periods_interval_check"
  CHECK ("start_at" < "end_at" AND "end_at" <= "due_at");
ALTER TABLE "billing_notices" ADD CONSTRAINT "billing_notices_kind_check"
  CHECK ("kind" IN ('cierre', 'vispera', 'dia', 'vencido'));
