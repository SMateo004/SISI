# ADR-0029: Ciclo del trabajo, autoconfirmación y disputa

- Estado: aceptada
- Fecha: 2026-10-16
- Fase: 4

## Contexto
La Fase 3 deja el trabajo en `asignado`. R6.1 fija los estados (`asignado → en_camino → en_curso → terminado`, o `cancelado`) y R6.2 dice que el empleador confirma el término. Hace falta:
- decidir quién puede hacer cada paso;
- qué pasa si el empleador nunca confirma;
- cómo se maneja un desacuerdo;
- cómo evitar que un trabajador quede con dos trabajos a la vez.

## Decisión
- **Máquina de estados pura con actor** (`src/jobs/job-status.machine.ts`). Cada acción tiene actores, estados de origen y una condición:

  | Acción | Actor | Desde → hacia |
  | --- | --- | --- |
  | `START_TRIP` | trabajador | asignado → en_camino |
  | `START_WORK` | trabajador | en_camino → en_curso |
  | `FINISH` ("Terminé") | trabajador | en_curso (sin cambio); solo una vez |
  | `CONFIRM` | empleador | en_curso → terminado; sin disputa |
  | `AUTO_CONFIRM` | sistema | en_curso → terminado; con FINISH y sin disputa |
  | `DISPUTE` ("Hubo un problema") | empleador | en_curso (sin cambio); después de FINISH |
  | `RESOLVE_CONFIRM` / `RESOLVE_CANCEL` | admin | en_curso → terminado / cancelado; con disputa |
  | `CANCEL` | cualquiera de las dos partes | asignado o en_camino → cancelado |

  - Un actor equivocado da 403 `JOB_ACTION_FORBIDDEN`; un estado o una condición que no corresponde, 409 `JOB_TRANSITION_NOT_ALLOWED` con un mensaje en español.
  - A un tercero se le responde 404 (no se revela que el trabajo existe).
  - `allowedJobActions` le dice a la app qué botones mostrar.
- **`JobStatusService.apply` es el único que cambia `jobs`.** En una transacción:
  - bloquea la fila con `FOR UPDATE`;
  - valida con la máquina de estados;
  - guarda el timestamp de la acción (`on_the_way_at`, `started_at`, `worker_finished_at`, `disputed_at`, `completed_at`, `cancelled_at`);
  - escribe `job_events` y el outbox `job.status_changed`.
  - Al terminar calcula la comisión (ADR-0030) y agrega `job.completed`.
  - Al cancelar pasa la solicitud de `asignada` a `cancelada` (evento `JOB_CANCELLED` de la solicitud).
- **`job_events` es append-only.** Un trigger rechaza `UPDATE` y `DELETE`, igual que se hará con el ledger. Guarda la acción, desde, hacia, rol del actor, id del actor (null = sistema) y nota (resolución del admin).
- **Autoconfirmación (propuesta: 24 h, `JOB_AUTOCONFIRM_MS`):**
  - el handler de `job.status_changed` con FINISH programa en la cola de matching el job demorado `autoconfirm_{jobId}`;
  - con DISPUTE, o al cerrarse el trabajo, lo quita;
  - el job confirma solo si sigue en curso, con FINISH y sin disputa; si no, no hace nada (idempotente);
  - de respaldo, el reconciliador barre los vencidos cada minuto, por si se perdió el job de Redis.
- **Disputa:**
  - el trabajo sigue en curso con `disputed_at` y la nota del empleador; no hay autoconfirmación ni `job.completed`;
  - lo resuelve un administrador (`GET /admin/jobs/disputed`, `POST /admin/jobs/:id/resolve` o `dev-tools resolve-dispute`): confirmar da terminado con comisión; cancelar da cancelado sin comisión;
  - la nota queda en `job_events`.
- **Tiempo real y avisos:**
  - `job:status` va a las dos partes con `action` (FINISH y DISPUTE no cambian el estado);
  - la contraparte de quien actuó recibe un aviso con push: en camino, empezó, terminó, confirmado con el neto y la comisión, disputa, resolución.
- **Trabajador ocupado y doble asignación:**
  - el matching y las ofertas excluyen a un trabajador con un trabajo activo (ADR-0025);
  - al ser elegido, sus otras ofertas activas se retiran solas, cada una en su transacción con la solicitud bloqueada; el otro empleador recibe `offer:closed` (`retirada`) y, si era la única oferta, su solicitud vuelve a buscar;
  - en la aceptación se bloquea también el perfil del trabajador (`FOR UPDATE`), así que dos empleadores que lo eligen a la vez van en serie: el segundo ve el trabajo activo, se le retira la oferta (esa parte se confirma) y recibe 409 `WORKER_BUSY`;
  - como última barrera, el índice único parcial `jobs_one_active_per_worker` (`worker_id` con estado activo).

## Consecuencias
- El trabajador no puede cerrar un trabajo solo: necesita la confirmación del empleador o que venza el plazo.
- Un empleador que no responde no deja el trabajo abierto para siempre, y uno con un problema real lo frena reportándolo.
- Las disputas necesitan atención humana; la consola del admin llega en la Fase 6.
- Plazos y reglas de la disputa están en propuesta (docs/pendientes.md).
