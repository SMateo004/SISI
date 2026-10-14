-- Fase 2: filtro de moderación (R3.3, R9.2, ADR-0018).
-- CreateEnum
CREATE TYPE "moderation_term_kind" AS ENUM ('word', 'regex');

-- CreateEnum
CREATE TYPE "prohibited_category" AS ENUM ('sexual', 'drogas', 'armas', 'ilegal', 'inmoral', 'venta_productos');

-- CreateTable
CREATE TABLE "moderation_terms" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "term" TEXT NOT NULL,
    "kind" "moderation_term_kind" NOT NULL,
    "category" "prohibited_category" NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "note" TEXT,
    "created_by" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "moderation_terms_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "moderation_terms_term_kind_key" ON "moderation_terms"("term", "kind");


ALTER TABLE "moderation_terms" ADD CONSTRAINT "moderation_terms_term_length_check" CHECK (char_length("term") BETWEEN 2 AND 100);
