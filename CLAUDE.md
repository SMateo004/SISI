# SISI — app de servicios inmediatos (Bolivia)
Lee docs/00-contexto-general-SISI.md, docs/01-reglas-de-negocio.md y docs/02-contexto-tecnico-claude-code.md antes de cambiar algo.

## Stack
- backend/: NestJS + TypeScript estricto, Prisma, PostgreSQL+PostGIS, BullMQ, Socket.IO.
- apps/mobile y apps/admin: Flutter, Riverpod, go_router, carpeta por feature.
- Deploy: backend en Render (render.yaml), web en Vercel.

## Reglas
- Antes de cada fase, revisa docs/pendientes.md.
- No inventes reglas de negocio; si falta una, pregunta y anótala en docs/pendientes.md.
- Cada decisión técnica relevante se registra como ADR en docs/adr/ (usa docs/adr/0000-plantilla.md).
- Interfaz en español (Bolivia). Moneda Bs, montos Decimal con 2 decimales.
- ledger_entries es append-only: nunca UPDATE ni DELETE.
- Categorías solo desde la tabla categories.
- Toda entidad relevante lleva city_id.
- Cada funcionalidad lleva tests; corre los tests y el linter antes de dar por terminado.
- No subas secretos; usa variables de entorno (.env.example actualizado).
- Límites de peticiones: reutiliza RateLimitStore / @RateLimit (ADR-0010).
- El estado del trabajador solo cambia con WorkerStatusService.apply (ADR-0013).
- Precio y comisión de una categoría siempre vía CategoryResolver (ADR-0016); el estado de una solicitud solo con RequestStatusService (ADR-0019).
- Texto de usuarios (solicitudes, chat) se modera con ModerationService.check (ADR-0018).

## Comandos
- Local: docker compose -f infra/docker-compose.yml up -d
- Backend: cd backend && npm run start:dev / npm test / npm run test:e2e / npm run lint / npm run typecheck
- Herramientas de desarrollo (nunca en producción): cd backend && npm run dev:tools -- <comando> (ver docs/runbook.md)
- Contrato API: node packages/api_contract/generate.mjs (OpenAPI + cliente Dart)
- App: cd apps/mobile && flutter run / flutter test
- Admin: cd apps/admin && flutter run -d chrome / flutter test
