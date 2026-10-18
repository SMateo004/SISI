-- Fase 7 (ADR-0051): textos legales que valen solo para el piloto cerrado ("v0"). Mientras sean
-- los vigentes, producción exige el flag pilot.closed encendido.
ALTER TABLE "legal_documents" ADD COLUMN "pilot_only" BOOLEAN NOT NULL DEFAULT false;
