# Prueba de carga del piloto (ADR-0053)

**Solo contra staging (o local). Nunca contra producción.** Todo corre con Docker; no se instala nada.

## Escenario propuesto

| Carga | Valor | Variable |
| --- | --- | --- |
| Trabajadores disponibles, ubicación cada 30 s | 200 | `WORKERS` |
| Empleadores | 40 | `EMPLOYERS` |
| Solicitudes por minuto (unas 30 abiertas a la vez; cada una vive ~5 min) | 6 | `REQUESTS_PER_MIN` |
| Carga sostenida | 30 min | `DURATION` |
| Pico al doble | 5 min | `SPIKE` |

En cada ciclo:
- Los trabajadores ofertan a lo que les llega, con un 20 % de contraofertas.
- Los empleadores eligen la primera oferta y chatean.
- El trabajador avanza el trabajo (en camino, empecé, terminé) y el empleador confirma.

## Antes de correr (en staging)

1. **Planes de producción:** subir temporalmente `api-staging`, `worker-staging` y `db-staging` a los planes de producción (`standard`, `starter` y `basic-1gb`), así el resultado vale para producción. Es reversible: se bajan al terminar.
2. **Límites por IP:** k6 sale desde una sola IP y los límites por IP lo cortarían. Durante la ventana de la prueba (anotar y revertir):

   | Variable | Valor durante la prueba |
   | --- | --- |
   | `RATE_GLOBAL_IP_PER_MIN` | 5000 |
   | `RATE_REQUEST_CREATE_IP_PER_HOUR` | 2000 |
   | `RATE_OFFER_IP_PER_MIN` | 2000 |

   Los límites por usuario quedan como están.
3. **Usuarios con tokens:** se generan sin SMS, justo antes de cada corrida (los refresh rotan y una corrida anterior los invalida). En Render → `api-staging` → Shell:

   ```bash
   npm run dev:tools -- loadtest-seed --workers 200 --employers 40 --out /tmp/usuarios.json
   ```

   Copiar `usuarios.json` a `loadtest/` en la máquina que corre k6. **Tiene tokens: no se sube a git** (está en `.gitignore`).
4. **Id de la categoría plomería:** `GET /categories` con uno de los tokens, o en la base.

## Correr

**Carga (k6):**

```bash
docker run --rm -v "$PWD/loadtest:/lt" -e API_URL=https://<api-staging> -e USERS=/lt/usuarios.json -e CATEGORY_ID=<id> grafana/k6:2.3.0 run --summary-export /lt/resultados/k6.json /lt/k6/pilot.js
```

**Entrega de `request:new`:** desde que la API responde la publicación hasta que el socket del trabajador recibe el evento.

```bash
docker run --rm -v "$PWD:/sisi" -w /sisi/loadtest/socket -e NODE_PATH=/sisi/backend/node_modules -e API_URL=https://<api-staging> -e USERS=/sisi/loadtest/usuarios.json -e CATEGORY_ID=<id> node:24-alpine node delivery.mjs
```

**Conexiones a Postgres** (Render → `api-staging` → Shell, durante la prueba):

```bash
npm run dev:tools -- db-stats --times 360
```

**CPU y memoria:** Render → `api-staging` y `worker-staging` → Metrics. Guardar capturas del periodo de la prueba.

## Qué mirar y cuándo alcanza

| Métrica | Objetivo | Si no se cumple |
| --- | --- | --- |
| Errores HTTP | < 1 % | Revisar Sentry y los logs (por `requestId`) |
| Ubicación, p95 | < 300 ms | Instancias de la API, índice GEO |
| Publicar, p95 | < 800 ms | Moderación y geocodificación |
| Ofertar, p95 | < 500 ms | Candados por solicitud (ADR-0026) |
| Chat, p95 | < 400 ms | |
| Entrega de `request:new`, p95 | < 2 s | `OUTBOX_POLL_MS`, CPU del worker, Redis |
| CPU de la API | < 70 % sostenido | Segunda instancia o plan mayor |
| CPU y memoria del worker | < 70 % | Plan `standard` para el worker |
| Conexiones a Postgres | < 80 % del máximo del plan | `connection_limit` del pool de Prisma, PgBouncer |

## Validación local (2026-10-18)

Antes de tener staging se validaron las herramientas contra la API y el worker locales (Docker), a escala chica: 6 trabajadores y 3 empleadores.
- **k6:** 100 % de los checks y < 1 % de errores (409 de trabajos que quedaron abiertos de corridas anteriores).
  - Ubicación p95: 62 ms. Publicar p95: 27 ms. Ofertar p95: 125 ms. Chat p95: 21 ms.
- **Entrega de `request:new`:** p95 de 1078 ms (15 entregas).

Esto prueba que el escenario funciona de punta a punta. **No mide la capacidad de Render**: eso queda para la corrida en staging.
