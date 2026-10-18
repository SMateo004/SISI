# Dependencias: auditoría y plan (Fase 7)

Revisión del 2026-10-18 (ADR-0047). CI la repite en cada cambio y cada lunes:
- `security.yml` corre gitleaks sobre todo el historial y `npm audit` de producción, con las excepciones documentadas en `audit-excepciones.json`.
- `deploy-web` revisa que el build web no lleve secretos (`tools/scan-web-build.mjs`).

## Backend (npm)

| Paquete | Severidad | Dónde | Riesgo real | Plan |
| --- | --- | --- | --- | --- |
| ~~`prisma` 7.10.0 (vía `@prisma/config` → `deepmerge-ts`, y `mysql2`)~~ | Alta (4 avisos) | CLI de Prisma | — | **Resuelto el 2026-10-18:** `prisma`, `@prisma/client` y `@prisma/adapter-pg` 7.10.1, con los scripts de instalación aprobados en `allowScripts` (`prisma@7.10.1` preinstall, `@prisma/engines@7.10.1` postinstall). `npm audit` de producción: 0 vulnerabilidades; sin excepciones. |
| `jest`, `ts-jest`, `babel-*`, `js-yaml`, `sprintf-js` | Moderada | Solo desarrollo (tests) | Ninguno en producción: no se instalan en el build de Render (`--omit=dev` no aplica al build, pero no se ejecutan en runtime). | Se actualizan cuando salga la versión de Jest que los resuelva. |

`@sentry/node` 11.4.0 es la única dependencia nueva de la Fase 7. Tiene 24 paquetes y ninguno con scripts de instalación.

## Apps (pub)

No hay avisos de seguridad de pub para las versiones en uso (`flutter pub get` no reporta ninguno).

| Paquete | Actual | Última | Plan |
| --- | --- | --- | --- |
| `go_router` | 18.1.0 | 18.1.0 | Actualizado en esta fase (menor, compatible) |
| `firebase_core` / `firebase_messaging` | 4.15.0 / 16.7.0 | 5.0.0 / 17.0.0 | Mayor: probar con la prueba de campo (push con la app cerrada) en una rama aparte |
| `sentry_flutter` | 9.30.1 | 10.1.0 | La 10 salió hace menos de dos semanas: queda en 9.30.1 (estable). Revisar en noviembre |
| `google_maps_flutter` | 2.18.1 | 2.19.0 | La 2.19 pide un Flutter más nuevo que 3.44.9 (ADR-0021). Va con la próxima subida de Flutter |
| `cupertino_icons` | 1.0.9 | 2.0.0 | Sin uso real en Android. Va con la subida de Flutter |
| `intl` | 0.20.2 | 0.20.3 | Fijado por el SDK de Flutter |

## Secretos

- **Historial de git:** gitleaks revisó los 151 commits y todas las ramas. Hubo 7 coincidencias, todas valores de prueba: tokens de dispositivo falsos en los e2e, claves de Bird inventadas en los tests unitarios y el `JWT_SECRET` de desarrollo de `.env.example`. Están en `.gitleaksignore` con su huella.
- **Builds web:** los de app-web y admin no contienen secretos de servidor.
  - Las llaves de Maps y la configuración de Firebase web son públicas por diseño y se restringen por dominio (ADR-0021).
- **Logs y Sentry:** ver ADR-0047 (redact) y ADR-0048.
