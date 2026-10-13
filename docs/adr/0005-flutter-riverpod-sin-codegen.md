# ADR-0005: Flutter con Riverpod sin generación de código; core por app

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
Hay dos apps Flutter (mobile y admin) con necesidades base similares (tema, rutas, dio, configuración por ambiente).

## Decisión
- Riverpod con providers escritos a mano (sin `riverpod_generator`/`build_runner`) para mantener el build simple.
- Configuración por ambiente con `--dart-define` (`API_URL`, `SOCKET_URL`) leída en `lib/core/config/env.dart`.
- En Fase 0 cada app tiene su propio `lib/core/`. Si el código compartido crece, se extrae a un paquete Dart en `packages/` (anotado en pendientes).

## Consecuencias
Algo de duplicación inicial a cambio de independencia entre apps.
