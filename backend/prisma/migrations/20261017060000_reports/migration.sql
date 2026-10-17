-- Reportes y marca de moderación (R9.3, ADR-0033).
-- CreateEnum
CREATE TYPE "report_target_type" AS ENUM ('request', 'user', 'chat_message', 'job');

-- CreateEnum
CREATE TYPE "report_reason" AS ENUM ('servicios_sexuales', 'drogas', 'armas', 'ilegal', 'inmoral', 'venta_productos', 'acoso', 'fraude', 'no_se_presento', 'suplantacion', 'otro');

-- CreateEnum
CREATE TYPE "report_status" AS ENUM ('pendiente', 'valido', 'descartado');

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "moderation_flagged_at" TIMESTAMPTZ(3);

-- CreateTable
CREATE TABLE "reports" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "reporter_id" UUID NOT NULL,
    "target_type" "report_target_type" NOT NULL,
    "target_id" UUID NOT NULL,
    "reported_user_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "reason" "report_reason" NOT NULL,
    "note" TEXT,
    "note_held" BOOLEAN NOT NULL DEFAULT false,
    "status" "report_status" NOT NULL DEFAULT 'pendiente',
    "resolution" TEXT,
    "resolved_by_id" UUID,
    "resolved_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reports_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "reports_status_created_at_idx" ON "reports"("status", "created_at");

-- CreateIndex
CREATE INDEX "reports_reported_user_id_status_idx" ON "reports"("reported_user_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "reports_reporter_id_target_type_target_id_key" ON "reports"("reporter_id", "target_type", "target_id");


ALTER TABLE "reports" ADD CONSTRAINT "reports_not_self_check" CHECK ("reporter_id" <> "reported_user_id");
