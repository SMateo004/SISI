-- Ciclo del trabajo (R6, ADR-0029): timestamps por estado, disputa e historial append-only.
-- AlterTable
ALTER TABLE "jobs" ADD COLUMN     "auto_confirmed" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "cancelled_at" TIMESTAMPTZ(3),
ADD COLUMN     "completed_at" TIMESTAMPTZ(3),
ADD COLUMN     "dispute_note" TEXT,
ADD COLUMN     "disputed_at" TIMESTAMPTZ(3),
ADD COLUMN     "on_the_way_at" TIMESTAMPTZ(3),
ADD COLUMN     "started_at" TIMESTAMPTZ(3),
ADD COLUMN     "worker_finished_at" TIMESTAMPTZ(3);

-- CreateTable
CREATE TABLE "job_events" (
    "id" BIGSERIAL NOT NULL,
    "job_id" UUID NOT NULL,
    "action" TEXT NOT NULL,
    "from_status" "job_status" NOT NULL,
    "to_status" "job_status" NOT NULL,
    "actor_role" TEXT NOT NULL,
    "actor_id" UUID,
    "note" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "job_events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "job_events_job_id_id_idx" ON "job_events"("job_id", "id");

-- AddForeignKey
ALTER TABLE "job_events" ADD CONSTRAINT "job_events_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "job_events" ADD CONSTRAINT "job_events_actor_role_check"
  CHECK ("actor_role" IN ('worker', 'employer', 'system', 'admin'));

-- job_events es append-only: se rechaza cualquier UPDATE o DELETE (igual que el ledger).
CREATE FUNCTION job_events_append_only() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  RAISE EXCEPTION 'job_events es append-only: % no permitido', TG_OP
    USING ERRCODE = 'insufficient_privilege';
END;
$$;

CREATE TRIGGER job_events_no_update_delete
  BEFORE UPDATE OR DELETE ON "job_events"
  FOR EACH ROW EXECUTE FUNCTION job_events_append_only();

-- Un trabajador tiene a lo sumo un trabajo activo (segunda barrera contra la doble asignación).
CREATE UNIQUE INDEX "jobs_one_active_per_worker" ON "jobs"("worker_id")
  WHERE "status" IN ('asignado', 'en_camino', 'en_curso');

-- Autoconfirmación pendiente (barrido de respaldo del reconciliador).
CREATE INDEX "jobs_autoconfirm_due_idx" ON "jobs"("worker_finished_at")
  WHERE "status" = 'en_curso' AND "disputed_at" IS NULL AND "worker_finished_at" IS NOT NULL;
