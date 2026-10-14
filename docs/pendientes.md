# Decisiones pendientes

> Revisar al inicio de cada fase (ver CLAUDE.md). Cuando una se resuelva: marcarla, anotar fecha y dónde quedó registrada (doc 01, ADR, etc.).

## Negocio (sección 10 del doc 00)
- [ ] Nombre comercial y marca. (El texto del SMS dice "SISI" de forma provisional.)
- [ ] Día de corte, plazo de pago y tope de deuda definitivos (hoy: domingo 23:59, miércoles 23:59, 150 Bs — en propuesta).
- [ ] Zonas exactas del lanzamiento.
- [ ] Categorías iniciales finales y rangos de precio de referencia (en Bs). Desde la Fase 2 el seed carga 6 categorías con rangos **provisionales** (ver la Fase 2).
- [ ] Si habrá suscripción como alternativa a la comisión.
- [ ] Revisión legal y tributaria (empresa, facturación de la comisión, relación con trabajadores independientes, datos personales: conservación y borrado de fotos de carnet y selfies).

## Propuestas aprobadas para el MVP (Fase 1) — pasar a `01-reglas-de-negocio.md`
Aprobadas el 2026-10-14. Hay que reflejarlas en el documento 01 en la sección indicada.

| Regla | Detalle | Sección del doc 01 a actualizar |
| --- | --- | --- |
| Nivel del trabajador | `worker_profiles.level` existe con valor 1 y no tiene lógica en el MVP. Niveles con comisión menor: etapa 2 (doc 00 §6). | R1 (nueva R1.7) y R8 |
| Suspensión confirmada | No hay estados nuevos (R1.4 es cerrado). Si la revisión confirma la falta, el perfil queda en `suspendido_moderacion` con la resolución registrada; si no, vuelve a `aprobado`. | R9.3 |
| Suspensión y deuda | La suspensión tiene prioridad sobre la deuda (`bloqueado_deuda → suspendido_moderacion`). Al levantar una suspensión con deuda vencida el perfil pasa a `bloqueado_deuda`, no a `aprobado`. | R9.3 y R7.7 |
| Bloqueo y modo | Si pasa a `bloqueado_deuda` o `suspendido_moderacion` estando en modo trabajador, la cuenta cambia sola a `employer` y se le notifica. Al desbloquearse no vuelve sola: usa el interruptor. | R1.6 |
| Teléfonos | MVP: solo +591. Prefijos permitidos en configuración (`PHONE_ALLOWED_COUNTRY_CODES`). | R1.1 |

## Propuestas de la Fase 2 por validar
Implementadas como propuesta; cambiarlas es dato (admin o seed) o configuración.

- [ ] **Rangos de precio de referencia provisionales** (`prisma/seed-data/categories.ts`, Santa Cruz, comisión 13 %): plomería 80–300, electricidad 80–300, limpieza 120–350, cuidado del hogar 80–400, eventos 100–300, mudanzas y carga 150–600 Bs. Pendientes de validación en el plan de negocio. El seed no sobrescribe: si cambian después de sembrar, se ajustan con `PATCH /admin/categories/:id` o `PUT /admin/categories/:id/cities/:cityId`.
- [ ] **Términos de moderación para revisar** (`prisma/seed-data/moderation-terms.ts`, 71 términos: servicios sexuales, drogas, armas, ilegal, inmoral, venta de productos). Revisar falsos positivos y huecos con alguien de Bolivia (jerga local). Usos legítimos ya cuidados: "hoja de coca", "acompañante de adulto mayor" (ADR-0018).
- [ ] **Zona de Santa Cruz:** centro en la Plaza 24 de Septiembre (−17.7834, −63.1821) y radio **provisional de 15 km**; sin polígono. Definir el área real de lanzamiento (radio o polígono; relacionado con "Zonas exactas del lanzamiento").
- [ ] **Proveedor de mapas: Google** (Maps SDK en la app, Geocoding API en el backend) como propuesta. Confirmar contra Mapbox por costo y cobertura de direcciones en Santa Cruz. Llaves: ver README ("Llaves de Google Maps").
- [ ] **Largo de la descripción:** 20 a 1000 caracteres (`REQUEST_DESCRIPTION_MIN/MAX`).
- [ ] **Fotos por solicitud:** hasta 4, opcionales (`REQUEST_MAX_PHOTOS`); mismas reglas de archivo que la Fase 1.
- [ ] **Límites de publicación:** 10 por hora y 30 por día por usuario; 30 borradores por hora por IP; 60 geocodificaciones por minuto por IP (`RATE_REQUEST_*`, `RATE_GEOCODE_IP_PER_MIN`).
- [ ] **Caché de geocodificación:** 7 días, coordenadas redondeadas a 4 decimales (~11 m). Revisar contra los términos de uso del proveedor elegido (Google limita el almacenamiento de resultados).
- [ ] **Precio bajo el mínimo:** se advierte y se deja publicar (R3.2). Confirmar que no haya un piso duro.

