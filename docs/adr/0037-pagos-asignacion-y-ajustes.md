# ADR-0037: Pagos, asignación, ajustes e idempotencia

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 5

## Contexto
- R7.4: en el MVP el trabajador paga por QR bancario con una referencia única por corte, y la empresa registra el pago con el comprobante. En una fase posterior habrá una pasarela automática.
- R7.9: nada se edita; se corrige con ajustes.
- Un pago puede cubrir varias semanas, ser parcial o venir de más.
- Un doble clic o un reintento de red del admin no puede crear dos pagos.

## Decisión
- **Registro (`POST /admin/billing/payments`, solo admin):**
  - datos: monto, `paidAt` (no futuro), método (`qr_transferencia` | `efectivo` | `otro`), referencia, comprobante (`receipts/{worker}/…`, subido con PUT prefirmado y verificado con `head`) y `invoiceNumber` opcional (sin uso hasta la revisión tributaria);
  - en una transacción: la fila de `payments` y **un movimiento `pago` por periodo cubierto** (todos con su `payment_id`), recálculo de estados y outbox `billing.payment_registered`.
- **Asignación (en propuesta):**
  - primero los periodos anteriores al actual con saldo, del más antiguo al más nuevo;
  - **parcial:** reduce el saldo; el periodo no pasa a `pagado` hasta cubrirse;
  - **lo que sobra** va al periodo actual: es un pago anticipado de la semana en curso o, si excede, **saldo a favor** (sin devolución automática), que se descuenta en el próximo corte.
  - Bloqueo de filas siempre en el mismo orden: el periodo actual y luego los anteriores por fecha.
- **Estados después de un pago o ajuste:**
  - un periodo cerrado pasa a `pagado` con saldo ≤ 0;
  - con saldo > 0 vuelve a `cerrado_pendiente`, o a `vencido` si su fecha pasó (un ajuste en contra sobre un periodo pagado);
  - un periodo abierto no se toca: lo cierra el cron.
- **Ajustes (`POST /admin/billing/adjustments`):**
  - monto con signo, **motivo obligatorio**, autor y, si corrige algo, `corrects_entry_id`;
  - van al periodo del movimiento corregido, al indicado o al actual.
- **Idempotencia (ajuste aprobado):**
  - pagos y ajustes exigen `Idempotency-Key` (8 a 100 caracteres), guardada en `idempotency_keys (scope, key)` con la huella del cuerpo y la respuesta;
  - la clave se inserta al comienzo de la misma transacción: un envío simultáneo espera en el índice único y devuelve la respuesta del primero;
  - la misma clave con otro cuerpo da 409 `IDEMPOTENCY_KEY_REUSED`;
  - si la operación falla, la clave se revierte con ella.
- **Autorrevisión (ajuste aprobado):** un admin no registra pagos ni ajustes sobre su propia cuenta de trabajador (403 `SELF_REVIEW_FORBIDDEN`). Lo mismo para subir comprobantes.
- **Desbloqueo:** el worker recibe `billing.payment_registered` o `billing.balance_changed`, reconcilia el bloqueo (ADR-0038), revisa el tope y avisa del pago con push.
- **Pasarela automática:** interfaz `PaymentGateway` sin implementar, detrás del flag `payments.gateway` (apagado).

## Consecuencias
- El saldo de cada periodo sigue siendo la suma de sus movimientos, así que la consistencia se puede verificar por periodo.
- La referencia escrita en la glosa ayuda a conciliar, pero no decide a qué periodo va el pago: se aplica a lo más antiguo.
- Un pago mal registrado se corrige con un ajuste negativo o positivo. No hay "anular pago".
