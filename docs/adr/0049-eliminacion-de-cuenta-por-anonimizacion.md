# ADR-0049: Eliminación de cuenta por anonimización

- Estado: aceptada (propuesta legal pendiente de revisión)
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Google Play y la App Store exigen poder eliminar la cuenta desde la app, y Google además una página web. Pero el ledger, los eventos de trabajos y ofertas, las auditorías y las aceptaciones legales son inmutables (triggers). Los trabajos y las solicitudes referencian al usuario con `RESTRICT`, y la contabilidad debe conservarse.

## Decisión
- **No se borra la fila del usuario: se anonimiza en una transacción.**

  | Dato | Qué pasa |
  | --- | --- |
  | Teléfono | `eliminado:<id>`: libera el número; la restricción de E.164 se amplía solo para cuentas con `deleted_at`, en una migración compatible |
  | Nombre y foto | Borrados |
  | Modo | `employer` |
  | `deleted_at` | Se marca |
  | Sesiones, dispositivos y avisos | Borrados |
  | Trabajador | Sin documentos (filas y archivos), sin fecha de nacimiento, sin ubicación (fila y Redis GEO) y no disponible |
  | Solicitudes abiertas | Canceladas con `RequestStatusService`; sus ofertas, cerradas |
  | Ofertas activas | Retiradas |
  | Fotos de sus solicitudes | Borradas |
  | Direcciones | "Dirección eliminada", con el punto redondeado a unos 1 km (sirve para las métricas por zona) |

  Los archivos los borra el worker por el outbox (`account.deleted`), de forma idempotente.
- **Se conservan con el id:** ledger, pagos, periodos, trabajos, calificaciones, `job_events`, `offer_events`, auditorías y aceptaciones legales.
- **No se puede eliminar** (409 con todos los motivos):
  - **con deuda:** la app muestra el monto y la referencia y lleva a pagar;
  - con un trabajo activo;
  - con un comprobante en revisión;
  - si es admin.
- **Confirmación:** un código nuevo por SMS al número de la cuenta.
  - **En la app:** `GET /me/deletion` (qué se borra, qué se conserva y qué lo impide), `POST /me/deletion/code` y `POST /me/deletion`.
  - **En la web**, para Google Play: `/eliminar-cuenta` en la app web, en HTML y JS sin Flutter. Usa `POST /account-deletion/code` (misma respuesta haya o no cuenta, y solo envía SMS si la hay) y `POST /account-deletion`.
  - Las dos funcionan sin aceptar los textos vigentes y con una app desactualizada.
- **La sesión se corta al instante:**
  - los refresh se borran;
  - una clave en Redis (`account:deleted:<id>`, con el TTL del acceso) hace que `JwtAuthGuard` rechace los tokens vigentes con 401 `ACCOUNT_DELETED`.
- **`account_deletions`** guarda un HMAC del teléfono, origen y si era trabajador. Así el panel puede reconocer un número que vuelve (por ejemplo, después de una suspensión) sin guardar el número.

## Consecuencias
- El mismo número puede crear una cuenta nueva, sin vínculo visible con la anterior salvo el HMAC.
- Los textos libres que quedaron en registros inmutables no se reescriben (por ejemplo, la nota de cancelación copiada en `job_events`). Los mensajes del chat siguen la retención (ADR-0050).
- **Pendiente de revisión legal:** el plazo de conservación contable y si el HMAC es aceptable.
