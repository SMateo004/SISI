# ADR-0033: Reportes y suspensión

- Estado: aceptada
- Fecha: 2026-10-16
- Fase: 4

## Contexto
R9.3 permite reportar solicitudes, perfiles y mensajes del chat. Con 3 reportes válidos, la cuenta pasa a `suspendido_moderacion` hasta revisión. Hay que evitar dos cosas:
- que una sola persona suspenda a otra reportándola varias veces;
- que alguien reporte cosas con las que nunca tuvo relación.

Además, `suspendido_moderacion` es un estado del **perfil de trabajador** (R1.4, ADR-0013): no existe para alguien que solo usa la app como empleador.

## Decisión
- **Tabla `reports`** (doc 02):
  - `reporter_id`, `target_type` (`request`, `user`, `chat_message`, `job`), `target_id`;
  - `reported_user_id`: dueño del objetivo, a quien cuentan los reportes;
  - `city_id`, `reason`, `note` y `note_held`;
  - `status` (`pendiente` | `valido` | `descartado`), `resolution`, `resolved_by_id`, `resolved_at`;
  - `UNIQUE(reporter_id, target_type, target_id)`; CHECK de que nadie se reporta a sí mismo.
- **Motivos (lista cerrada):**
  - los de R9.1: `servicios_sexuales`, `drogas`, `armas`, `ilegal`, `inmoral`, `venta_productos`;
  - de convivencia: `acoso`, `fraude`, `no_se_presento`, `suplantacion`, `otro`.
  - La nota (hasta 500) pasa por la moderación solo para informar al admin (`note_held`).
- **Relación exigida.** Si no la hay, 404 `REPORT_TARGET_NOT_FOUND` (no se revela que existe):

  | Objetivo | Quién puede reportarlo | Cuenta para |
  | --- | --- | --- |
  | solicitud | un trabajador al que le llegó | el empleador |
  | trabajo | una de las dos partes | la otra parte |
  | mensaje | la parte que lo recibió (no quien lo envió) | quien lo envió |
  | perfil | quien tuvo un trabajo con esa persona, recibió o hizo una oferta con ella, o le llegó una solicitud suya | esa persona |

- **Un mensaje reportado deja de mostrarse para quien lo reportó.** Quien lo envió lo sigue viendo.
- **Conteo** (`ReportsService.enforce`, regla pura `suspensionDecision`), al marcar un reporte como válido:
  - cuentan las **personas distintas** con un reporte válido contra el usuario; umbral `REPORTS_SUSPEND_THRESHOLD` = 3;
  - trabajador `aprobado` o `bloqueado_deuda`: `WorkerStatusService.apply(SUSPEND)`, que ya fuerza el modo empleador y apaga la disponibilidad;
  - ya suspendido: nada;
  - solo empleador: `users.moderation_flagged_at` y aviso en el log, para que lo revise el admin.
  - Es idempotente: se puede volver a correr.
- **Admin mínimo:**
  - `GET /admin/reports?status=`, que muestra del reportado los reportes válidos, el estado de trabajador y la marca;
  - `POST /admin/reports/:id/resolve {valid, resolution}`;
  - `dev-tools resolve-report`.
  - La consola completa llega en la Fase 6.
- **Lo que ve quien reporta:** `GET /reports/mine` con el estado de sus reportes.

## Consecuencias
- Hace falta revisión humana para que un reporte cuente: sin admin, nadie se suspende.
- Un empleador problemático no queda bloqueado automáticamente: el MVP no tiene un estado para eso (pendiente en docs/pendientes.md, junto con el bloqueo permanente).
- Levantar la suspensión sigue siendo `LIFT_SUSPENSION` de ADR-0013.
