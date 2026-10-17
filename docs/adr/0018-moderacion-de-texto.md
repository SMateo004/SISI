# ADR-0018: Moderación de texto y protección de regex

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 2

## Contexto
R3.3 y R9.2: las solicitudes con términos prohibidos (servicios sexuales, drogas, armas, actividades ilegales o inmorales, venta de productos) quedan retenidas para revisión. Los usuarios intentan evadir filtros ("m4rihuana", "c.o.c.a", "cocaaaa"). El admin puede cargar expresiones regulares, y una regex mal escrita puede colgar el proceso (ReDoS). El chat (Fase 4) usará el mismo filtro.

## Decisión
- `ModerationService.check(texto)` → `{ held, matches[], timedOut }`, independiente de solicitudes.
- **Normalización** (`normalize.ts`): minúsculas, sin tildes (NFD), leet solo dentro de palabras (0→o, 1→i, 3→e, 4→a, 5→s, 7→t, @→a, $→s), letras repetidas colapsadas, y secuencias de ≥3 letras sueltas separadas por `. - _` o espacios se unen ("c.o.c.a" → "coca").
- **Términos `word`**: palabra completa o frase sobre el texto normalizado; un `*` final permite sufijos (`marihuan*`). El término se normaliza igual que el texto.
- **Términos `regex`**, al guardar (`checkPattern`): máx. 100 caracteres, compila con `iu`, rechaza referencias hacia atrás, lookaround y cuantificadores anidados, y se prueba contra entradas adversarias en `node:vm` con timeout de 100 ms; se rechaza solo si se excede dos veces seguidas (con 20 ms fallaba de forma intermitente bajo carga, corregido en la Fase 3).
- **Al evaluar**: todas las regex corren en `vm` con timeout de 50 ms. Si se excede, el texto queda retenido (falla seguro) y se registra `timedOut`. El presupuesto es configurable (`MODERATION_REGEX_TIMEOUT_MS`, 50 ms por defecto; Fase 4): con la máquina cargada, 50 ms retuvo un texto limpio en un e2e, así que los e2e usan 2 s.
- Términos compilados en memoria por instancia e invalidados con una versión en Redis (`moderation:terms:version`) que se incrementa al editarlos.
- Admin: CRUD en `/admin/moderation-terms`; DELETE es baja lógica (`active=false`).
- Seed separado (`prisma/seed-data/moderation-terms.ts`, 71 términos) **para revisión**, cuidando usos legítimos ("hoja de coca" es legal en Bolivia; "acompañante de adulto mayor").
- Sin librerías externas (re2 exige compilación nativa; `vm` viene con Node).

## Consecuencias
Puede haber falsos positivos: no se rechaza, se retiene y el admin decide (`release`/`reject`). El usuario solo ve un mensaje neutral, para no enseñar qué palabra disparó el filtro. La lista de términos es responsabilidad de negocio (docs/pendientes.md).
