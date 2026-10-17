-- Tiempo mínimo de búsqueda: cada cierre programado lleva su número (ADR-0025).
-- AlterTable
ALTER TABLE "service_requests" ADD COLUMN     "close_seq" SMALLINT NOT NULL DEFAULT 0;

