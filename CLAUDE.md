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
- El estado de un trabajo solo con JobStatusService.apply (ADR-0029); la comisión solo con commissionOf (HALF_UP, ADR-0030). job_events es append-only (trigger).
- Un trabajador con un trabajo activo queda ocupado: fuera del matching y sin poder ofertar (ADR-0029).
- Cobros: el saldo es siempre la suma del ledger (monto con signo, ADR-0034); periodos y fechas por la zona horaria de la ciudad, nunca con offset fijo (ADR-0035); el bloqueo por deuda solo con DebtStateService (ADR-0038). Pagos y ajustes del admin exigen Idempotency-Key y nunca sobre su propia cuenta (ADR-0037).
- Panel admin (Fase 6): todo controlador /admin usa @Admin('<permiso>') (ADR-0040; el test de barrido falla si falta). Las acciones pasan por los servicios de dominio, auditan con AdminAuditService.record en la misma transacción (ADR-0041) y nunca sobre la propia cuenta (assertNotSelf).
- Parámetros de negocio del catálogo de ADR-0043: leerlos con AppSettingsService.value en cada uso, no con ConfigService. Cambios de ofertas con recordOfferEvent/closeActiveOffers (offer_events append-only, ADR-0042).
- El panel usa el cliente generado (ADR-0045): después de cambiar la API, regenerar el contrato.
- Toda FK que se agregue a mano en una migración se declara también como relación en schema.prisma (si no, el siguiente `migrate diff` la borra). Revisa que el SQL generado no tenga DROP.
- Texto de usuarios (solicitudes, chat, notas de cancelación, comentarios de calificaciones y reportes) se modera con ModerationService.check (ADR-0018).
- Eventos de dominio por outbox: OutboxService.add dentro de la misma transacción del cambio; nada de eventos en memoria (ADR-0022). Los handlers del worker deben ser idempotentes.
- Tiempos de matching, outbox y ubicación siempre por configuración (los e2e usan milisegundos). Tiempo real: solo los eventos de doc 02 §6 (docs/realtime-events.md).
- E2E: una corrida a la vez; identificadores con test/utils/unique.ts (nunca Date.now ni azar). Antes de cerrar una fase: npm run test:e2e:repeat -- 20 (ADR-0028).
- Migraciones: expandir y luego contraer (ADR-0046). Una migración nunca rompe al código que sigue corriendo: primero se agrega (columna opcional, tabla, índice) y lo viejo se quita en una release posterior, con `-- contract: <motivo>` en la línea anterior. `npm run check:migrations` lo verifica en CI.
- Producción solo con un tag vX.Y.Z sobre main y aprobación (deploy-production); la versión es una sola para backend y apps (`node tools/bump-version.mjs X.Y.Z`) y va en CHANGELOG.md.
- Nunca datos personales en logs ni en Sentry: teléfonos con maskPhone y textos con redactText o redactValue (ADR-0047). Nunca registres códigos, tokens ni claves de archivo.
- Toda ruta de usuario nueva con parámetro lleva su caso en test/idor.e2e-spec.ts (si no, el test falla). Límites por usuario con @RateLimit y `per: 'user'`.
- Rutas que deben funcionar sin aceptar los textos legales o con una app vieja: @SkipLegal (ADR-0051) y @SkipAppVersion (ADR-0054); muy pocas.
- Un dato personal o archivo nuevo de un usuario se suma a la eliminación de cuenta (ADR-0049) y a la retención (ADR-0050).

## Comandos
- Local: docker compose -f infra/docker-compose.yml up -d
- Backend: cd backend && npm run start:dev / npm test / npm run test:e2e / npm run test:e2e:repeat -- 20 / npm run lint / npm run typecheck
- Worker (outbox, matching, avisos, cobros): cd backend && npm run build && npm run start:worker
- Cron de cobros (cada hora en Render): cd backend && npm run start:billing-cron; con reloj simulado: npm run dev:tools -- billing-run --at <ISO>
- Herramientas de desarrollo (nunca en producción): cd backend && npm run dev:tools -- <comando> (ver docs/runbook.md)
- Contrato API: node packages/api_contract/generate.mjs (OpenAPI + cliente Dart)
- Release: node tools/bump-version.mjs X.Y.Z, CHANGELOG.md y tag vX.Y.Z en main (docs/runbook.md, "Producción"); node tools/check-legal.mjs; cd backend && npm run check:migrations
- Prueba de carga (solo staging o local, con Docker): loadtest/README.md
- App: cd apps/mobile && flutter run / flutter test
- Admin: cd apps/admin && flutter run -d chrome / flutter test
