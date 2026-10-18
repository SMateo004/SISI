# ADR-0051: Textos legales con versión y consentimiento

- Estado: aceptada (textos pendientes de revisión legal)
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Para el piloto hacen falta términos de uso y política de privacidad aceptados, con prueba de qué versión aceptó cada persona y cuándo. También una declaración de mayoría de edad y explicaciones antes de pedir permisos. Los textos finales los redacta un abogado: mientras tanto no puede salir un build de producción con borradores.

## Decisión
- **Fuente:** `backend/legal/*.md`, con un encabezado (`type`, `version`, `title`).
  - El seed los carga en `legal_documents`.
  - Una versión final nunca se pisa: cambiarla exige subir la versión.
  - Un borrador (con el marcador `PENDIENTE DE REVISIÓN LEGAL`) sí se puede reemplazar.
- **Aceptación:** `legal_acceptances` es append-only (trigger, como el ledger) y guarda usuario, tipo, versión, fecha, declaración de mayoría de edad, versión de la app y plataforma.
- **API:**
  - `GET /legal/current` (público);
  - `POST /me/legal/accept {termsVersion, privacyVersion, adult: true}`: 409 si salió otra versión mientras se leía, y la mayoría de edad es obligatoria;
  - `GET /me` devuelve `legalPending`.
- **`LegalGuard`:** con textos vigentes sin aceptar, una sesión de la app recibe 403 `LEGAL_ACCEPTANCE_REQUIRED`. Solo puede:
  - ver su cuenta;
  - leer y aceptar los textos;
  - registrar o quitar su dispositivo;
  - salir;
  - eliminar la cuenta.

  El panel (`aud=admin`) no pasa por aquí. Una versión nueva vuelve a pedir la aceptación.
- **App:** pantalla bloqueante con los dos textos (banner rojo si son borradores), "Acepto…" y "Declaro ser mayor de 18 años". Los textos se leen también desde "Acerca de".
- **Producción no sale con borradores:**
  - `tools/check-legal.mjs` corre en `deploy-production` y en `mobile-release`;
  - la API con `APP_ENV=production` no arranca si un texto vigente es borrador o falta.
- **Textos v0 del piloto cerrado** (decisión del 2026-10-18):
  - mientras no estén los textos del abogado, el piloto usa una versión "v0" revisada por el dueño del producto, que dice explícitamente que es un piloto cerrado con usuarios invitados;
  - se marca con `stage: piloto-cerrado` en el encabezado del archivo, que el seed copia a `legal_documents.pilot_only`; la app la muestra con el aviso "Versión v0 del piloto cerrado";
  - **solo vale con la lista de teléfonos del piloto activa.** En producción, mientras algún texto vigente sea del piloto:
    - el seed (en cada deploy) enciende `pilot.closed` en la ciudad por defecto; nunca lo apaga;
    - la API no arranca si `pilot.closed` está apagado (se lee de la base, sin la caché);
    - el panel no deja apagarlo: 409 `PILOT_TEXTS_ACTIVE`;
    - el ingreso se trata como cerrado aunque el flag falte (falla cerrado);
  - se aprueba borrando la línea de revisión (lleva el marcador, así que hasta entonces es borrador); los definitivos van como versión 2 sin `stage` y liberan el flag.
- **Permisos explicados antes de pedirlos:**
  - **ubicación:** al ponerse disponible; se recuerda la respuesta;
  - **cámara:** antes de la primera foto;
  - **avisos:** tarjeta en el inicio; recién con "Activar" se pide el permiso (`POST_NOTIFICATIONS` en Android 13+).

## Consecuencias
- Sin los textos aprobados no hay producción ni AAB de producción. Es intencional y bloquea el lanzamiento (pendientes).
- Con los textos v0, producción solo puede funcionar como piloto cerrado. Abrir el piloto exige publicar los definitivos (que piden aceptarlos de nuevo a todos).
- Las aceptaciones son evidencia: no se modifican ni se borran, ni siquiera al eliminar la cuenta.
