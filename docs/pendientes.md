# Decisiones pendientes

> Revisar al inicio de cada fase (ver CLAUDE.md). Cuando una se resuelva: marcarla, anotar fecha y dónde quedó registrada (doc 01, ADR, etc.).

## Negocio (sección 10 del doc 00)
- [ ] Nombre comercial y marca. (El texto del SMS dice "SISI" de forma provisional.)
- [ ] Día de corte, plazo de pago y tope de deuda definitivos (hoy: domingo 23:59, miércoles 23:59, 150 Bs — en propuesta; configurables con `BILLING_DUE_AFTER_DAYS` y `BILLING_DEBT_CAP_BS`, ver la Fase 5).
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

## Lanzamiento del piloto: bloqueantes que dependen de ti (Fase 7)
- [ ] **Nombre comercial** e identificadores finales.
  - Hoy son provisionales: Android `bo.sisi.sisi_mobile`, iOS `bo.sisi.sisiMobile`.
  - No se pueden cambiar después de publicar. Se fijan con `ANDROID_APP_ID` y `APP_NAME` en el Environment `production` (ADR-0054).
  - Con el nombre: ícono, splash y prefijo de la referencia de pago (`SISI-…`).
- [ ] **Dominio propio:** sin él, producción usa `.onrender.com` y `.vercel.app` (ADR-0039).
- [ ] **Rangos de precio confirmados:** hoy son los provisionales de la Fase 2.
- [ ] **Términos de moderación revisados** con alguien de Santa Cruz.
- [ ] **Textos legales v0 del piloto cerrado: esperan tu revisión** (aprobado el 2026-10-18 prepararlos).
  - Están en `backend/legal/` con `stage: piloto-cerrado` y dicen que es un piloto cerrado con usuarios invitados.
  - Tienen `[COMPLETAR: …]` (razón social, NIT, domicilio, transferencia internacional, plazos y derechos): complétalos o déjalos como texto.
  - **Para aprobarlos:** borra la primera línea ("VERSIÓN v0 PARA TU REVISIÓN — PENDIENTE DE REVISIÓN LEGAL"). Hasta entonces `check-legal` falla y producción no arranca (runbook, "Textos v0 del piloto").
  - Mientras sean los vigentes, producción exige `pilot.closed` encendido: el seed lo enciende, la API no arranca sin él y el panel no deja apagarlo (ADR-0051).
- [ ] **Textos legales definitivos** (revisión de un abogado): términos, privacidad y eliminación de datos, como versión 2 sin `stage`. Recién con ellos se puede abrir el piloto.
- [ ] **QR real de la empresa:** Panel → Cobros → QR.
- [ ] **Cuentas de producción:**
  - Bird, con el remitente habilitado en Bolivia;
  - Firebase;
  - Google Maps, con llaves restringidas y presupuesto;
  - Cloudflare R2, con un bucket privado;
  - Sentry;
  - workspace pago de Render;
  - Google Play Console;
  - GitHub Environments `production` y `production-approval` (runbook, "Producción").
- [ ] **WhatsApp Business de soporte:** Panel → Parámetros.
- [x] **Canal de alertas: email** (aprobado el 2026-10-18). Configurar la dirección del equipo en Sentry, Render y el monitor externo (runbook, "Alertas").
- [ ] **Polígono de la zona del piloto:** Panel → Catálogo → Ciudades → Zona.
- [ ] **Staging:** sigue bloqueado por los pasos manuales de la Fase 6. Lo necesitan la prueba de carga, el simulacro de alertas y la validación de la CSP.

## Decisiones del Paso 0 de la Fase 7
Aprobadas el 2026-10-18 y aplicadas como valores por defecto (el panel puede cambiarlas). El resto del Paso 0 queda con los valores actuales hasta nuevo aviso:
- [x] **Anillos:** `2:5,5:15,10:15` (anillos 2 y 3 con 15 trabajadores; el 1 lo fija R4.2).
- [x] **Búsqueda mínima:** 5 min.
- [x] **Códigos OTP por IP:** 60 por hora, por el CGNAT (`RATE_OTP_IP_PER_HOUR`).
- [x] **Nombre obligatorio para trabajar:** R1.3 ampliada en el doc 01.
- [ ] **Plazo operativo de una disputa:** 48 h (solo runbook, sin código). Sigue en propuesta.
- [x] **URLs firmadas de 15 min en producción:** `render.yaml` (ADR-0047). La foto de perfil y las de las solicitudes pasan de 1 h a 15 min.

