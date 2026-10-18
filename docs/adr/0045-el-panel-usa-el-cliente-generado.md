# ADR-0045: El panel admin usa el cliente Dart generado

- Estado: aceptada
- Fecha: 2026-10-17
- Fase: 6

## Contexto
Desde la Fase 1 se genera `sisi_api` (OpenAPI → `dart-dio` con `json_serializable`, ADR-0015) en `packages/api_contract/dart`. Quedó pendiente si las apps lo usan: la app móvil se escribió con sus propios modelos. El panel es nuevo, tiene unas 60 rutas y sus pantallas reflejan casi tal cual las respuestas del contrato.

## Decisión
- **El panel usa `sisi_api`** como dependencia `path:` (`../../packages/api_contract/dart`).
  - El código generado (incluidos los `.g.dart`) está en el repo, así que el panel no necesita `build_runner`.
  - Dependencias nuevas, transitivas y solo Dart, sin scripts de instalación: `json_annotation` y `copy_with_extension`. Compila con el Flutter del proyecto (3.44.9).
- **Una sola sesión de `dio`:** el panel crea su `Dio` (base `/api`, interceptor de sesión y refresh con cookie, ADR-0040) y se lo pasa a `SisiApi`. Los errores se leen de `ApiErrorBody`.
- **La app móvil no migra en esta fase:** sus modelos escritos a mano funcionan y migrarla no aporta en el MVP. Queda en pendientes.
- **Contrato:**
  - `generate.mjs` se corre después de cada cambio de la API (incluye `dart analyze` del cliente). En CI, el `flutter analyze` y los tests del admin en `deploy-web` compilan contra el cliente: si el contrato rompe el panel, falla el despliegue.
  - Un tipo `oneOf` de varios primitivos rompe el generador: la API los evita (p. ej., los parámetros viajan como texto, ADR-0043).

## Consecuencias
- El panel no tiene modelos duplicados: un cambio de la API que rompa el panel aparece al regenerar y compilar.
- Los nombres de las clases salen del contrato (`AdminCategoryDto`, `VerificationPageDto`…). Las pantallas usan esos DTO directamente, sin repositorios intermedios. Los tests reemplazan `adminApiProvider` por un cliente falso que responde por nombre de método.
- La descarga del CSV y los endpoints con cookie (`/auth/admin/*`) se llaman con el mismo `Dio` (respuesta en bytes, `withCredentials`), no con el cliente generado.
