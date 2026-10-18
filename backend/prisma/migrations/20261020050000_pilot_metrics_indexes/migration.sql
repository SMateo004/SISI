-- Fase 7 (ADR-0052): trabajadores activos por semana (retención del piloto) desde offer_events.
CREATE INDEX "offer_events_city_id_created_at_idx" ON "offer_events"("city_id", "created_at");
