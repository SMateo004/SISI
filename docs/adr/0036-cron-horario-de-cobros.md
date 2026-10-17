# ADR-0036: Cron de cobros cada hora (puesta al día idempotente)

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 5

## Contexto
`render.yaml` corría `billing-cron` una vez por semana (lunes 03:59 UTC = domingo 23:59 en Bolivia) y doc 02 §7 sugería una revisión diaria aparte para los vencidos. Ese diseño tiene tres problemas:
- Si la única corrida semanal falla (deploy, base caída), nadie cierra los periodos hasta la semana siguiente.
- El horario UTC fijo supone que todas las ciudades están en UTC−4.
- Los recordatorios de R7.6 (víspera y día del vencimiento) necesitan correr en otros momentos.

## Decisión
- **`billing-cron` corre cada hora** (`"5 * * * *"` en staging y producción). Cada corrida es una **puesta al día** (`BillingCatchUpService.run(now)`):
  1. **Cierra** los periodos `abierto` con `end_at ≤ now`:
     - pasan a `cerrado_pendiente`, o a `pagado` si su saldo es ≤ 0;
     - si se demoró mucho y la fecha límite también pasó, a `vencido`.
  2. **Vence** los `cerrado_pendiente` con `due_at ≤ now` y saldo > 0. Con saldo ≤ 0 pasan a `pagado`.
  3. **Recordatorios:** víspera y día del vencimiento a las `BILLING_REMINDER_HOUR` locales, solo de periodos con saldo pendiente.
- Los límites se calculan en la zona de cada periodo, no en el cron. El horario del cron no tiene relación con el negocio: solo fija la granularidad (a lo sumo 1 h de demora).
- **Idempotente:**
  - cada periodo se recalcula con su fila bloqueada (`FOR UPDATE`) y solo si sigue en el estado esperado;
  - cada aviso se registra en `billing_notices (period_id, kind)` con `ON CONFLICT DO NOTHING`, y solo si se insertó pasa al outbox;
  - correr dos veces, o diez, no repite cierres ni avisos;
  - una corrida que falla se recupera en la siguiente.
- **Candado:** `SET billing:catchup:lock NX PX` en Redis (`BILLING_LOCK_TTL_MS`, 10 min), liberado solo por su dueño. Dos corridas no se pisan, y aunque se pisaran, las filas bloqueadas y los avisos únicos lo impiden.
- **El cron no envía nada.** Escribe en Postgres y en el outbox (`billing.notice`); el worker emite `billing:due`, los avisos con push y el bloqueo por deuda (ADR-0038).
- **Comisión durante el cierre:** la comisión y el cierre bloquean la misma fila del periodo.
  - O la comisión entra antes y el cierre la cuenta, o ve el periodo cerrado y va al periodo abierto actual.
  - Nunca queda en dos ni en ninguno; hay un test de concurrencia.
- **Reloj simulado:** `run(now)` recibe la hora. Los e2e y `dev-tools billing-run --at <ISO>` simulan el corte y el vencimiento.

## Consecuencias
- Hasta 1 h de demora entre el corte y el aviso. Es aceptable: el trabajador tiene hasta el miércoles.
- 24 corridas por día en Render (cron *starter*). Cada corrida es una consulta por índice (`status, end_at` y `status, due_at`) cuando no hay nada que hacer.
- Una comisión que llega con su periodo ya cerrado va al periodo actual (docs/pendientes.md).
