# ADR-0034: Ledger inmutable y convención de signo

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 5

## Contexto
R7.9 exige un ledger inmutable con tres tipos de movimiento (`comision`, `pago`, `ajuste`) que se corrige solo con ajustes. El saldo del trabajador, los cortes, el tope de deuda (R7.5) y el bloqueo (R7.7) se calculan a partir de él. Un error de signo o una fila editada cambia cuánto se le cobra a una persona.

## Decisión
- **Tabla `ledger_entries`:**
  - `id` (bigserial), `worker_id`, `city_id`, `period_id`, `type`, `amount_bs` (Decimal(12,2));
  - `job_id` (comisión), `payment_id` (pago), `corrects_entry_id`, `reason` y `created_by_id` (ajuste), `created_at`.
- **Convención de signo:** el monto lleva signo.
  - **Positivo = aumenta la deuda:** comisión, ajuste en contra del trabajador.
  - **Negativo = la reduce:** pago, ajuste a favor.
  - El **saldo** de un trabajador (o de un periodo) es `SUM(amount_bs)`. Positivo: debe. Negativo: saldo a favor.
- **Reglas en la base**, además de en el código:
  - `CHECK`:
    - comisión `> 0` y con `job_id`;
    - pago `< 0` y con `payment_id`;
    - ajuste `≠ 0`, con `reason` y `created_by_id`.
  - **Índice único parcial `(job_id) WHERE type = 'comision'`:** una sola comisión por trabajo; `job.completed` repetido no duplica.
  - **Trigger `ledger_entries_no_update_delete`:** rechaza `UPDATE` y `DELETE` (mismo patrón que `job_events`).
  - Para corregir, se agrega un `ajuste` que puede apuntar al movimiento que corrige.
- **Totales derivados:** `billing_periods.gross_bs` y `commission_bs` se actualizan en la misma transacción que la comisión.
  - Nunca son la fuente de verdad: el saldo siempre sale del ledger.
  - Un test de consistencia los compara con el ledger después de cada e2e de cobros.
- **Pagos que cubren varios periodos:** un movimiento `pago` por periodo cubierto, todos con el mismo `payment_id`. Así el saldo de cada periodo también es `SUM` de sus movimientos (ADR-0037).

## Consecuencias
- No hay forma de "arreglar" un número editándolo: toda corrección deja rastro con motivo y autor.
- Calcular un saldo es una suma indexada por trabajador o por periodo. Si crece mucho, se puede agregar un saldo materializado sin cambiar la regla.
- Un `TRUNCATE` (solo lo usan los e2e) no pasa por el trigger. En producción nadie tiene permiso para hacerlo.