## Detectadas en la Fase 2
- [ ] **Borradores abandonados:** las solicitudes en `borrador` y sus fotos quedan para siempre. Definir cuánto viven y agregar un job de limpieza (BullMQ) que borre fotos del bucket.
- [ ] **Eventos no durables** (ADR-0020): si la instancia cae justo después de publicar, el oyente de `request.searching` no corre. La Fase 3 debe recuperar las solicitudes en `buscando` sin procesar.
- [ ] **Aviso al empleador cuando el admin libera o rechaza** una solicitud retenida: hoy solo cambia el estado (se ve en "Mis solicitudes"). Push en la Fase 4.
- [ ] **Panel admin de moderación:** liberar/rechazar y editar términos hoy es solo por API (`/admin/...`). Pantallas en la Fase 6.
- [ ] **Edición de la solicitud** después de publicar: no existe (solo cancelar). Confirmar que es la regla deseada.
- [ ] **Expiración de solicitudes** (`buscando`/`con_ofertas` → `expirada`): el estado existe pero ningún proceso lo aplica todavía; plazo por definir (Fase 3).

## Propuestas de la Fase 1 por validar
Valores implementados como propuesta; cambiarlos es configuración o un ajuste menor.

- [ ] **Proveedor de OTP: Bird.com** (SMS, categoría `authentication`, ADR-0011). Confirmar: remitente en Bolivia (sender ID alfanumérico "SISI" o número propio; Bird exige habilitar Bolivia en *SMS > Destinations*), costo por SMS y cuándo agregar WhatsApp (plantilla aprobada).
- [ ] **OTP:** 6 dígitos, válido 5 minutos, 5 intentos por código (`OTP_TTL_SEC`, `OTP_MAX_ATTEMPTS`).
- [ ] **Tiempos de los tokens:** acceso 15 minutos y refresh 30 días con rotación (`JWT_ACCESS_TTL_SEC`, `JWT_REFRESH_TTL_SEC`).
- [ ] **Rate limits:** por teléfono 1 código cada 60 s, 5 por hora y 10 por día; por IP 20 pedidos de código por hora, 30 verificaciones cada 15 min, 30 refresh/logout por minuto y 300 peticiones por minuto en general (`RATE_*`, ADR-0010).
- [ ] **Medio de transporte:** a pie, bicicleta, moto, auto, transporte público (R1.3).
- [ ] **Radio máximo:** entero de 1 a 10 km, alineado con el anillo máximo de R4.2 (R1.3).
- [ ] **Archivos:** fotos JPEG, PNG o HEIC hasta 8 MB; la app las comprime (lado mayor 1600 px, calidad 80) antes de subir. URLs de subida de 5 min, enlaces de documentos para admin de 5 min, foto de perfil firmada 1 h (`UPLOAD_*`, `*_URL_TTL_SEC`, ADR-0012).
- [ ] **Documentos aceptados para el upgrade:** CI anverso, CI reverso y selfie. `cert` queda para requisitos extra por categoría (Fase 2).