## Propuestas de la Fase 7 por validar
- [ ] **Retención (ADR-0050).** **Sigue apagada** (`RETENTION_ENABLED=false`) hasta que definas los plazos (decisión del 2026-10-18). Los propuestos:

  | Dato | Plazo propuesto |
  | --- | --- |
  | Documentos de rechazados | 90 días |
  | Última ubicación de inactivos | 30 días |
  | Chat | 180 días después del trabajo (salvo reportes pendientes) |
  | Borradores | 7 días |
  | Comprobantes rechazados | 1 año |
  | Comprobantes registrados | 5 años |
  | Avisos leídos | 90 días |
  | Tokens vencidos y claves de idempotencia | 30 días |

  La auditoría y el ledger se conservan sin límite.
- [ ] **Eliminación de cuenta (ADR-0049):** anonimizar y conservar la contabilidad con el id.
  - No se puede con deuda, con un trabajo activo ni con un comprobante en revisión.
  - El número queda libre para una cuenta nueva.
  - Se guarda un HMAC del teléfono para reconocer si vuelve.
  - Validar con la revisión legal (plazo contable y HMAC).
- [ ] **Piloto cerrado (ADR-0052):** las cuentas que ya existen siguen entrando aunque se las quite de la lista; un número fuera de la lista no recibe SMS. Validar si alguien quitado debe perder el acceso.
- [ ] **Alertas (ADR-0048):** confirmar los umbrales `OPS_*`:
  - outbox: 5 min;
  - colas: 5 min o 10 fallidos;
  - OTP: 5 fallos en ~10 min;
  - push: 20 fallos o el 20 %;
  - cron: 2 h.
- [ ] **CSP de las apps web:** sale en `Report-Only`. Validarla en staging (consola del navegador) y encender `CSP_ENFORCE=true`.
- [ ] **Versionado:** el primer piloto es la `0.9.0`; la `1.0.0`, la apertura pública.
- [x] **Prisma 7.10.1:** scripts de instalación aprobados el 2026-10-18 y agregados a `allowScripts`. `npm audit` de producción sin vulnerabilidades y sin excepciones.
- [ ] **AAB y Play Console:** no se genera el AAB ni se crea nada en Play Console hasta confirmar el nombre comercial y el identificador del paquete.
- [ ] **`main` y `v0.9.0`:** recién cuando staging esté validado con la prueba de carga y el simulacro de alertas.
- [x] **Acceso al panel** (decidido el 2026-10-18, ADR-0055): una sola cuenta "admin" con código de app autenticadora, sin teléfono. Reemplaza el "primer admin por SQL". Falta: generar la clave de producción y cargarla en Render (runbook, "Acceso al panel").

## Después del piloto
- [ ] **iOS:** cuenta de Apple Developer; enlazar los entitlements en Xcode; llave APNs en Firebase; `IOS_PUSH=true`; TestFlight (ADR-0054).
- [ ] **Pasarela de pago:** el flag `payments.gateway` existe, pero sin implementación (ADR-0037).
- [ ] **Facturación de la comisión:** según la revisión tributaria. `payments.invoice_number` ya existe.
- [ ] **Ubicación en segundo plano:** permiso, servicio en primer plano y justificación ante las tiendas.
- [ ] **Imágenes en el chat,** con moderación de imágenes.
- [ ] **Roles de admin** (moderador, finanzas): una fila en `PERMISSIONS_BY_ROLE` (ADR-0040).
- [ ] **Suspensión de empleadores** y bloqueo permanente (Fases 4 y 6).
- [ ] **App móvil con el cliente generado** (ADR-0045).
- [ ] **Valores de los parámetros por ciudad** (ADR-0043), cuando haya una segunda ciudad.
- [ ] **Subida de Flutter:** con ella `google_maps_flutter` 2.19, `firebase_*` 5/17 y `sentry_flutter` 10 (`docs/seguridad/dependencias.md`).

