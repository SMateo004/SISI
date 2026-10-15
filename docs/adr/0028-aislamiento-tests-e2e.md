# ADR-0028: Aislamiento de los tests e2e

- Estado: aceptada
- Fecha: 2026-10-15
- Fase: 3

## Contexto
En la Fase 2 la suite e2e falló de forma intermitente. Las causas eran de estado compartido:
- `uniquePhone()` usaba `Date.now() % 1 000 000` y un contador que vuelve a 0 en cada archivo (Jest da a cada archivo su propio registro de módulos), así que los números se repetían cada ~16,7 min y entre archivos;
- la base `sisi_test` nunca se vaciaba: tenía 754 usuarios acumulados (125 admins y 31 en modo worker), de modo que un número repetido entraba como una cuenta vieja (403, 429 por cooldown o `isNewUser: false`);
- nada impedía dos corridas a la vez (una hacía `FLUSHDB` en medio de la otra);
- los `beforeAll` que levantan la API completa tenían el timeout por defecto de Jest (5 s), que se excede con Docker recién iniciado.

La Fase 3 suma temporizadores, colas y sockets, que agravan cualquier estado compartido.

## Decisión
- **Limpieza garantizada en `global-setup`:**
  - `TRUNCATE … RESTART IDENTITY CASCADE` de todas las tablas de la app (no `_prisma_migrations` ni `spatial_ref_sys`) y luego el seed;
  - `FLUSHDB` del Redis de pruebas (db 1);
  - vaciado del bucket `sisi-test`.
- **Candado:** `pg_try_advisory_lock` en una conexión dedicada que se mantiene abierta toda la corrida y que libera `global-teardown` (o Postgres, si el proceso muere). Una segunda corrida simultánea falla al inicio con un mensaje claro.
- **Identificadores sin reloj ni azar** (`test/utils/unique.ts`): cada archivo recibe un bloque fijo según su posición entre los `*.e2e-spec.ts` ordenados.
  - Teléfono `7` + 2 dígitos de archivo + 5 de contador.
  - IP `10.<archivo>.x.y`.
  - Sufijos de solo letras sin repeticiones seguidas, para que la normalización de moderación no los altere.
- **`testTimeout` de 30 s** en la configuración e2e.
- Los tiempos de matching, outbox y ubicación son configurables; los e2e usan milisegundos.
- **`npm run test:e2e:repeat -- N`:** corre la suite N veces, guarda cada salida en `backend/.e2e-runs/` y resume las fallas. El criterio de terminado de cada fase es 20 de 20.

Se descartó una base, un Redis y un bucket por worker de Jest: la suite corre con `--runInBand`, y la limpieza con candado da el mismo aislamiento con menos infraestructura.

## Consecuencias
- Cada corrida empieza desde cero: nada depende del orden ni de corridas anteriores.
- No se pueden correr dos suites e2e a la vez contra la misma infraestructura local (en CI cada job tiene sus propios servicios).
- Si algún día se paraleliza con varios workers de Jest, habrá que pasar a una base por worker (`CREATE DATABASE … TEMPLATE`) y prefijos de Redis.
