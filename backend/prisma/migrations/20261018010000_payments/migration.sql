-- Pagos e idempotencia de las operaciones de dinero (R7.4, ADR-0037).
-- CreateEnum
CREATE TYPE "payment_method" AS ENUM ('qr_transferencia', 'efectivo', 'otro');

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "period_id" UUID NOT NULL,
    "amount_bs" DECIMAL(12,2) NOT NULL,
    "method" "payment_method" NOT NULL,
    "reference" TEXT,
    "receipt_key" TEXT,
    "invoice_number" TEXT,
    "registered_by_id" UUID NOT NULL,
    "paid_at" TIMESTAMPTZ(3) NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "idempotency_keys" (
    "scope" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "actor_id" UUID NOT NULL,
    "request_hash" TEXT NOT NULL,
    "response" JSONB,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "idempotency_keys_pkey" PRIMARY KEY ("scope","key")
);

-- CreateIndex
CREATE INDEX "payments_worker_id_paid_at_idx" ON "payments"("worker_id", "paid_at");


ALTER TABLE "payments" ADD CONSTRAINT "payments_amount_check" CHECK ("amount_bs" > 0);
ALTER TABLE "payments" ADD CONSTRAINT "payments_period_id_fkey" FOREIGN KEY ("period_id") REFERENCES "billing_periods"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ledger_entries" ADD CONSTRAINT "ledger_entries_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "payments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