## Propuestas de la Fase 6 por validar
- [ ] **Permisos por rol:** hoy `admin` tiene los 8 permisos del panel (`dashboard`, `verificaciones`, `moderacion`, `cobros`, `catalogo`, `configuracion`, `usuarios`, `auditoria`). Definir si habrá roles de moderador o finanzas: agregar un rol es una fila en `PERMISSIONS_BY_ROLE` y su valor en `user_role` (ADR-0040).
- [ ] **Suspensión de empleadores:** "Suspender" en el panel aplica solo al perfil de trabajador. Para un empleador marcado por 3 reportes válidos solo existe quitar la marca. Definir si un empleador puede ser suspendido y qué pierde (ingresar, publicar).
- [ ] **Motivos de rechazo de una verificación:** `documento_ilegible`, `documento_no_coincide`, `selfie_no_coincide`, `menor_de_edad`, `documento_vencido`, `requisitos_de_categoria`, `datos_incompletos`, `otro`; siempre con nota, que ve el trabajador.
- [ ] **Parámetros editables desde el panel** (ADR-0043): matching (anillos, espera, ofertas suficientes, plazo para elegir, búsqueda mínima), contraoferta máxima, autoconfirmación, ventanas de chat y contacto, plazo para calificar, tope de deuda, días para pagar y hora de avisos. Validar los rangos de producción del catálogo. **Por ciudad:** la tabla lo admite, pero hoy todos son globales.
- [ ] **Sesión del panel:** acceso de 10 min y 8 h como máximo desde el login, sin extenderse (ADR-0040). Validar con el equipo si 8 h alcanza para un turno.
- [ ] **CSV para el contador:** separado por comas, punto decimal, UTF-8 con BOM. Confirmar con el contador (en Excel con configuración regional de Bolivia puede esperar punto y coma).
- [ ] **Documentos de identidad en el panel:** se ven sin botón de descarga y con URL de 5 min, pero no se puede impedir una captura de pantalla. Definir la norma interna.
- [ ] **Auditoría:** crece sin límite. Definir retención o archivado (p. ej. por año).
- [x] ~~**Primer admin en producción**~~ — Fase 7: procedimiento propuesto en el runbook ("Producción → Primer admin"); su aprobación sigue en "Propuestas de la Fase 7".
- [ ] **Doc 02 §6:** agregar `admin:counters` (solo para el panel, ADR-0044) a la lista de eventos de tiempo real.

## Detectadas en la Fase 6
- [ ] **Paso 0 de staging bloqueado** por pasos manuales (ver el reporte de la Fase 6 y el runbook): Blueprint de Render y URL de `api-staging`, proyectos de Vercel de staging, variables y secretos del Environment `staging` de GitHub, Firebase y CORS de R2.
- [ ] **IP real del cliente detrás del proxy del panel:** con `trust proxy` en 1, la API ve la IP de Vercel. La auditoría guarda también el `X-Forwarded-For` (informativo). Si hace falta la IP real, confiar en un header firmado por Vercel o en un segundo salto solo para `/api`.
- [ ] **App móvil con el cliente generado:** el panel ya lo usa (ADR-0045). Migrar la app es opcional.
- [ ] **Reloj simulado y periodos cerrados por adelantado:** con `billing-run --at <futuro>` un periodo puede cerrarse antes de terminar. Una comisión real de esa semana cae entonces en un periodo ya pagado (solo en pruebas manuales; en producción el cron cierra después del fin). Para probar cobros, usar trabajadores sin periodos cerrados por el reloj simulado.

