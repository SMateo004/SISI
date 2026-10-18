# ADR-0021: Mapas y geocodificación (MapView propio, llaves separadas)

- Estado: aceptada (proveedor Google como propuesta, ver docs/pendientes.md)
- Fecha: 2026-10-14
- Fase: 2

## Contexto
El empleador marca la ubicación en un mapa y se le sugiere la dirección. El proveedor (Google Maps o Mapbox) no estaba decidido, la llave del backend nunca debe llegar a la app, y en local y tests no queremos depender de una llave.

## Decisión
- **Backend**: `GeocodingService.reverse(lat, lng)` con dos implementaciones: `GoogleGeocodingService` (fetch nativo, `language=es`, `region=bo`, timeout 5 s) y `FakeGeocodingService`. `GEOCODING_PROVIDER=fake|google`; en production se exige `google` + `MAPS_API_KEY` al arrancar. `GET /geocoding/reverse` con sesión, `@RateLimit('geocodeIp')` y caché en Redis de 7 días con coordenadas redondeadas a 4 decimales (~11 m).
- **App**: widget `MapView` con pin fijo al centro; el proveedor se elige en `mapViewBuilderProvider`: `GoogleMapView` (google_maps_flutter 2.18.1, la última compatible con Flutter 3.44) si hay llave, `PlaceholderMapView` (lienzo arrastrable) si no. En web el script de Google se inyecta desde Dart solo si hay llave.
- **Llaves separadas**: servidor (`MAPS_API_KEY` en Render, solo Geocoding API) y app por plataforma (`--dart-define=MAPS_API_KEY` para web, `manifestPlaceholders` en Android, `Info.plist`/`AppDelegate` en iOS), cada una restringida por dominio, paquete + SHA-1 o bundle id.

## Consecuencias
Cambiar a Mapbox es una implementación nueva de `GeocodingService` y de `MapViewBuilder`, sin tocar pantallas. Local, CI y tests funcionan sin llaves. Las llaves de la app son públicas por naturaleza: su protección son las restricciones en la consola de Google.

## Actualización (Fase 7)
Llaves de producción (runbook, "Google Maps"):
- **Servidor:** solo Geocoding API, sin restricción de referer.
- **Android:** paquete y SHA-1 del certificado de **Play App Signing** y del upload key.
- **Web:** dominios de producción.

Cuotas diarias por API y alertas de presupuesto en Google Cloud Billing al 50, 90 y 100 %.
