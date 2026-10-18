-- Fase 7 (ADR-0052): piloto cerrado con lista de teléfonos por ciudad e interés de los demás.
CREATE TABLE "pilot_allowlist" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "city_id" UUID NOT NULL,
    "phone" TEXT NOT NULL,
    "note" TEXT,
    "added_by_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "pilot_allowlist_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "pilot_allowlist_city_id_phone_key" ON "pilot_allowlist"("city_id", "phone");

ALTER TABLE "pilot_allowlist" ADD CONSTRAINT "pilot_allowlist_city_id_fkey"
  FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

CREATE TABLE "pilot_interest" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "city_id" UUID NOT NULL,
    "phone" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "category_id" UUID,
    "zone" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "pilot_interest_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "pilot_interest_city_id_phone_key" ON "pilot_interest"("city_id", "phone");
CREATE INDEX "pilot_interest_city_id_created_at_idx" ON "pilot_interest"("city_id", "created_at");

ALTER TABLE "pilot_interest" ADD CONSTRAINT "pilot_interest_city_id_fkey"
  FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pilot_interest" ADD CONSTRAINT "pilot_interest_category_id_fkey"
  FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;