## Propuestas de la Fase 5 por validar
- [ ] **Corte, plazo y tope:** semana de cobro `[lunes 00:00, lunes siguiente 00:00)` en la hora local de la ciudad; vence 3 días después del corte, a las 00:00 del jueves ("miércoles 23:59"). Tope de deuda: **150 Bs**, saldo total incluido el periodo abierto (`BILLING_DUE_AFTER_DAYS`, `BILLING_DEBT_CAP_BS`, ADR-0035 y ADR-0038).
- [ ] **El tope no bloquea la cuenta:** superarlo solo deja fuera de las solicitudes nuevas (sigue `aprobado` y termina lo que tiene). El bloqueo (`bloqueado_deuda`) es solo por un corte vencido (R7.7).
- [ ] **Avisos (interpretación de R7.6):** al cerrar el corte, la **víspera (martes) a las 09:00** y el **día del vencimiento (miércoles) a las 09:00**, hora local (`BILLING_REMINDER_HOUR`). Con el vencimiento a medianoche, "24 h antes" caía de madrugada y casi junto con "el día".
- [ ] **Formato de la referencia:** `SISI-<AASS>-<código>` (año y semana ISO del inicio del periodo y un código de 6 caracteres del trabajador, sin 0/O/1/I/L). Ej.: `SISI-2643-K7M2QX`. Se genera al crear el periodo, así sirve también para pagar antes del corte.
- [ ] **Comisión que llega con su periodo ya cerrado** (p. ej. una autoconfirmación o una disputa resuelta después del corte): va al **periodo abierto actual**, sin tocar cortes cerrados. Una disputa resuelta como "terminado" cuenta en la semana de la resolución.
- [ ] **Pagos:** se aplican a los periodos más antiguos primero. Un pago **parcial** reduce el saldo pero el periodo no pasa a pagado hasta cubrirse. Un pago **de más** queda como saldo a favor en el periodo actual, sin devolución automática; se descuenta en el próximo corte.
- [ ] **Ajuste sobre un periodo pagado:** si un ajuste en contra vuelve a dejarlo con saldo, el periodo vuelve a "por pagar" (o a vencido si su fecha pasó) y puede volver a bloquear.
- [ ] **Comprobante subido por el trabajador:** queda "enviado, pendiente de verificación" y no cambia la deuda hasta que un admin registra el pago (o lo rechaza con motivo). Solo fotos (JPEG, PNG o HEIC): definir si se aceptan PDF.
- [ ] **Cron de cobros cada hora** (ADR-0036): puesta al día idempotente; a lo sumo 1 h entre el corte y el aviso.
- [ ] **Facturación de la comisión:** no implementada. `payments.invoice_number` existe (opcional, sin uso) hasta la revisión legal y tributaria.
- [ ] **QR de cobro:** uno global (`app_settings`). Definir si cada ciudad tendrá su propia cuenta.
- [ ] **CORS del bucket (R2) en staging y producción:** Flutter web carga las imágenes con XHR, así que el bucket debe permitir `GET` desde los dominios de la app y del admin; si no, no se ven el QR, los comprobantes ni las fotos. En local está en `infra/storage/cors.json` (incluye `127.0.0.1:8080` para la prueba con dos sesiones).

