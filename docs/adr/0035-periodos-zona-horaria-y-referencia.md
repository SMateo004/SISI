# ADR-0035: Periodos de cobro, zona horaria y referencia de pago

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 5

## Contexto
- R7.2 fija el corte el domingo a las 23:59 (hora de Bolivia) y R7.3 el pago hasta el miércoles a las 23:59. Los dos están en propuesta.
- R7.4 pide una referencia única por corte que el trabajador escribe en la glosa de una transferencia.
- Las fechas se guardan en UTC, pero los límites del negocio son locales.
- Bolivia no tiene horario de verano, pero otra ciudad podría tenerlo. Un cálculo con `−4` fijo fallaría en silencio.

## Decisión
- **Zona horaria:** la de la ciudad del trabajador (`cities.timezone`, `America/La_Paz` en Santa Cruz). Se guarda también en el periodo.
  - Helpers propios con `Intl` (`zoned-time.ts`): pasan de UTC a hora de pared y de vuelta, calculando el offset real en cada instante. Sin dependencias.
  - Un test usa una zona con horario de verano: esa semana dura 167 h.
- **Periodo:** `[lunes 00:00, lunes siguiente 00:00)` en hora local, semiabierto.
  - El domingo 23:59:59.999 pertenece a la semana que termina; el lunes 00:00:00, a la siguiente.
  - Un trabajo va al periodo del momento en que pasó a terminado (`completed_at`).
- **Vencimiento:** `due_at = fin + BILLING_DUE_AFTER_DAYS` (3) a las 00:00 locales, exclusivo. Es decir, "miércoles 23:59". Configurable, en propuesta.
- **Recordatorios (R7.6, interpretación aprobada):** la víspera (martes) y el día del vencimiento (miércoles), a las `BILLING_REMINDER_HOUR` (09:00) locales. Con el vencimiento a medianoche, "24 h antes" caería de madrugada.
- **Periodos perezosos:** un periodo se crea con la primera comisión (o el primer pago anticipado) de esa semana. Una semana sin trabajos no tiene periodo, así que no hay cobro ni aviso.
- **Referencia:** `SISI-<AASS>-<código>`, por ejemplo `SISI-2643-K7M2QX`.
  - `AA` y `SS` son el año y la semana ISO de la fecha local de inicio.
  - `<código>` es `worker_profiles.billing_code`: 6 caracteres de un alfabeto sin 0/O/1/I/L, al azar, único y estable.
  - Es única por trabajador y semana (`UNIQUE`), corta, en mayúsculas y fácil de dictar o escribir.
  - Se genera al crear el periodo, no al cerrarlo, para que el trabajador la tenga si paga antes del corte.

## Consecuencias
- Cambiar el día de corte o el plazo es configuración, no código.
- Cambiar la duración del periodo (por ejemplo a quincenal) sí requiere cambiar `periodWindow`.
- La referencia identifica la semana y al trabajador. La aplicación del pago no depende de ella (ADR-0037): un pago con una referencia vieja igual se aplica a lo más antiguo.

## Actualización (Fase 6)
`BILLING_DUE_AFTER_DAYS` y `BILLING_REMINDER_HOUR` se pueden cambiar desde el panel (ADR-0043). El plazo solo afecta a los periodos que se crean desde el cambio: `due_at` se fija al crear el periodo. El día de corte (lunes 00:00 local) no es parámetro.
