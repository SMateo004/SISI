-- Matching por anillos y ofertas (ADR-0025, ADR-0026).
-- CreateEnum
CREATE TYPE "offer_type" AS ENUM ('accept', 'counter');

-- CreateEnum
CREATE TYPE "offer_status" AS ENUM ('activa', 'aceptada', 'cerrada');

-- AlterTable
ALTER TABLE "service_requests" ADD COLUMN     "expires_at" TIMESTAMPTZ(3),
ADD COLUMN     "ring_started_at" TIMESTAMPTZ(3);

-- CreateTable
CREATE TABLE "request_notifications" (
    "request_id" UUID NOT NULL,
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "ring" SMALLINT NOT NULL,
    "distance_m" INTEGER NOT NULL,
    "notified_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "request_notifications_pkey" PRIMARY KEY ("request_id","worker_id")
);

-- CreateTable
CREATE TABLE "offers" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "type" "offer_type" NOT NULL,
    "amount_bs" DECIMAL(10,2) NOT NULL,
    "eta_min" INTEGER NOT NULL,
    "distance_m" INTEGER NOT NULL,
    "status" "offer_status" NOT NULL DEFAULT 'activa',
    "revision" INTEGER NOT NULL DEFAULT 1,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "offers_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "request_notifications_worker_id_notified_at_idx" ON "request_notifications"("worker_id", "notified_at");

-- CreateIndex
CREATE INDEX "offers_request_id_status_idx" ON "offers"("request_id", "status");

-- CreateIndex
CREATE UNIQUE INDEX "offers_request_id_worker_id_key" ON "offers"("request_id", "worker_id");

-- AddForeignKey
ALTER TABLE "request_notifications" ADD CONSTRAINT "request_notifications_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "request_notifications" ADD CONSTRAINT "request_notifications_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "worker_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "offers" ADD CONSTRAINT "offers_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "offers" ADD CONSTRAINT "offers_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "worker_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;


-- Montos positivos y tiempos razonables.
ALTER TABLE "offers" ADD CONSTRAINT "offers_amount_positive" CHECK ("amount_bs" > 0);
ALTER TABLE "offers" ADD CONSTRAINT "offers_eta_non_negative" CHECK ("eta_min" >= 0);
ALTER TABLE "request_notifications" ADD CONSTRAINT "request_notifications_ring_positive" CHECK ("ring" >= 1);
