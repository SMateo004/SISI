-- Búsqueda de usuarios del panel (Fase 6): ILIKE con índices trigram.
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- CreateIndex
CREATE INDEX "users_name_trgm_idx" ON "users" USING GIN ("name" gin_trgm_ops);

-- CreateIndex
CREATE INDEX "users_phone_trgm_idx" ON "users" USING GIN ("phone" gin_trgm_ops);

-- CreateIndex
CREATE INDEX "users_created_at_id_idx" ON "users"("created_at", "id");

