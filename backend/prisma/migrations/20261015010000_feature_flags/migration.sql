-- CreateTable
CREATE TABLE "feature_flags" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "key" TEXT NOT NULL,
    "city_id" UUID,
    "enabled" BOOLEAN NOT NULL DEFAULT false,
    "description" TEXT,
    "updated_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "feature_flags_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
-- NULLS NOT DISTINCT: solo puede haber un valor global (city_id null) por key.
CREATE UNIQUE INDEX "feature_flags_key_city_id_key" ON "feature_flags"("key", "city_id") NULLS NOT DISTINCT;

-- AddForeignKey
ALTER TABLE "feature_flags" ADD CONSTRAINT "feature_flags_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "cities"("id") ON DELETE CASCADE ON UPDATE CASCADE;


-- Formato de la key: minúsculas, dígitos, punto, guion o guion bajo.
ALTER TABLE "feature_flags" ADD CONSTRAINT "feature_flags_key_format_check" CHECK ("key" ~ '^[a-z0-9._-]{2,64}$');
