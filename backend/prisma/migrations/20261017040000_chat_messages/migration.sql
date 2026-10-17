-- Chat del trabajo (ADR-0031).
-- CreateEnum
CREATE TYPE "chat_message_status" AS ENUM ('entregado', 'retenido');

-- CreateTable
CREATE TABLE "chat_messages" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "job_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "sender_id" UUID NOT NULL,
    "body" TEXT NOT NULL,
    "status" "chat_message_status" NOT NULL,
    "moderation_matches" JSONB,
    "read_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "chat_messages_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "chat_messages_job_id_created_at_idx" ON "chat_messages"("job_id", "created_at");

-- CreateIndex
CREATE INDEX "chat_messages_status_created_at_idx" ON "chat_messages"("status", "created_at");

-- AddForeignKey
ALTER TABLE "chat_messages" ADD CONSTRAINT "chat_messages_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "chat_messages" ADD CONSTRAINT "chat_messages_body_length_check"
  CHECK (char_length("body") BETWEEN 1 AND 1000);
