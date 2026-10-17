# ADR-0038: Tope de deuda y bloqueo por deuda

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 5

## Contexto
- R7.5: si la comisión pendiente supera 150 Bs antes del corte, se exige pago para seguir recibiendo solicitudes (en propuesta).
- R7.7: un corte vencido sin pago lleva a `bloqueado_deuda`, y un pago confirmado desbloquea automáticamente.
- La máquina de estados del trabajador (ADR-0013) ya tiene `BLOCK_FOR_DEBT` y `DEBT_PAID`, y al bloquear ya pasa la cuenta a modo empleador y le quita la disponibilidad.
- El matching ya tenía el hook `DebtCapPolicy` y la suspensión ya consultaba `DebtStatusProvider`, pero los dos estaban vacíos.

## Decisión
- **Tope (`DebtCapService`, implementa `DebtCapPolicy`):**
  - **saldo pendiente = suma de todo el ledger del trabajador**, periodo abierto incluido;
  - con saldo `> BILLING_DEBT_CAP_BS` (150), el matching y las ofertas lo excluyen (`tope_de_deuda`); una sola consulta por lote;
  - **no cambia el estado** del trabajador: sigue `aprobado` y puede trabajar lo que ya tiene;
  - pagar (aunque sea antes del corte) baja el saldo y lo libera de inmediato, porque la exclusión se calcula en cada anillo y cada oferta;
  - **aviso al cruzar el tope, una sola vez hasta que baje:** `worker_profiles.debt_cap_reached_at` se pone con un `UPDATE … WHERE debt_cap_reached_at IS NULL` (gana uno solo) y se limpia al bajar.
- **Bloqueo (`DebtStateService.reconcile`)**, idempotente:
  - aprobado con algún periodo `vencido` → `BLOCK_FOR_DEBT`;
  - `bloqueado_deuda` sin periodos vencidos → `DEBT_PAID` (vuelve a `aprobado`; **no cambia el modo solo**, se usa el interruptor);
  - suspendido: no se toca. La suspensión tiene prioridad, y al levantarla `LIFT_SUSPENSION` consulta la deuda vencida real (`BillingDebtStatusProvider`).
  - Lo disparan el worker con `billing.notice` (vencido) y `billing.balance_changed` (pagos y ajustes), y un barrido de respaldo junto con el reconciliador.
  - **La fuente de verdad es billing:** un `BLOCK_FOR_DEBT` manual sin periodos vencidos se revierte en el barrido.
- **Avisos (`RealtimeWorkerNotifier`, reemplaza el notifier de log):**
  - al pasar a `bloqueado_deuda` o `suspendido_moderacion`: `account:blocked` con el motivo, más un aviso con push;
  - al salir: `account:unblocked`, más un aviso con push.
  - Se llama después de confirmar la transacción; si falla, el cambio de estado queda igual.
- **Interruptor:** la negativa de modo ya decía `WORKER_BLOCKED_DEBT` con `nextAction = PAY_COMMISSION`. La app lo lleva a "Pagar comisión".

## Consecuencias
- El tope es una consulta de suma por trabajador en cada anillo. Si el volumen crece, se puede materializar el saldo sin cambiar la regla.
- Un trabajador sobre el tope puede terminar sus trabajos en curso. No recibe nuevos hasta pagar.
- Un pago desbloquea por evento, con unos cientos de ms de demora (outbox), no en la misma respuesta HTTP.
