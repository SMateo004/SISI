-- Trabajos asignados (R5.4, ADR-0026). El ciclo de vida completo llega en la Fase 4.
-- CreateEnum
CREATE TYPE "job_status" AS ENUM ('asignado', 'en_camino', 'en_curso', 'terminado', 'cancelado');

-- CreateTable
CREATE TABLE "jobs" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "worker_id" UUID NOT NULL,
    "employer_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "offer_id" UUID NOT NULL,
    "final_price_bs" DECIMAL(10,2) NOT NULL,
    "commission_pct" DECIMAL(5,2) NOT NULL,
    "commission_bs" DECIMAL(10,2),
    "status" "job_status" NOT NULL DEFAULT 'asignado',
    "assigned_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "jobs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "jobs_request_id_key" ON "jobs"("request_id");

-- CreateIndex
CREATE UNIQUE INDEX "jobs_offer_id_key" ON "jobs"("offer_id");

-- CreateIndex
CREATE INDEX "jobs_worker_id_created_at_idx" ON "jobs"("worker_id", "created_at");

-- CreateIndex
CREATE INDEX "jobs_employer_id_created_at_idx" ON "jobs"("employer_id", "created_at");

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "jobs_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "service_requests"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "jobs_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "jobs" ADD CONSTRAINT "jobs_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "jobs" ADD CONSTRAINT "jobs_final_price_positive" CHECK ("final_price_bs" > 0);
ALTER TABLE "jobs" ADD CONSTRAINT "jobs_commission_pct_range" CHECK ("commission_pct" >= 0 AND "commission_pct" <= 100);
