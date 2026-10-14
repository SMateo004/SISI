-- CreateEnum
CREATE TYPE "worker_status" AS ENUM ('sin_solicitar', 'pendiente_revision', 'aprobado', 'rechazado', 'bloqueado_deuda', 'suspendido_moderacion');

-- CreateEnum
CREATE TYPE "transport_mode" AS ENUM ('a_pie', 'bicicleta', 'moto', 'auto', 'transporte_publico');

-- CreateEnum
CREATE TYPE "worker_document_type" AS ENUM ('ci_front', 'ci_back', 'selfie', 'cert');

-- CreateEnum
CREATE TYPE "document_review_status" AS ENUM ('pendiente', 'aprobado', 'rechazado');

-- CreateTable
CREATE TABLE "categories" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price_min_bs" DECIMAL(10,2) NOT NULL,
    "price_max_bs" DECIMAL(10,2) NOT NULL,
    "commission_pct" DECIMAL(5,2) NOT NULL DEFAULT 13.00,
    "extra_requirements" JSONB NOT NULL DEFAULT '[]',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "worker_profiles" (
    "user_id" UUID NOT NULL,
    "status" "worker_status" NOT NULL DEFAULT 'sin_solicitar',
    "birth_date" DATE,
    "transport" "transport_mode",
    "max_radius_km" SMALLINT,
    "rating_avg" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "rating_count" INTEGER NOT NULL DEFAULT 0,
    "level" INTEGER NOT NULL DEFAULT 1,
    "submitted_at" TIMESTAMPTZ(3),
    "reviewed_at" TIMESTAMPTZ(3),
    "reviewed_by" UUID,
    "rejection_reason" TEXT,
    "moderation_resolution" TEXT,
    "status_changed_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "worker_profiles_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "worker_categories" (
    "worker_id" UUID NOT NULL,
    "category_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "worker_categories_pkey" PRIMARY KEY ("worker_id","category_id")
);

-- CreateTable
CREATE TABLE "worker_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "worker_id" UUID NOT NULL,
    "type" "worker_document_type" NOT NULL,
    "file_key" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "size_bytes" INTEGER NOT NULL,
    "review_status" "document_review_status" NOT NULL DEFAULT 'pendiente',
    "reviewed_by" UUID,
    "reviewed_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "worker_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "worker_status_events" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "worker_id" UUID NOT NULL,
    "event" TEXT NOT NULL,
    "from_status" "worker_status" NOT NULL,
    "to_status" "worker_status" NOT NULL,
    "reason" TEXT,
    "actor_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "worker_status_events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "worker_profiles_status_idx" ON "worker_profiles"("status");

-- CreateIndex
CREATE INDEX "worker_categories_category_id_idx" ON "worker_categories"("category_id");

-- CreateIndex
CREATE UNIQUE INDEX "worker_documents_worker_id_type_key" ON "worker_documents"("worker_id", "type");

-- CreateIndex
CREATE INDEX "worker_status_events_worker_id_created_at_idx" ON "worker_status_events"("worker_id", "created_at");

-- AddForeignKey
ALTER TABLE "worker_profiles" ADD CONSTRAINT "worker_profiles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_profiles" ADD CONSTRAINT "worker_profiles_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_categories" ADD CONSTRAINT "worker_categories_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "worker_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_categories" ADD CONSTRAINT "worker_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_documents" ADD CONSTRAINT "worker_documents_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "worker_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_documents" ADD CONSTRAINT "worker_documents_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_status_events" ADD CONSTRAINT "worker_status_events_worker_id_fkey" FOREIGN KEY ("worker_id") REFERENCES "worker_profiles"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "worker_status_events" ADD CONSTRAINT "worker_status_events_actor_id_fkey" FOREIGN KEY ("actor_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Reglas de integridad (R2.2): rango de precio coherente y comisión porcentual.
ALTER TABLE "categories" ADD CONSTRAINT "categories_price_range_check" CHECK ("price_min_bs" >= 0 AND "price_min_bs" <= "price_max_bs");
ALTER TABLE "categories" ADD CONSTRAINT "categories_commission_pct_check" CHECK ("commission_pct" >= 0 AND "commission_pct" <= 100);
ALTER TABLE "worker_profiles" ADD CONSTRAINT "worker_profiles_rating_avg_check" CHECK ("rating_avg" >= 0 AND "rating_avg" <= 5);
ALTER TABLE "worker_documents" ADD CONSTRAINT "worker_documents_size_check" CHECK ("size_bytes" > 0);
