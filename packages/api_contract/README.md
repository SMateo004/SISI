# api_contract

Contrato de la API de SISI (ADR-0015).

| Ruta | Qué es |
| --- | --- |
| `openapi.json` | OpenAPI generado por NestJS Swagger (`backend/src/app.setup.ts`). |
| `dart/` | Paquete Dart `sisi_api` generado con openapi-generator (`dart-dio` + json_serializable). |
| `generate.mjs` | Regenera ambos. |

## Regenerar

Desde la raíz del repo, con Docker corriendo:

```bash
node packages/api_contract/generate.mjs
```

1. Exporta `openapi.json` sin conectarse a la base ni a Redis (`npm run openapi:export`).
2. Genera `dart/` con `openapitools/openapi-generator-cli:v7.25.0` (Docker: no hace falta Java).
3. Corre `build_runner` para los `.g.dart` y `dart analyze`.

Los archivos generados se versionan, así que quien consume el paquete no necesita correr `build_runner`.

`dart/pubspec.yaml` está ajustado a mano (SDK `>=3.8.0`, porque el código generado usa elementos de mapa null-aware) y protegido en `dart/.openapi-generator-ignore`.

## Uso

La adopción en `apps/mobile` y `apps/admin` está pendiente (ver `docs/pendientes.md`). Para usarlo, el cliente recibe el `Dio` de la app, así que conserva sus interceptores (auth y refresh):

```dart
final api = SisiApi(dio: ref.watch(dioProvider));
final me = await api.getMeApi().meControllerMe();
```
