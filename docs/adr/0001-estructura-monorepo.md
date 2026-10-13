# ADR-0001: Estructura del monorepo

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
El doc 02 §3 define la estructura `sisi/` con `apps/`, `backend/`, `packages/`, `infra/`, `.github/` y `docs/`.

## Decisión
- La raíz del repositorio **es** `sisi/` (no hay subcarpeta extra).
- Las carpetas de módulos del backend (`auth/`, `users/`, …) y de features de Flutter (`auth/`, `requests/`, …) se crean **en la fase que las implementa**, no vacías en la Fase 0. Así no hay carpetas fantasma ni módulos sin tests.
- Ramas: `develop` → staging, `main` → producción.

## Consecuencias
La estructura final coincide con el doc 02 al completar las fases. Quien lea el repo en Fase 0 solo ve lo que existe y funciona.
