# ADR-0043: Parámetros de negocio en `app_settings`

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
Varios valores de negocio todavía en propuesta (anillos, ofertas suficientes, tiempo mínimo de búsqueda, tope de deuda, plazo, hora de avisos, autoconfirmación, ventanas) estaban solo en variables de entorno. Cambiarlos exigía un redeploy de la API, el worker y el cron. El negocio necesita ajustarlos desde el panel con validación y auditoría.

## Decisión

### Qué se mueve
Un catálogo tipado (`settings.catalog.ts`) define cada parámetro: tipo, unidad, rango de producción, texto de ayuda y grupo. Los parámetros editables son:
- **Matching:** `MATCHING_RINGS`, `MATCHING_RING_WAIT_MS`, `MATCHING_ENOUGH_OFFERS`, `MATCHING_OFFERS_GRACE_MS` y `MATCHING_MIN_SEARCH_MS`.
- **Ofertas:** `OFFER_COUNTER_MAX_FACTOR`.
- **Trabajos:** `JOB_AUTOCONFIRM_MS`, `JOB_CHAT_OPEN_AFTER_MS`, `JOB_CONTACT_VISIBLE_AFTER_MS` y `REVIEW_WINDOW_MS`.
- **Cobros:** `BILLING_DEBT_CAP_BS`, `BILLING_DUE_AFTER_DAYS` y `BILLING_REMINDER_HOUR`.

### Qué se queda en el entorno
- Límites `RATE_*` (seguridad, no negocio).
- `OUTBOX_*`, `QUEUE_*`, `*_URL_TTL_SEC` y `BILLING_LOCK_TTL_MS`.
- `MATCHING_RESCAN_MS`, `MATCHING_RECONCILE_MS`, `WORKER_LOCATION_*`, `JOB_LOCATION_EMIT_MS` y `PRESENCE_TTL_MS` (técnicos).
- Límites de texto y fotos de las solicitudes, y la ETA.
- **El día de corte no es parámetro:** la semana va de lunes a domingo (ADR-0035). Moverlo cambiaría periodos ya creados.

### Cómo funciona
- **Valor vigente:** el guardado en `app_settings` (alcance `global`) o, si no hay, la variable de entorno. Así los e2e siguen en milisegundos y sin filas.
- **`AppSettingsService.value(key)`** es sincrónico: lee una copia en memoria. Los consumidores lo leen en cada uso (getters), no al construirse.
  - El `MATCHING_CONFIG` expone getters, así que un cambio se aplica a la siguiente decisión del matching.
  - Lo leen la API, el worker, el cron de cobros y dev-tools (`SettingsModule` global en los cuatro).
- **Propagación:** al escribir, la versión `settings:version` sube en Redis y el proceso que escribió recarga de inmediato. Los demás comparan la versión cada `SETTINGS_REFRESH_MS` (15 s) y recargan.
- **Panel:**
  - `GET /admin/settings` muestra valor, valor por defecto, rango, unidad y si está cambiado;
  - `PUT /admin/settings/:key {value, reason}` valida el rango (400 `SETTING_OUT_OF_RANGE`);
  - `POST /admin/settings/:key/reset {reason}` vuelve al valor por defecto;
  - las dos escrituras se auditan con antes y después en su transacción (ADR-0041).
- **Al recargar:** un valor guardado que ya no pasa la validación (p. ej. si cambió el rango) se ignora, con un aviso en el log.

## Consecuencias
- Los cambios no requieren redeploy y quedan auditados. El efecto llega a todos los procesos en a lo sumo 15 s.
- **Qué afecta cada cambio:**
  - **Plazo de pago:** solo a los periodos que se crean después; `due_at` se fija al crear el periodo.
  - **Autoconfirmación ya programada:** sigue con el plazo con que se programó. El reconciliador usa el valor nuevo.
  - **Anillos:** una solicitud ya en un anillo que deja de existir termina su búsqueda normalmente (`skip`).
- **Rangos de producción:** el panel no acepta valores de prueba. Para pruebas manuales con tiempos cortos se usa el entorno.
- **Pendiente:** valores por ciudad. La columna `scope` ya existe, pero el matching y billing leen solo el global.

## Actualización (Fase 7)
- **Tipo `text`** en el catálogo, validado por formato: `SUPPORT_WHATSAPP`, `APP_MIN_VERSION_ANDROID`, `APP_MIN_VERSION_IOS`, `APP_MIN_VERSION_WEB` y `PILOT_STARTED_AT`, en el grupo "App y piloto" (ADR-0052, ADR-0054).
- **Corrección:** la ayuda de "Contraoferta máxima" dice ahora lo que hace el código: veces el máximo de referencia de la categoría, no el precio propuesto.
