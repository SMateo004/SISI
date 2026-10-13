# ADR-0003: Prisma con PostGIS habilitado en la migración inicial

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
El doc 02 pide Prisma + SQL directo para lo geográfico y `CREATE EXTENSION IF NOT EXISTS postgis;` en una migración.

## Decisión
- La migración `init` contiene a mano `CREATE EXTENSION IF NOT EXISTS postgis;` antes de crear tablas. No se usa la preview feature `postgresqlExtensions` de Prisma.
- Columnas geográficas (fases siguientes) se declaran como `Unsupported("geography(Point,4326)")` y se consultan con `$queryRaw`.
- Nombres en BD en `snake_case` (`@map`/`@@map`), modelos Prisma en `PascalCase`.
- Ids `uuid` generados por la BD (`gen_random_uuid()`).

## Consecuencias
`prisma migrate dev` puede detectar la extensión como drift si alguien la quita; no hay que quitarla.
