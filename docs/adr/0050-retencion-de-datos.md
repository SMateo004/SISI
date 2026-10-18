# ADR-0050: Retención de datos y limpieza

- Estado: aceptada (plazos en propuesta, apagada hasta aprobarlos)
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Varios datos personales quedaban para siempre: carnets de rechazados, la última ubicación de quien ya no usa la app, chats viejos, borradores abandonados (pendiente desde la Fase 2), comprobantes rechazados, avisos leídos y tokens vencidos. La privacidad y las tiendas piden plazos. A la vez, esta fase no puede borrar datos sin una decisión explícita.

## Decisión
- **`RetentionService`** con una tarea por tipo de dato. Cada tarea:
  - va por lotes de 500;
  - es idempotente: correrla dos veces no cambia nada;
  - en `dryRun` solo cuenta.

  | Dato | Plazo propuesto | Qué hace |
  | --- | --- | --- |
  | Documentos de rechazados sin reenvío | 90 días desde el rechazo | Borra el archivo y después la fila |
  | Ubicación de trabajadores no disponibles | 30 días | Borra su fila (no hay historial) |
  | Mensajes del chat | 180 días después de terminado o cancelado | El cuerpo pasa a "Mensaje eliminado por antigüedad.", salvo que haya un reporte pendiente sobre el trabajo o el mensaje |
  | Borradores | 7 días | Borra la solicitud, sus fotos del bucket y sus eventos (en cascada) |
  | Comprobantes rechazados | 365 días | Borra el archivo y marca `receipt_purged_at`; la fila queda |
  | Avisos leídos | 90 días | Los borra |
  | Refresh vencidos | 30 días | Los borra |
  | Claves de idempotencia | 30 días | Las borra |

  Cada plazo es una variable `RETENTION_*_DAYS`.
- **Nunca toca:** ledger, pagos, periodos, `job_events`, `offer_events`, auditoría ni aceptaciones legales. Los comprobantes registrados son contables (propuesta: 5 años; no hay tarea hasta que exista un dato tan viejo).
- **Apagada por defecto** (`RETENTION_ENABLED=false`). Encendida, el worker la programa una vez por día (`RETENTION_RUN_MS`); apagada, quita la programación. `dev-tools retention --dry-run` muestra cuánto borraría.

## Consecuencias
- Los plazos se aprueban en pendientes, junto con la revisión legal.
- Encenderla es una variable de entorno, y se revierte igual.
- El worker necesita las credenciales del almacenamiento para borrar archivos (`render.yaml`).
