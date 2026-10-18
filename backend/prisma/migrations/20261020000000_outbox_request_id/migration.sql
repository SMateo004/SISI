-- Fase 7 (ADR-0048): id de correlación de la petición que generó el evento, para seguirlo en
-- los logs del worker. Expandir: columna nueva y opcional, compatible con el código anterior.
ALTER TABLE "outbox_events" ADD COLUMN "request_id" TEXT;
