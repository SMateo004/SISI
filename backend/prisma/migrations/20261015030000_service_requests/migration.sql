-- Fase 2: solicitudes de servicio (R3, ADR-0019). geog con índice GiST para consultas por distancia.
-- CreateEnum
CREATE TYPE "service_request_status" AS ENUM ('borrador', 'retenida', 'buscando', 'con_ofertas', 'asignada', 'cancelada', 'expirada');

-- CreateTable
CREATE TABLE "service_requests" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "employer_id" UUID NOT NULL,
    "category_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "description" TEXT NOT NULL,
    "geog" geography(Point,4326) NOT NULL,
    "address" TEXT NOT NULL,
    "proposed_price_bs" DECIMAL(10,2) NOT NULL,
    "status" "service_request_status" NOT NULL DEFAULT 'borrador',
    "ring" SMALLINT,
    "moderation_matches" JSONB,
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "cancel_reason" TEXT,
    "cancel_note" TEXT,
    "published_at" TIMESTAMPTZ(3),
    "cancelled_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "service_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_request_photos" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "file_key" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "size_bytes" INTEGER NOT NULL,
    "position" SMALLINT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_request_photos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_request_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "request_id" UUID NOT NULL,
    "event" TEXT NOT NULL,
    "from_status" "service_request_status",
    "to_status" "service_request_status" NOT NULL,
    "reason" TEXT,
    "actor_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "service_request_events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "service_requests_employer_id_created_at_idx" ON "service_requests"("employer_id", "created_at");

-- CreateIndex
CREATE INDEX "service_requests_status_city_id_idx" ON "service_requests"("status", "city_id");

-- CreateIndex
CREATE INDEX "service_requests_geog_idx" ON "service_requests" USING GIST ("geog");

-- CreateIndex
CREATE INDEX "service_request_photos_request_id_idx" ON "service_request_photos"("request_id");

-- CreateIndex
CREATE INDEX "service_request_events_request_id_created_at_idx" ON "service_request_events"("request_id", "created_at");

-- AddForeignKey
ALTER TABLE "service_requests" ADD CONSTRAINT "service_requests_employer_id_fkey" FOREIGN KEY ("employer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_requests" ADD CONSTRAINT "service_requests_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_requests" ADD CONSTRAINT "service_requests_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_request_photos" ADD CONSTRAINT "service_request_photos_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_request_events" ADD CONSTRAINT "service_request_events_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "service_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;


-- Reglas de integridad (R3.1): precio propuesto positivo, a lo sumo 4 fotos por posición.
ALTER TABLE "service_requests" ADD CONSTRAINT "service_requests_price_check" CHECK ("proposed_price_bs" > 0);
ALTER TABLE "service_request_photos" ADD CONSTRAINT "service_request_photos_position_check" CHECK ("position" BETWEEN 0 AND 3);
CREATE UNIQUE INDEX "service_request_photos_request_id_position_key" ON "service_request_photos"("request_id", "position");
