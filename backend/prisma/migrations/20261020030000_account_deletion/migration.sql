-- Fase 7 (ADR-0049): eliminación de cuenta por anonimización. Expandir: columna opcional y
-- tabla nueva; el código anterior no las usa.
ALTER TABLE "users" ADD COLUMN "deleted_at" TIMESTAMPTZ(3);

CREATE TABLE "account_deletions" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "user_id" UUID NOT NULL,
    "phone_hmac" TEXT NOT NULL,
    "source" TEXT NOT NULL,
    "had_worker_profile" BOOLEAN NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "account_deletions_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "account_deletions_user_id_key" ON "account_deletions"("user_id");
CREATE INDEX "account_deletions_phone_hmac_idx" ON "account_deletions"("phone_hmac");

ALTER TABLE "account_deletions" ADD CONSTRAINT "account_deletions_user_id_fkey"
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
