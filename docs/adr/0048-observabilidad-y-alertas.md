# ADR-0048: Observabilidad: Sentry, logs con id de correlación y alertas

- Estado: aceptada
- Fecha: 2026-10-18
- Fase: 7

## Contexto
`SENTRY_DSN` existía desde la Fase 0, pero nada lo usaba. Los logs eran texto de Nest, sin forma de seguir una petición hasta el worker. No había alertas, así que un outbox detenido o un cron caído se descubrían por las quejas.

## Decisión
- **Sentry:**
  - **Backend:** `@sentry/node` 11.4.0, sin scripts de instalación, en api, worker y cron. Release `sisi-backend@<versión>+<sha>`, ambiente `APP_ENV` y sin trazas de rendimiento.
    - Van a Sentry los 5xx (`SentryExceptionFilter`, registrado antes de `RateLimitedFilter` para no quitarle su 429) y el último intento fallido de un job de BullMQ.
    - Los 4xx no van: son respuestas esperadas.
  - **Apps:** `sentry_flutter` 9.30.1 en mobile y admin, con versión y build del pubspec.
  - Sin datos personales en ningún caso (ADR-0047).
- **Logs JSON** en staging y producción: una línea por mensaje con `service`, `env`, `release`, `context`, `requestId` y `userId`.
  - `X-Request-Id` entra o se genera, y vuelve en la respuesta. Se guarda en `outbox_events.request_id`, así los handlers del worker loguean con el id de la petición que originó el evento.
  - En local, el formato de Nest.
- **Alertas.** Cada una llega a Sentry con un fingerprint estable (una issue por tipo), y una regla de Sentry avisa por el canal elegido (propuesta: email).

  | Alerta | Cómo se detecta |
  | --- | --- |
  | API caída | Monitor externo de `/health` (UptimeRobot o Sentry Uptime) |
  | 5xx | Regla de frecuencia de errores en Sentry |
  | billing-cron sin correr | Monitor de cron de Sentry: check-in a los :05; avisa si no llega 60 min después (2 h sin correr) |
  | Outbox sin publicar más de 5 min | `OpsMonitor` del worker, cada minuto, con candado (una instancia por vuelta) |
  | Cola con jobs esperando más de 5 min, o 10 fallidos nuevos | `OpsMonitor` |
  | Fallos de envío del OTP (5 en ~10 min) | `OpsMonitor`, con contadores en Redis por ventana |
  | Fallos de push (20, o el 20 % con al menos 10 envíos) | `OpsMonitor`, con contadores en Redis por ventana |
  | Worker caído o colgado | Latido del `OpsMonitor` como monitor de Sentry (cada minuto, margen de 5) |

  Los umbrales van en `OPS_*`.
- **Simulacro en staging:**
  - `dev-tools ops-drill outbox|otp|push|clear` deja cada condición sobre su umbral sin tocar datos reales;
  - `POST /admin/ops/drill-500` provoca un 5xx real: solo un admin, y en producción responde 404;
  - el cron se prueba pausándolo en Render.

## Consecuencias
- Un incidente se sigue con un solo id, desde la petición hasta el handler del worker.
- Las alertas dependen de Sentry y del monitor externo, que son cuentas a crear (runbook).
- Una métrica de fallos nunca rompe un login ni un aviso: si Redis falla, el contador se pierde y `/health` lo detecta.
