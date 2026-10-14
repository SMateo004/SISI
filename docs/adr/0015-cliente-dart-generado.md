# ADR-0015: Cliente Dart generado desde OpenAPI

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
El doc 02 pide un cliente Dart generado del OpenAPI de NestJS en `packages/api_contract`. En la máquina de desarrollo no hay Java (openapi-generator lo necesita).

## Decisión
- `packages/api_contract/generate.mjs`:
  1. exporta `openapi.json` (`npm run openapi:export`, sin BD ni Redis);
  2. genera `dart/` con **openapi-generator v7.25.0 vía Docker** (`openapitools/openapi-generator-cli`), generador `dart-dio` y `serializationLibrary=json_serializable`;
  3. corre `build_runner` y `dart analyze`.
- El paquete se llama `sisi_api` y se versiona con los `.g.dart`, así que quien lo consume no necesita `build_runner`.
- `dart/pubspec.yaml` se ajusta a mano (SDK `>=3.8.0`, porque el código generado usa elementos de mapa null-aware) y queda protegido en `.openapi-generator-ignore`.
- El cliente recibe un `Dio` existente, así que conserva los interceptores de auth y refresh de la app.
- **Adopción diferida:** en la Fase 1 la app usa repositorios propios (pocos endpoints, más fáciles de simular en tests). Pasar a `sisi_api` queda pendiente.

## Consecuencias
- Cada cambio de API debe regenerar el contrato (`node packages/api_contract/generate.mjs`).
- El generador produce avisos de imports sin usar (no son errores).
- Si se adopta en las apps, los repositorios pasan a envolver `sisi_api` y los tests siguen usando fakes.
