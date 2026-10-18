# ADR-0052: Piloto cerrado: lista de teléfonos, interés, zonas, soporte y métricas

- Estado: aceptada (propuesta)
- Fecha: 2026-10-18
- Fase: 7

## Contexto
El piloto en Santa Cruz arranca con un grupo controlado de trabajadores y empleadores. Quien no está invitado debe saber que la app llega pronto, y esa demanda se quiere medir. Las zonas, el soporte y las métricas del piloto se manejan desde el panel, sin redeploy.

## Decisión
- **Lista por ciudad:**
  - flag `pilot.closed` de la ciudad (apagado en el seed) y tabla `pilot_allowlist`. En producción, con los textos legales v0 vigentes, el seed lo enciende y no se puede apagar (ADR-0051);
  - con el flag encendido, `POST /auth/otp/request` responde 403 `PILOT_NOT_ALLOWED` a un número sin cuenta y fuera de la lista, **sin enviar el SMS**; la verificación repite el control;
  - las cuentas existentes siguen entrando, aunque se las quite de la lista.
- **"Pronto en tu zona":** la app lo muestra con el nombre de la ciudad. `POST /pilot/interest` (público, 10/h por IP) guarda teléfono, qué quiere hacer y barrio, uno por número.
- **Panel** (Configuración → Piloto):
  - estado del flag;
  - números pegados de una lista, con nota y motivo;
  - quitar números;
  - interés y su CSV.

  Todo queda auditado.
- **Zonas:** `GET` y `PUT /admin/cities/:id/service-area` con un GeoJSON Polygon o el radio.
  - **Validación:** un solo contorno cerrado, dentro de Bolivia (detecta latitud y longitud invertidas), válido en PostGIS y con el centro adentro.
  - **Probar un punto:** `POST …/test`, con la misma regla de una solicitud nueva.
  - **En el panel:** vista previa del contorno con `CustomPainter`, sin dependencia de mapas.
- **Soporte:** el parámetro `SUPPORT_WHATSAPP` (tipo texto en el catálogo de ADR-0043) aparece en `GET /app/config` y en la app como "Ayuda por WhatsApp".
- **Métricas** (`GET /admin/dashboard/pilot`), desde `PILOT_STARTED_AT` o las últimas 8 semanas:
  - embudo: creada → con oferta → asignada → terminada → comisión cobrada (periodo pagado);
  - tiempo a la primera oferta, tasa de expiración y tasa de cobro (cobrada sobre generada);
  - retención semanal: de los trabajadores que ofertaron y los empleadores que publicaron una semana, cuántos vuelven la siguiente.

  Índice nuevo `offer_events (city_id, created_at)`; el e2e de EXPLAIN incluye estas consultas.

## Consecuencias
- Un número invitado entra sin pasos manuales. Cerrar o abrir el piloto es un flag.
- **Un riesgo aceptado:** responder distinto a un número fuera de la lista revela si está invitado. El dato es poco sensible, y el límite por IP frena el barrido.
- **Pendiente:** el polígono real de lanzamiento, que se carga desde el panel.
