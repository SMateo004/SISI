# ADR-0013: Máquina de estados del perfil de trabajador

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
R1.4 define 6 estados cerrados. Varias fases los cambian: el upgrade (Fase 1), billing (Fase 5) y la moderación y el admin (Fase 6). Hace falta un único lugar que decida qué transición es válida, con historial y efectos colaterales (R1.6).

## Decisión
- `worker-status.machine.ts`: función pura `nextWorkerStatus(estado, evento)` con una tabla explícita; cualquier otra combinación lanza 409 `WORKER_TRANSITION_NOT_ALLOWED`. Transiciones:

  | Desde | Evento | Hacia |
  | --- | --- | --- |
  | sin_solicitar, rechazado | SUBMIT | pendiente_revision |
  | pendiente_revision | APPROVE / REJECT | aprobado / rechazado |
  | aprobado | BLOCK_FOR_DEBT | bloqueado_deuda |
  | bloqueado_deuda | DEBT_PAID | aprobado |
  | aprobado, **bloqueado_deuda** | SUSPEND | suspendido_moderacion (la suspensión tiene prioridad sobre la deuda) |
  | suspendido_moderacion | CONFIRM_SUSPENSION | suspendido_moderacion (sin estados nuevos; registra la resolución) |
  | suspendido_moderacion | LIFT_SUSPENSION | aprobado, o **bloqueado_deuda** si hay deuda vencida |

- `WorkerStatusService.apply()` es el único punto que escribe `worker_profiles.status`. En una transacción:
  1. valida con la máquina de estados;
  2. actualiza con control de concurrencia (`where status = actual`);
  3. guarda motivo, resolución y revisor;
  4. agrega una fila en `worker_status_events` (historial: quién, cuándo, por qué; `actor_id` null = sistema);
  5. si el nuevo estado es `bloqueado_deuda` o `suspendido_moderacion` y la cuenta estaba en modo worker, la pasa a employer y avisa (R1.6). Al desbloquear no la vuelve a worker.
- Puertos para fases futuras: `DebtStatusProvider` (billing, Fase 5; hoy siempre "sin deuda") y `WorkerNotifier` (push y Socket.IO, Fase 4; hoy solo log).
- Interruptor de modo (`mode-switch.rules.ts`): a employer siempre; a worker solo con `aprobado`, con una condición atómica en el `UPDATE`. Si no, 409 con `code`, `message`, `nextAction` y `actionLabel` en español para cada estado.
- Aprobar y rechazar se hacen hoy con `npm run dev:tools` (se niega a correr con `APP_ENV=production`), hasta el panel admin de la Fase 6.

## Consecuencias
Las fases 5 y 6 solo disparan eventos; no tocan el estado a mano. Cualquier regla nueva (p. ej. bloqueo permanente) empieza por la tabla y sus tests.
