# ADR-0030: Comisión y redondeo

- Estado: aceptada
- Fecha: 2026-10-16
- Fase: 4

## Contexto
R6.3 dice que, al terminar, `comisión = precio final × porcentaje de la categoría`, registrada en el ledger del periodo. Con montos en Bs y 2 decimales, hace falta una regla de redondeo única. La Fase 5 (ledger y cobro) tiene que recibir el mismo número que ve el trabajador en su historial.

## Decisión
- `commission_bs = final_price_bs × commission_pct / 100`, redondeada a **2 decimales con HALF_UP** (0,005 sube).
  - El cálculo es todo en Decimal (`Prisma.Decimal`), nunca con `number`.
  - Función pura `commissionOf` en `src/jobs/commission.ts`.
- **Porcentaje:** `jobs.commission_pct` es la copia que se tomó al asignar con `CategoryResolver` (ADR-0016). Un cambio posterior de la categoría no afecta trabajos ya asignados.
- **Neto del trabajador** (R8.3): `precio final − comisión`. Solo lo ve el trabajador, en el historial y en el detalle.
- **Cuándo:** en la misma transacción que pasa el trabajo a `terminado` (confirmación, autoconfirmación o resolución de una disputa). Se guarda en `jobs.commission_bs`.
- **Entrega a la Fase 5:** evento de outbox `job.completed`, con montos como texto con 2 decimales: `jobId`, `workerId`, `cityId`, `finalPriceBs`, `commissionPct`, `commissionBs` y `completedAt`. En esta fase no hay ledger: la Fase 5 lo consume e inserta en `ledger_entries` (append-only).
- **Ejemplos** (tests unitarios):

  | Precio | % | Exacto | Comisión |
  | --- | --- | --- | --- |
  | 150,00 | 13 | 19,50 | 19,50 (neto 130,50) |
  | 99,99 | 13 | 12,9987 | 13,00 |
  | 10,05 | 13 | 1,3065 | 1,31 |
  | 0,50 | 13 | 0,065 | 0,07 |
  | 123,45 | 12,5 | 15,43125 | 15,43 |

## Consecuencias
- Un solo redondeo, en un solo lugar: el ledger y el historial siempre coinciden.
- HALF_UP favorece a la plataforma en el medio centavo exacto; es la regla más fácil de explicar. Si contabilidad pide redondeo bancario (HALF_EVEN), se cambia en `commissionOf` y en este ADR.
