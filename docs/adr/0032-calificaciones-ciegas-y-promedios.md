# ADR-0032: Calificaciones ciegas y promedios

- Estado: aceptada
- Fecha: 2026-10-16
- Fase: 4

## Contexto
R6.2 dice que, al terminar, las dos partes se califican con 1 a 5 estrellas y un comentario. Si la primera calificación se ve antes de que la otra parte califique, la segunda tiende a responder en espejo (represalia o favor). El empleador ve el promedio del trabajador en las ofertas (R5.3), y el trabajador necesita una señal equivalente del empleador en las solicitudes entrantes.

## Decisión
- **Tabla `reviews`** (doc 02):
  - `job_id`, `city_id`, `from_user`, `to_user`, `reviewer_role` (`employer` | `worker`);
  - `stars` 1 a 5 (CHECK), `comment` (hasta 500), `comment_held`, `published_at`;
  - `UNIQUE(job_id, from_user)`: una por parte y por trabajo; CHECK `from_user <> to_user`.
- **Cuándo se califica** (propuesta): solo con el trabajo `terminado` y dentro de `REVIEW_WINDOW_MS` (7 días) desde que terminó. Errores 409: `REVIEW_NOT_ALLOWED`, `REVIEW_WINDOW_CLOSED`, `ALREADY_REVIEWED`.
- **Comentario moderado** con `ModerationService.check`: si coincide, `comment_held` y no se publica el texto; las estrellas cuentan igual.
- **Ciegas:** la de la contraparte se ve recién cuando:
  - califican las dos, en la misma transacción de la segunda (con el trabajo bloqueado, así dos envíos simultáneos no quedan los dos sin publicar); o
  - vence el plazo: barrido periódico del worker junto con el reconciliador (`ReviewPublisher.sweepDue`).
- **Promedios al publicarse** (cambio respecto al plan): en lugar de `avg = (avg × count + stars) / (count + 1)`, se bloquea la fila del perfil o del usuario y se **recalcula** desde las calificaciones publicadas (`ROUND(AVG(stars), 2)` y `COUNT`).
  - Es atómico igual, y no acumula el error de redondear el promedio en cada paso.
  - Columnas: trabajador en `worker_profiles.rating_avg/rating_count` (lo que ve el empleador); empleador en `users.employer_rating_avg/employer_rating_count`, nuevo.
- **Dónde se ve:**
  - `GET /jobs/:id` y `GET /jobs/:id/reviews`: la mía, la recibida si ya se publicó, `canReview` y `deadline`;
  - `GET /users/:id/reviews?role=worker|employer`: las publicadas, con el promedio;
  - las solicitudes entrantes traen `employer.ratingAvg/ratingCount`.
- **Recordatorio:** al terminar, las dos partes reciben el aviso "Califica a…".

## Consecuencias
- Nadie ve la calificación del otro antes de dar la suya.
- Un trabajo cancelado (también por disputa) no se califica.
- Plazo, visibilidad y si el promedio del empleador filtra solicitudes, en docs/pendientes.md.
