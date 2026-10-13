# ADR-0006: Flutter web compilado en GitHub Actions y publicado en Vercel

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
Vercel no trae Flutter en su build. El doc 02 pide compilar en Actions con versión fija y usar `vercel deploy --prebuilt`.

## Decisión
- `deploy-web.yml` compila con Flutter fijo (3.44.9) y `--dart-define` desde GitHub Environments (`staging`, `production`).
- `vercel pull` + `vercel build` (sin build command; `outputDirectory: build/web`, rewrites de `vercel.json`) + `vercel deploy --prebuilt`.
- `develop` → deployment *preview* (staging); `main` → `--prod`.
- Dos proyectos Vercel: `app-web` (apps/mobile) y `admin` (apps/admin).

## Consecuencias
Los builds de Vercel desde Git deben desactivarse (o el proyecto no conectarse a Git) para no compilar dos veces.