## Propuestas de la Fase 4 por validar
- [ ] **Autoconfirmación:** si el empleador no confirma ni reporta un problema **24 h** después del "Terminé" del trabajador, el trabajo se confirma solo y se cobra la comisión (`JOB_AUTOCONFIRM_MS`, ADR-0029).
- [ ] **Confirmar sin "Terminé":** el empleador puede confirmar un trabajo en curso aunque el trabajador no haya marcado "Terminé" (R6.2 solo exige la confirmación del empleador).
- [ ] **Disputa ("Hubo un problema"):** solo el empleador, solo después del "Terminé". El trabajo queda en curso, sin autoconfirmación y sin comisión, hasta que un administrador lo resuelve: **confirmar** (terminado, con comisión) o **cancelar** (cancelado, sin comisión; la solicitud queda cancelada). Sin plazo para resolver. Definir: plazo de resolución, si el trabajador puede responder, y qué pasa con las calificaciones de un trabajo cancelado por disputa.
- [ ] **Cancelación de un trabajo:** cualquiera de las dos partes, solo en asignado o en camino (en curso no). Motivos: cambio de planes, no llega o no responde, desacuerdo con el precio, emergencia, otro; nota opcional moderada. **Sin penalidad**: solo se cuenta (`users.cancellations_count`). Definir si habrá límite o penalidad, y si el empleador puede cancelar cuando el trabajador "no llega" estando en curso.
- [ ] **Ventana del chat:** abierto desde la asignación hasta **24 h** después de terminado o cancelado; luego, solo lectura (`JOB_CHAT_OPEN_AFTER_MS`). Límite de **30 mensajes por minuto** por usuario (`RATE_CHAT_PER_MIN`). Solo texto: decidir si habrá **imágenes** en el chat (con moderación de imágenes).
- [ ] **Mensajes retenidos del chat:** no se entregan y el admin solo puede verlos (`GET /admin/chat/held`). Definir si el admin puede liberarlos y si cuentan para una suspensión.
- [ ] **Contacto después del trabajo:** el teléfono se oculta **24 h** después de terminado o cancelado (`JOB_CONTACT_VISIBLE_AFTER_MS`, 410 `CONTACT_EXPIRED`); el chat queda en solo lectura.
- [ ] **Calificaciones:** solo trabajos terminados, dentro de **7 días** (`REVIEW_WINDOW_MS`); **ciegas** hasta que califican las dos partes o vence el plazo; comentario moderado (si coincide, no se publica y las estrellas cuentan). Recordatorio al terminar. Definir si se manda un segundo recordatorio antes de vencer.
- [ ] **Promedio del empleador:** se guarda y se muestra a los trabajadores en las solicitudes entrantes. Definir si un promedio bajo debe filtrar o advertir algo.
- [ ] **Reportes:** motivos de R9.1 más acoso, fraude, no se presentó, suplantación y otro. Cuentan **3 reportes válidos de personas distintas** (`REPORTS_SUSPEND_THRESHOLD`) y los valida un admin. Solo se reporta lo que uno conoce (trabajo, chat, solicitud que le llegó, contraparte).
- [ ] **Reportes contra alguien que solo es empleador:** no hay estado para suspenderlo (R1.4 es del trabajador); hoy se marca `moderation_flagged_at` y se avisa al admin. Definir si se agrega un bloqueo de cuenta (relacionado con "Bloqueo permanente").
- [ ] **Trabajador ocupado:** con un trabajo asignado, en camino o en curso no recibe solicitudes ni puede ofertar. Al ser elegido, sus otras ofertas activas se retiran solas (el empleador recibe el aviso y, si era la única, su solicitud vuelve a buscar).

## Propuestas de la Fase 3 por validar
Implementadas como propuesta; cambiarlas es configuración (variables de entorno, ver `backend/.env.example`).

- [ ] **Candidatos por anillo:** anillo 1 = 5 más cercanos a ≤ 2 km (R4.2); **anillos 2 y 3 = hasta 10** a ≤ 5 y ≤ 10 km (`MATCHING_RINGS=2:5,5:10,10:10`).
- [ ] **Ofertas suficientes:** con **3** ofertas activas no se amplía al anillo siguiente (`MATCHING_ENOUGH_OFFERS`).
- [ ] **Espera por anillo:** 45 s (R4.3, `MATCHING_RING_WAIT_MS`).
- [ ] **Anillo vacío:** si un anillo no encuentra candidatos nuevos se pasa **de inmediato** al siguiente (decidido en el plan de la Fase 3).
- [ ] **Tiempo mínimo de búsqueda** (Fase 4): sin ofertas, la solicitud sigue buscando **3 minutos** desde que se publica y reintenta el último anillo **cada 45 s** por si aparece alguien; recién entonces expira (R4.5). Valores en propuesta (`MATCHING_MIN_SEARCH_MS`, `MATCHING_RESCAN_MS`).
- [ ] **Expiración con ofertas sin elegir:** la solicitud expira **10 minutos** después del último anillo y se cierran las ofertas (`MATCHING_OFFERS_GRACE_MS`). Pasar a R4.5 del doc 01 si se aprueba.
- [ ] **Tope de la contraoferta:** **3 ×** el máximo de referencia de la categoría en la ciudad (`OFFER_COUNTER_MAX_FACTOR`). Mínimo: > 0.
- [ ] **Velocidades del ETA:** a pie 4,5 km/h, bicicleta 12, moto 25, auto 20, transporte público 15; distancia en línea recta × **1,3** (`ETA_SPEEDS_KMH`, `ETA_ROUTE_FACTOR`). Ajustar con datos reales de Santa Cruz.
- [ ] **Ubicación del trabajador:** se guarda en Postgres cada 30 s o al moverse 100 m; sin ubicación en **10 min** deja de estar disponible (`WORKER_LOCATION_*`).
- [ ] **Ubicación en segundo plano:** el MVP solo usa la ubicación en primer plano (ADR-0024). Para recibir solicitudes con la app cerrada hace falta permiso de ubicación en segundo plano (Android `ACCESS_BACKGROUND_LOCATION` y servicio en primer plano; iOS "Siempre"), con justificación ante Google Play y App Store. Decidir si se hace y cuándo.
- [ ] **Límites:** ofertas 10 por minuto por usuario y 60 por minuto por IP; ubicación 30 por minuto por usuario (`RATE_OFFER_*`, `RATE_WORKER_LOCATION_PER_MIN`).
- [ ] **Qué ve el empleador de una oferta:** nombre corto ("María P."), calificación, precio, tipo y ETA. Si el trabajador no cargó su nombre aparece "Trabajador". ¿Exigir nombre para trabajar?

