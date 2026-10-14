# ADR-0016: Categorías por ciudad y resolvedor de categoría efectiva

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 2

## Contexto
R2.2 y R10.1 piden categorías administrables por ciudad, con rango de precio de referencia y comisión que pueden variar según la ciudad. La Fase 1 validaba categorías directamente contra `categories`, sin noción de ciudad. Más adelante (precio de referencia, comisión en billing) varios módulos necesitan "la categoría tal como aplica en esta ciudad".

## Decisión
- `categories` gana `slug` único (la app elige el ícono por slug; las filas viejas reciben `cat-<id8>`).
- Tabla `category_cities` (PK `category_id, city_id`) con `active` y overrides opcionales `price_min_bs`, `price_max_bs`, `commission_pct`; `null` = usa el valor base de `categories`. CHECKs: precios > 0, mín ≤ máx, comisión 0–100.
- Una categoría está activa en una ciudad solo si `categories.active` y existe la fila de `category_cities` con `active`.
- `CategoryResolver` (`forCity`, `listActive`, `requireActive`, `requireAllActive`) es el único punto que calcula la categoría efectiva (`effective-category.ts`, función pura con tests). Todo lo que use precio o comisión pasa por él. El upgrade de trabajador (Fase 1) valida con `requireAllActive(ids, cityId)`.
- API: `GET /categories` (activas en la ciudad del usuario) y admin `GET /admin/categories`, `PATCH /admin/categories/:id`, `PUT /admin/categories/:id/cities/:cityId`.
- Seed idempotente (`prisma/seed-data/categories.ts`): 6 categorías del doc 00 en Santa Cruz, comisión 13 %, **rangos provisionales**. Solo crea lo que falta; nunca sobrescribe cambios del admin.

## Consecuencias
Abrir una ciudad nueva es insertar filas en `category_cities`, sin código. Los rangos del seed deben validarse en el plan de negocio (docs/pendientes.md). La comisión efectiva queda lista para billing (Fase 5).
