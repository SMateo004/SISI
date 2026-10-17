-- Comprobantes enviados por el trabajador y QR de cobro de la empresa (R7.4, ADR-0037).
-- CreateEnum
CREATE TYPE "payment_submission_status" AS ENUM ('pendiente', 'registrado', 'rechazado');

-- AlterTable
ALTER TABLE "payments" ADD COLUMN     "submission_id" UUID;

-- CreateTable
CREATE TABLE "payment_submissions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "receipt_key" TEXT NOT NULL,
    "declared_amount_bs" DECIMAL(12,2),
    "note" TEXT,
    "status" "payment_submission_status" NOT NULL DEFAULT 'pendiente',
    "payment_id" UUID,
    "review_note" TEXT,
    "reviewed_by_id" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_submissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "app_settings" (
    "key" TEXT NOT NULL,
    "scope" TEXT NOT NULL DEFAULT 'global',
    "value" JSONB NOT NULL,
    "updated_by_id" UUID,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "app_settings_pkey" PRIMARY KEY ("key","scope")
);

-- CreateIndex
CREATE INDEX "payment_submissions_worker_id_created_at_idx" ON "payment_submissions"("worker_id", "created_at");

-- CreateIndex
CREATE INDEX "payment_submissions_status_created_at_idx" ON "payment_submissions"("status", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "payments_submission_id_key" ON "payments"("submission_id");

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_submission_id_fkey" FOREIGN KEY ("submission_id") REFERENCES "payment_submissions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "payment_submissions" ADD CONSTRAINT "payment_submissions_amount_check" CHECK ("declared_amount_bs" IS NULL OR "declared_amount_bs" > 0);