## Detectadas en la Fase 1
- [ ] **OTP por consola en staging** (ADR-0011): el código sale en los logs de Render. Aceptado **solo mientras staging no se publique a usuarios reales** (ver `docs/runbook.md`). Antes de abrir staging a terceros: configurar Bird en staging (`OTP_PROVIDER=bird`).
- [ ] **Primer administrador en producción:** hoy el rol se asigna con `dev-tools make-admin`, que no corre en production. Definir el procedimiento (SQL controlado o comando con aprobación) antes de la Fase 6.
- [ ] **Avisos al trabajador** (`WorkerNotifier`): hoy solo dejan constancia en el log. Conectar a push (FCM) y Socket.IO (`account:blocked`, `account:unblocked`) en la Fase 4.
- [ ] **Deuda vencida** (`DebtStatusProvider`): hoy siempre "sin deuda". Implementarlo con billing en la Fase 5 (lo usa la regla de levantar suspensión).
- [ ] **Bloqueo permanente** por moderación: no existe en R1.4. Definir si se agrega un estado o se maneja como suspensión indefinida.
- [ ] **Tokens en la versión web** (ADR-0014): evaluar pasar el refresh a una cookie `httpOnly` (vía API) antes de abrir la web a usuarios reales; CSP estricta en Vercel.
- [ ] **Adopción del cliente Dart generado** (`packages/api_contract/dart`, ADR-0015) en `apps/mobile` y `apps/admin`.
- [ ] **CORS del bucket R2:** agregar los dominios definitivos de la app web cuando existan (hoy solo se configuran los de staging).
- [ ] **Conservación de fotos de identidad:** cuánto tiempo se guardan y cuándo se borran (relacionado con la revisión legal de datos personales).

## Detectadas en la Fase 0
- [ ] **ID de la app / bundle id** (Android `applicationId`, iOS bundle). Provisional: `bo.sisi.mobile` y `bo.sisi.admin`. Depende de la marca; cambiarlo antes de publicar en tiendas (no se puede cambiar después).
- [ ] **Dominio final** para `api.`, `app.` y `admin.` (afecta `CORS_ORIGINS`, `API_URL`, Vercel, Render y el CORS del bucket R2).
- [x] ~~**Proveedor de OTP**~~ — Bird.com, 2026-10-14 (ADR-0011). Detalles por validar arriba.
- [ ] **Mapas:** Google Maps o Mapbox. Fase 2: implementado con **Google como propuesta** detrás de interfaces cambiables (ADR-0021). Ver la Fase 2.
- [x] ~~**Almacenamiento**~~ — Cloudflare R2 en producción, RustFS en local, 2026-10-14 (ADR-0012).
- [ ] **Render:** región (propuesta `virginia`, la más cercana a Bolivia) y planes de staging (production debe usar planes pagos según doc 02 §8; staging puede ir en planes bajos).
- [x] ~~**Ciudades: área de cobertura**~~ — Fase 2, 2026-10-14: `center` + `service_radius_km` y `service_area` (polígono) opcional (ADR-0019). Valores de Santa Cruz por validar en la Fase 2.
- [ ] **Hora de Bolivia:** el cron usa UTC−4 fijo ("59 3 * * 1"). Bolivia no aplica horario de verano hoy; si cambiara, ajustar.
- [ ] **Firma de apps:** keystore Android (upload key) y certificados iOS; cuentas de Google Play y Apple Developer.
- [ ] **Código Flutter compartido:** hoy `core/` está duplicado en mobile y admin. Evaluar un paquete Dart en `packages/` cuando crezca (ver ADR-0005).
- [x] ~~**Cliente Dart desde OpenAPI**~~ — openapi-generator `dart-dio` vía Docker, 2026-10-14 (ADR-0015). Adopción en las apps: pendiente arriba.
- [ ] **Sentry:** confirmar cuenta y si se activa desde Fase 1.
- [ ] **URL fija de staging en Vercel:** los deployments preview cambian de URL en cada deploy, y `CORS_ORIGINS` de `api-staging` necesita orígenes fijos. Opciones: dominio de staging (ej. `staging-app.` y `staging-admin.`) asignado con `vercel alias` en `deploy-web.yml`, o un Custom Environment de Vercel. Decidir junto con el dominio.
- [ ] **Protección de previews en Vercel:** por defecto las previews piden login de Vercel; decidir si staging queda privado o público para pruebas con usuarios.
