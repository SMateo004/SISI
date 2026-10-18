-- CreateEnum
CREATE TYPE "offer_event_kind" AS ENUM ('creada', 'reemplazada', 'retirada', 'aceptada', 'cerrada');

-- CreateTable
CREATE TABLE "offer_events" (
    "id" BIGSERIAL NOT NULL,
    "offer_id" UUID NOT NULL,
    "request_id" UUID NOT NULL,
    "worker_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "kind" "offer_event_kind" NOT NULL,
    "revision" INTEGER NOT NULL,
    "type" "offer_type" NOT NULL,
    "amount_bs" DECIMAL(10,2) NOT NULL,
    "eta_min" INTEGER NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "offer_events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "offer_events_offer_id_id_idx" ON "offer_events"("offer_id", "id");

-- CreateIndex
CREATE INDEX "offer_events_request_id_created_at_idx" ON "offer_events"("request_id", "created_at");

-- AddForeignKey
ALTER TABLE "offer_events" ADD CONSTRAINT "offer_events_offer_id_fkey" FOREIGN KEY ("offer_id") REFERENCES "offers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


-- Append-only (ADR-0042).
CREATE FUNCTION offer_events_append_only() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'offer_events es append-only: % no permitido', TG_OP
    USING ERRCODE = 'insufficient_privilege';
END;
$$;

CREATE TRIGGER offer_events_no_update_delete
  BEFORE UPDATE OR DELETE ON "offer_events"
  FOR EACH ROW EXECUTE FUNCTION offer_events_append_only();

-- Ofertas anteriores: una fila "creada" con el monto actual (el historial previo no existe).
INSERT INTO "offer_events" ("offer_id", "request_id", "worker_id", "city_id", "kind", "revision", "type", "amount_bs", "eta_min", "created_at")
SELECT "id", "request_id", "worker_id", "city_id", 'creada', "revision", "type", "amount_bs", "eta_min", "created_at"
FROM "offers";
