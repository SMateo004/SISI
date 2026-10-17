-- Cancelación de trabajos (Fase 4): motivo, nota moderada, quién canceló y conteo por usuario.
-- CreateEnum
CREATE TYPE "job_cancel_reason" AS ENUM ('cambio_de_planes', 'no_llega_o_no_responde', 'desacuerdo_de_precio', 'emergencia', 'otro');

-- AlterTable
ALTER TABLE "jobs" ADD COLUMN     "cancel_note" TEXT,
ADD COLUMN     "cancel_note_held" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "cancel_reason" "job_cancel_reason",
ADD COLUMN     "cancelled_by_id" UUID,
ADD COLUMN     "cancelled_by_role" TEXT;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "cancellations_count" INTEGER NOT NULL DEFAULT 0;


ALTER TABLE "jobs" ADD CONSTRAINT "jobs_cancelled_by_role_check"
  CHECK ("cancelled_by_role" IS NULL OR "cancelled_by_role" IN ('worker', 'employer', 'admin'));
