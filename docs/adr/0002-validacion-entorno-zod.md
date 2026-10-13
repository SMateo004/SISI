# ADR-0002: Validación de variables de entorno con zod

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
El doc 02 permite class-validator o zod. Las variables de §11 deben validarse al arrancar.

## Decisión
`backend/src/config/env.schema.ts` define un esquema zod usado por `ConfigModule.forRoot({ validate })`.
- Obligatorias desde Fase 0: `DATABASE_URL`, `REDIS_URL`, `JWT_SECRET`, `JWT_REFRESH_SECRET` (mín. 32 caracteres).
- Opcionales hasta su fase: `OTP_PROVIDER_KEY`, `FIREBASE_SERVICE_ACCOUNT`, `STORAGE_*`, `MAPS_API_KEY`, `SENTRY_DSN`. Cada fase que las use las vuelve obligatorias.
- `TZ_DEFAULT` por defecto `America/La_Paz`; `CORS_ORIGINS` lista separada por comas.

## Consecuencias
Tipos inferidos (`Env`) sin duplicar clases. class-validator se sigue usando para DTOs HTTP.
