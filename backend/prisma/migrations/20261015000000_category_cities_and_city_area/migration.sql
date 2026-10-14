-- Fase 2: categorías por ciudad (R2.2, R10.1) y área de servicio de la ciudad (ADR-0016, ADR-0019).

-- slug estable de categoría. Las filas existentes (creadas a mano en la Fase 1) reciben uno derivado del id.
ALTER TABLE "categories" ADD COLUMN "slug" TEXT;
UPDATE "categories" SET "slug" = 'cat-' || substr("id"::text, 1, 8) WHERE "slug" IS NULL;
ALTER TABLE "categories" ALTER COLUMN "slug" SET NOT NULL;
CREATE UNIQUE INDEX "categories_slug_key" ON "categories"("slug");

-- Centro, radio y área opcional de cada ciudad.
ALTER TABLE "cities"
  ADD COLUMN "center" geography(Point,4326),
  ADD COLUMN "service_area" geography(Polygon,4326),
  ADD COLUMN "service_radius_km" DECIMAL(5,2);
ALTER TABLE "cities" ADD CONSTRAINT "cities_service_radius_check" CHECK ("service_radius_km" IS NULL OR "service_radius_km" > 0);

-- CreateTable
CREATE TABLE "category_cities" (
    "category_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "price_min_bs" DECIMAL(10,2),
    "price_max_bs" DECIMAL(10,2),
    "commission_pct" DECIMAL(5,2),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "category_cities_pkey" PRIMARY KEY ("category_id","city_id"),
    CONSTRAINT "category_cities_price_range_check" CHECK (
      ("price_min_bs" IS NULL OR "price_min_bs" >= 0)
      AND ("price_min_bs" IS NULL OR "price_max_bs" IS NULL OR "price_min_bs" <= "price_max_bs")
    ),
    CONSTRAINT "category_cities_commission_pct_check" CHECK (
      "commission_pct" IS NULL OR ("commission_pct" >= 0 AND "commission_pct" <= 100)
    )
);

CREATE INDEX "category_cities_city_id_idx" ON "category_cities"("city_id");

ALTER TABLE "category_cities" ADD CONSTRAINT "category_cities_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "category_cities" ADD CONSTRAINT "category_cities_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Las categorías activas que ya existían siguen disponibles en las ciudades actuales.
INSERT INTO "category_cities" ("category_id", "city_id", "active", "updated_at")
SELECT c."id", ci."id", true, CURRENT_TIMESTAMP
FROM "categories" c CROSS JOIN "cities" ci
WHERE c."active" = true
ON CONFLICT DO NOTHING;
