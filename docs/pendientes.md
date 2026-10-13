# Decisiones pendientes

> Revisar al inicio de cada fase (ver CLAUDE.md). Cuando una se resuelva: marcarla, anotar fecha y dónde quedó registrada (doc 01, ADR, etc.).

## Negocio (sección 10 del doc 00)
- [ ] Nombre comercial y marca.
- [ ] Día de corte, plazo de pago y tope de deuda definitivos (hoy: domingo 23:59, miércoles 23:59, 150 Bs — en propuesta).
- [ ] Zonas exactas del lanzamiento.
- [ ] Categorías iniciales finales y rangos de precio de referencia (en Bs).
- [ ] Si habrá suscripción como alternativa a la comisión.
- [ ] Revisión legal y tributaria (empresa, facturación de la comisión, relación con trabajadores independientes, datos personales).

## Detectadas en la Fase 0
- [ ] **ID de la app / bundle id** (Android `applicationId`, iOS bundle). Provisional: `bo.sisi.mobile` y `bo.sisi.admin`. Depende de la marca; cambiarlo antes de publicar en tiendas (no se puede cambiar después).
- [ ] **Dominio final** para `api.`, `app.` y `admin.` (afecta `CORS_ORIGINS`, `API_URL`, Vercel y Render).
- [ ] **Proveedor de OTP** (Twilio, WhatsApp Business API u otro local) — necesario en Fase 1.
- [ ] **Mapas:** Google Maps o Mapbox — necesario en Fase 2.
- [ ] **Almacenamiento:** Cloudflare R2 o AWS S3 — necesario en Fase 1 (documentos del trabajador).
- [ ] **Render:** región (propuesta `virginia`, la más cercana a Bolivia) y planes de staging (production debe usar planes pagos según doc 02 §8; staging puede ir en planes bajos).
- [ ] **Ciudades:** ¿`cities` necesita polígono/área de cobertura (PostGIS) para validar que una solicitud cae dentro de la ciudad? Hoy solo tiene nombre, país, zona horaria y activa.
- [ ] **Hora de Bolivia:** el cron usa UTC−4 fijo ("59 3 * * 1"). Bolivia no aplica horario de verano hoy; si cambiara, ajustar.
- [ ] **Firma de apps:** keystore Android (upload key) y certificados iOS; cuentas de Google Play y Apple Developer.
- [ ] **Código Flutter compartido:** hoy `core/` está duplicado en mobile y admin. Evaluar un paquete Dart en `packages/` cuando crezca (ver ADR-0005).
- [ ] **Cliente Dart desde OpenAPI:** elegir generador (`openapi-generator` dart-dio u otro) para `packages/api_contract`.
- [ ] **Sentry:** confirmar cuenta y si se activa desde Fase 1.
- [ ] **URL fija de staging en Vercel:** los deployments preview cambian de URL en cada deploy, y `CORS_ORIGINS` de `api-staging` necesita orígenes fijos. Opciones: dominio de staging (ej. `staging-app.` y `staging-admin.`) asignado con `vercel alias` en `deploy-web.yml`, o un Custom Environment de Vercel. Decidir junto con el dominio.
- [ ] **Protección de previews en Vercel:** por defecto las previews piden login de Vercel; decidir si staging queda privado o público para pruebas con usuarios.
