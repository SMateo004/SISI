# ADR-0011: Proveedores de OTP y ambiente lógico (APP_ENV)

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
Hace falta enviar el código sin tener todavía cuenta del proveedor real, y garantizar que el envío por consola nunca llegue a producción. Staging corre con `NODE_ENV=production`, así que `NODE_ENV` no distingue staging de producción. El dueño del proyecto eligió **Bird.com** como proveedor real. El código se genera y se hashea en SISI (ADR-0009), así que el proveedor solo lo transporta.

## Decisión
- `APP_ENV` (`local | test | staging | production`) es el ambiente lógico. Es obligatorio si `NODE_ENV=production`; sin él la API no arranca, para no caer en "local" por error.
- Interfaz `OtpProvider.send(teléfono, código)`, elegida con `OTP_PROVIDER`:
  - `ConsoleOtpProvider`: escribe el código en el log. Permitido en local, test y staging.
  - `BirdOtpProvider`: `POST https://{región}.platform.bird.com/v1/sms/messages` con `Authorization: Bearer <OTP_PROVIDER_KEY>`, `from: OTP_SENDER` y `category: authentication`. La región sale del prefijo de la clave (`bk_us1_…`). Usa `fetch` nativo con timeout de 10 s; no uso el SDK. Un rechazo responde 503 `OTP_SEND_FAILED` sin detalles internos y deja el detalle en el log.
- Validación al arrancar (fábrica en `auth.module.ts`):
  - `APP_ENV=production` con `OTP_PROVIDER=console` impide arrancar.
  - `bird` sin clave o sin remitente también.
- Si el envío falla, el código guardado se borra.
- Worker y billing-cron no cargan el módulo de auth, así que no exigen estas variables.

## Consecuencias
- **Staging con consola:** el código queda en los logs de Render. Solo es aceptable mientras staging no se publique a usuarios reales (advertencia en `render.yaml`, `docs/runbook.md` y pendientes).
- Producción no despliega hasta tener Bird configurado. Es intencional.
- WhatsApp queda pendiente (requiere plantilla aprobada en Bird); se agrega como otra implementación o canal sin tocar `OtpService`.

## Actualización (Fase 7)
- El `ConsoleOtpProvider` también se niega a construirse con `APP_ENV=production` (además de la fábrica).
- La respuesta de Bird se registra redactada: sin teléfonos ni códigos (ADR-0047).
- Con el piloto cerrado, un número fuera de la lista no recibe SMS (ADR-0052).
- Cada fallo de envío cuenta para la alerta de OTP (ADR-0048).
