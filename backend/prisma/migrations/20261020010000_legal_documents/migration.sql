-- Fase 7 (ADR-0051): textos legales con versión y su aceptación (append-only).
CREATE TYPE "legal_document_type" AS ENUM ('terms', 'privacy');

CREATE TABLE "legal_documents" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "type" "legal_document_type" NOT NULL,
    "version" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "content_md" TEXT NOT NULL,
    "published_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "legal_documents_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "legal_documents_type_version_key" ON "legal_documents"("type", "version");

CREATE TABLE "legal_acceptances" (
    "id" BIGSERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "type" "legal_document_type" NOT NULL,
    "version" INTEGER NOT NULL,
    "adult_declared" BOOLEAN NOT NULL DEFAULT false,
    "app_version" TEXT,
    "platform" TEXT,
    "accepted_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "legal_acceptances_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "legal_acceptances_user_id_type_version_idx" ON "legal_acceptances"("user_id", "type", "version");

ALTER TABLE "legal_acceptances" ADD CONSTRAINT "legal_acceptances_user_id_fkey"
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- La aceptación es evidencia: nunca se modifica ni se borra (como el ledger).
CREATE FUNCTION legal_acceptances_append_only() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'legal_acceptances es append-only: % no permitido', TG_OP
    USING ERRCODE = 'insufficient_privilege';
END;
$$;

CREATE TRIGGER legal_acceptances_no_update_delete
  BEFORE UPDATE OR DELETE ON "legal_acceptances"
  FOR EACH ROW EXECUTE FUNCTION legal_acceptances_append_only();
