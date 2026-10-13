# SISI — Herramientas, cuentas y servicios necesarios

> Costos aproximados; verificarlos al momento de contratar.

## Para el plan de negocio (Tiempo 1)
| Herramienta | Para qué |
| --- | --- |
| Este proyecto de Claude | Redactar plan, canvas, proyecciones, encuestas, términos |
| Formularios (Google Forms o similar) | Encuestas a trabajadores y empleadores |
| Hoja de cálculo | Proyección financiera y rangos de precio |
| WhatsApp Business | Piloto manual: repartir solicitudes y cobrar comisión antes de programar |
| Abogado y contador | Constitución de empresa, facturación, términos y privacidad |

Entregables: Business Model Canvas, tabla de categorías con precios de referencia, reglas de comisión y cobro cerradas, política de servicios prohibidos, términos de uso y privacidad, proyección (trabajos/día × ticket promedio × 13 %), resultados de entrevistas.

## Para el desarrollo (Tiempo 2)

### En tu computadora
- Git y cuenta de **GitHub** (repositorio privado del monorepo).
- **Claude Code** (CLI o app de escritorio) con plan que lo incluya.
- **Node.js LTS** y npm.
- **Flutter SDK** (canal estable) + Android Studio (emulador y SDK Android).
- **Xcode** en una Mac, solo para compilar y publicar iOS.
- **Docker Desktop** (Postgres+PostGIS y Redis locales).
- Editor: VS Code con extensiones de Flutter/Dart y ESLint.

### Cuentas y servicios en la nube
| Servicio | Uso |
| --- | --- |
| Render | Backend: api, worker, cron, Postgres, Key Value |
| Vercel | App web y panel admin |
| GitHub Actions | CI, build de Flutter web y despliegue |
| Firebase | Notificaciones push (FCM); opcional Crashlytics |
| Google Cloud (Maps) o Mapbox | Mapas, distancias, geocodificación |
| Cloudflare R2 o AWS S3 | Carnets, selfies, fotos, comprobantes |
| Proveedor de SMS/WhatsApp OTP (ej. Twilio u otro local) | Código de verificación por teléfono |
| Sentry | Errores de app y backend |
| Dominio propio | api., app., admin. |
| Google Play Console | Publicar Android (pago único aprox. 25 USD) |
| Apple Developer Program | Publicar iOS (aprox. 99 USD por año) |

### Integraciones útiles con Claude Code
- **Render MCP / skills de Render** para crear servicios, base de datos y `render.yaml` desde Claude Code (https://render.com/agents/claude).
- **Vercel CLI** para desplegar desde GitHub Actions.
- Conexión de GitHub para que Claude Code abra PRs.

## Ventanas de trabajo sugeridas en este proyecto
1. **Ventana "Plan de negocio":** pedir prompts y redacción de canvas, encuestas, proyección, precios, términos. Base: 00 y 01.
2. **Ventana "Claude Code":** pedir prompts por fase (0 a 7) para pegar en Claude Code. Base: 00, 01, 02 y 03.