## Detectadas en la Fase 3
- [x] **Retirar una oferta:** `DELETE /requests/:id/offers/mine` (Fase 4). Si era la única, la solicitud vuelve a buscando.
- [ ] **Push en iOS:** pendiente hasta tener la cuenta de Apple Developer (llave APNs en Firebase). Ver README, "Firebase".
- [ ] **Firebase sin configurar:** staging corre con `PUSH_PROVIDER=fake` (solo log). Crear el proyecto y cargar las variables (README, "Firebase") antes de probar push en staging.
- [x] **Limpieza del outbox:** job diario que borra los eventos publicados hace más de `OUTBOX_RETENTION_DAYS` (7) días (Fase 4, ADR-0022).
- [x] ~~**Historial de ofertas**~~ — Fase 6: `offer_events` append-only (ADR-0042).
- [x] **Contacto:** la API da `telUri` y `whatsappUri` (Fase 4); la app agrega "Llamar" y "WhatsApp" con `url_launcher`.
- [x] **Bandeja de avisos en la app:** pantalla de avisos con contador en el ícono y "Marcar todo como leído" (Fase 4).
- [ ] **Varias instancias de la API:** el socket usa solo el transporte `websocket`, así no hacen falta sticky sessions. Si algún cliente necesitara `polling`, habría que activarlas en Render.
- [ ] **Build de Android sin verificar en local:** las licencias del Android SDK no están aceptadas en esta máquina (`flutter doctor --android-licenses`). Lo valida el workflow mobile-release.

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
- [x] ~~**Borradores abandonados**~~ — Fase 7: job de retención que borra la solicitud y sus fotos (ADR-0050). El plazo (7 días) está en "Propuestas de la Fase 7".
- [x] ~~**Eventos no durables** (ADR-0020)~~ — Fase 3, 2026-10-15: outbox transaccional, relay a BullMQ con jobId determinístico y reconciliador (ADR-0022).
- [x] ~~**Aviso al empleador cuando el admin libera o rechaza**~~ — Fase 3, 2026-10-15: aviso guardado + push (ADR-0027).
- [x] ~~**Panel admin de moderación**~~ — Fase 6 (panel).
- [ ] **Edición de la solicitud** después de publicar: no existe (solo cancelar). Confirmar que es la regla deseada.
- [x] ~~**Expiración de solicitudes**~~ — Fase 3, 2026-10-15: tras el último anillo, sin ofertas expira; con ofertas, tras el plazo de elección (ADR-0025). Plazos en propuesta: ver la Fase 3.
- [x] ~~**Test e2e intermitente**~~ — Fase 3, 2026-10-15: estado compartido entre corridas (teléfonos que se repetían, base sin limpiar, dos corridas a la vez, timeout de 5 s). Aislamiento y 20 de 20 (ADR-0028).

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
- [x] ~~**Primer administrador en producción**~~ — ver la Fase 6 y el runbook (Fase 7).
- [x] **Avisos al trabajador** (`WorkerNotifier`): `account:blocked` / `account:unblocked` y push (Fase 5, `RealtimeWorkerNotifier`).
- [x] **Deuda vencida** (`DebtStatusProvider`): periodos `vencido` (Fase 5, `BillingDebtStatusProvider`).
- [ ] **Bloqueo permanente** por moderación: no existe en R1.4. Definir si se agrega un estado o se maneja como suspensión indefinida.
- [ ] **Tokens en la versión web** (ADR-0014): evaluar pasar el refresh a una cookie `httpOnly` (vía API) antes de abrir la web a usuarios reales; CSP estricta en Vercel.
- [x] ~~**Adopción del cliente Dart generado** en `apps/admin`~~ — Fase 6 (ADR-0045). La app móvil sigue con sus modelos (pendiente en la Fase 6).
- [ ] **CORS del bucket R2:** agregar los dominios definitivos de la app web cuando existan (hoy solo se configuran los de staging).
- [ ] **Conservación de fotos de identidad:** propuesta de la Fase 7: las de solicitudes rechazadas se borran a los 90 días, y las de aprobados se conservan mientras la cuenta exista y se borran al eliminarla (ADR-0049, ADR-0050). Falta la revisión legal.

