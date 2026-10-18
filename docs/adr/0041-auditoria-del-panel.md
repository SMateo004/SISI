# ADR-0041: Auditoría del panel append-only, en la misma transacción

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
Desde el panel se aprueban identidades, se mueve dinero y se suspenden cuentas. Hace falta saber quién hizo qué, sobre qué, con qué motivo y desde dónde. Ese registro no puede perderse si el cambio se aplicó, ni quedar si el cambio se revirtió.

## Decisión

### Tabla `admin_audit_log`
- **Columnas:**
  - `admin_id` (FK a `users`);
  - `action` (`área.verbo`, p. ej. `verification.approve` o `billing.payment`);
  - `target_type` y `target_id`;
  - `before` y `after` (jsonb), `reason`;
  - `ip`, `forwarded_for`, `user_agent`;
  - `city_id` y `created_at`.
- **Append-only:** el trigger `admin_audit_log_no_update_delete` rechaza UPDATE y DELETE, igual que el ledger (ADR-0034).
- **Índices:** `(created_at desc)`, `(admin_id, created_at)`, `(target_type, target_id)` y `(action, created_at)`.

### En la misma transacción
- `AdminAuditService.record(tx, ctx, entry)` recibe **siempre** el cliente de la transacción del cambio.
- Los servicios de dominio reciben un `AuditHook` opcional (`audit.hook(ctx)`) y lo llaman dentro de su transacción. Así siguen siendo los únicos que cambian estado (máquinas de estados, ledger, moderación):
  - `WorkerStatusService.apply` lo recibe por `alsoInTransaction`;
  - `RequestStatusService` y `JobStatusService` por su `tx`;
  - el resto de los servicios, por un parámetro `audit`.
- El controlador solo arma el `AdminContext` (`@AdminCtx()`: admin, IP, X-Forwarded-For y user agent) y no escribe en la base.
- Montos en `before` y `after` como texto con 2 decimales, fechas ISO y bigint como texto (`toAuditJson`).
- Las lecturas no se auditan, salvo las exportaciones CSV y la apertura de documentos de identidad.

### Consulta
`GET /admin/audit` (permiso `auditoria`):
- filtros por admin, acción (o prefijo, p. ej. `billing.`), objetivo y rango de fechas;
- 50 por página con cursor por id, de la más nueva a la más vieja.

## Consecuencias
- Toda acción nueva del panel debe auditar. El e2e de cada área verifica su fila.
- La IP es la que ve la API: con el proxy del panel es la de Vercel. `forwarded_for` queda como dato informativo (ADR-0040).
- La tabla crece sin límite. Con el volumen del MVP no es un problema; un archivado por año queda en pendientes.
