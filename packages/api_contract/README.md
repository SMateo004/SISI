# api_contract

Contrato de la API de SISI.

- `openapi.json`: especificación OpenAPI generada por NestJS Swagger. Se regenera con:

  ```bash
  cd backend && npm run openapi:export
  ```

  El comando no necesita base de datos ni Redis (arma el documento sin conectarse).

- Cliente Dart generado: pendiente (ver `docs/pendientes.md`). Cuando exista, vivirá en `packages/api_contract/dart/` y lo consumirán `apps/mobile` y `apps/admin`.