## Detectadas en la Fase 0
- [ ] **ID de la app / bundle id:** los reales hoy son Android `bo.sisi.sisi_mobile` e iOS `bo.sisi.sisiMobile`. Depende de la marca; se fija antes de publicar (ver "Lanzamiento del piloto").
- [ ] **Dominio final** para `api.`, `app.` y `admin.` (afecta `CORS_ORIGINS`, `API_URL`, Vercel, Render y el CORS del bucket R2).
- [x] ~~**Proveedor de OTP**~~ — Bird.com, 2026-10-14 (ADR-0011). Detalles por validar arriba.
- [ ] **Mapas:** Google Maps o Mapbox. Fase 2: implementado con **Google como propuesta** detrás de interfaces cambiables (ADR-0021). Ver la Fase 2.
- [x] ~~**Almacenamiento**~~ — Cloudflare R2 en producción, RustFS en local, 2026-10-14 (ADR-0012).
- [ ] **Render:** región (propuesta `virginia`, la más cercana a Bolivia) y planes de staging (production debe usar planes pagos según doc 02 §8; staging puede ir en planes bajos).
- [x] ~~**Ciudades: área de cobertura**~~ — Fase 2, 2026-10-14: `center` + `service_radius_km` y `service_area` (polígono) opcional (ADR-0019). Valores de Santa Cruz por validar en la Fase 2.
- [x] ~~**Hora de Bolivia**~~ — resuelto: el cron corre cada hora y los límites se calculan en la zona de la ciudad (ADR-0035, ADR-0036).
- [ ] **Firma de apps:** la de Android está lista con la upload key fuera del repositorio (ADR-0054); falta generar la llave y las cuentas de Play y Apple (ver "Lanzamiento del piloto").
- [ ] **Código Flutter compartido:** hoy `core/` está duplicado en mobile y admin. Evaluar un paquete Dart en `packages/` cuando crezca (ver ADR-0005).
- [x] ~~**Cliente Dart desde OpenAPI**~~ — openapi-generator `dart-dio` vía Docker, 2026-10-14 (ADR-0015). Adopción en las apps: pendiente arriba.
- [ ] **Sentry:** integrado en la Fase 7 (ADR-0048); falta crear la cuenta y los proyectos (ver "Lanzamiento del piloto").
- [x] ~~**URL fija de staging en Vercel**~~ — Fase 6, 2026-10-17: proyectos de Vercel separados (`app-web-staging`, `admin-staging`) desplegados con `--prod`, y la URL `.onrender.com` de `api-staging` (ADR-0039). Al tener dominio, ver la migración en el ADR.
- [ ] **Protección de staging en Vercel:** con `--prod` las URLs `.vercel.app` de los proyectos de staging son públicas salvo que se active Deployment Protection. Decidir si staging queda privado o público para pruebas con usuarios (el OTP por consola exige que no se abra a terceros).
