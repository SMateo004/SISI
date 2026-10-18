-- Fase 7 (ADR-0050): la retención borra el archivo de un comprobante rechazado y lo anota aquí,
-- así la limpieza es idempotente. Expandir: columna opcional.
ALTER TABLE "payment_submissions" ADD COLUMN "receipt_purged_at" TIMESTAMPTZ(3);
