# ADR-0031: Chat moderado y presencia

- Estado: aceptada
- Fecha: 2026-10-16
- Fase: 4

## Contexto
R9.4 pide el chat dentro de la app y R9.2 que el filtro de texto se aplique también al chat: lo que coincide se retiene. Las partes necesitan coordinarse mientras dura el trabajo y un rato después (por ejemplo, para aclarar algo del pago), pero el chat no debe quedar abierto para siempre. Hay dos riesgos de aviso:
- mandar un push por cada mensaje a alguien que ya lo está leyendo en vivo;
- no avisarle a quien tiene la app cerrada.

## Decisión
- **Tabla `chat_messages`** por trabajo: `job_id`, `city_id`, `sender_id`, `body` (1 a 1000 caracteres, CHECK), `status` (`entregado` | `retenido`), `moderation_matches` (solo para el admin), `read_at` y `created_at`; índice `(job_id, created_at)`. **Solo texto** (sin imágenes en el MVP).
- **Ventana (propuesta):**
  - abierto desde que se asigna;
  - sigue abierto hasta `JOB_CHAT_OPEN_AFTER_MS` (24 h) después de terminado o cancelado;
  - después queda en solo lectura: 409 `CHAT_CLOSED` al enviar.
  - Función pura `chatWindow`.
- **Moderación por mensaje:** `ModerationService.check` antes de guardar.
  - Si coincide, el mensaje queda `retenido`: no se escribe en el outbox, no se entrega y solo lo ve quien lo envió.
  - La respuesta trae un aviso neutral: "Tu mensaje no se envió porque no cumple las normas de uso de SISI.".
  - El admin los ve en `GET /admin/chat/held`.
- **Entrega por outbox:** `chat.message_sent` (solo entregados). El worker emite `chat:message` a las dos partes, así lo ven también los otros dispositivos de quien lo envió.
- **Presencia en Redis (`PresenceService`):**
  - por usuario, un ZSET `presence:{userId}` con cada socket y su vencimiento (`PRESENCE_TTL_MS`, 60 s);
  - el gateway lo registra al conectar, lo renueva con un latido cada TTL/3 y lo quita al desconectar;
  - si una instancia cae sin desconectar, sus sockets vencen solos.
  - El worker manda el aviso con push **solo si el destinatario no está conectado**. Un fallo de Redis cuenta como desconectado: a lo sumo llega un push de más.
- **Historial:** `GET /jobs/:id/messages`, del más reciente al más antiguo, con cursor; trae `open`, `closesAt` y `unread`.
- **Lectura:** `POST /jobs/:id/messages/read {upToId}` marca como leídos los mensajes recibidos hasta ese mensaje (incluido). No hay evento de "leído" en tiempo real: no está en la lista de eventos del doc 02 §6.
- **Límite:** `RATE_CHAT_PER_MIN` (30) por usuario con `RateLimitStore` (ADR-0010).
- **Acceso:** solo las dos partes; a un tercero, 404. Los mensajes reportados se ocultan para quien los reportó (ADR-0033).

## Consecuencias
- La conversación queda en la base y moderada, sin exponer los teléfonos más de lo que ya expone el contacto.
- Un mensaje retenido no tiene "apelación" en el MVP: el admin solo lo ve. Liberar un retenido queda para la consola de la Fase 6.
- Plazo de la ventana e imágenes en el chat, en docs/pendientes.md.

## Actualización (Fase 6)
Un mensaje retenido se revisa en el panel: **liberar** (se entrega con su hora original, por el outbox) o **descartar** (estado `descartado`; para quien lo envió sigue como "no enviado"). Las dos acciones quedan en la auditoría.
