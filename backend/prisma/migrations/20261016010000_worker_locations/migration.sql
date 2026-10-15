-- Ubicación y disponibilidad del trabajador (ADR-0024).
-- CreateTable
CREATE TABLE "worker_locations" (
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "geog" geography(Point,4326),
    "available" BOOLEAN NOT NULL DEFAULT false,
    "available_since" TIMESTAMPTZ(3),
    "located_at" TIMESTAMPTZ(3),
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "worker_locations_pkey" PRIMARY KEY ("worker_id")
);

-- CreateIndex
CREATE INDEX "worker_locations_geog_idx" ON "worker_locations" USING GIST ("geog");

-- CreateIndex
CREATE INDEX "worker_locations_city_id_available_idx" ON "worker_locations"("city_id", "available");

-- AddForeignKey
ALTER TABLE "worker_locations" ADD CONSTRAINT "worker_locations_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "worker_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_locations" ADD CONSTRAINT "worker_locations_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- Disponible exige una ubicación conocida.
ALTER TABLE "worker_locations" ADD CONSTRAINT "worker_locations_available_needs_location"
  CHECK (NOT "available" OR ("geog" IS NOT NULL AND "located_at" IS NOT NULL));
