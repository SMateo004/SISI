# Google Play: borrador del formulario de seguridad de datos y de la declaración de ubicación

> Borrador técnico (Fase 7, ADR-0054), armado con lo que la app recolecta **realmente** según el código. Lo revisa el responsable legal antes de enviarlo. Si cambia la app, se actualiza aquí y en Play Console.

## Resumen para Play Console

| Pregunta | Respuesta |
| --- | --- |
| ¿La app recolecta o comparte alguno de los tipos de datos requeridos? | Sí |
| ¿Todos los datos se cifran en tránsito? | Sí (HTTPS y WSS; HSTS en la web) |
| ¿Ofrecen una forma de pedir que se borren los datos? | Sí: en la app (Perfil → Acerca de → Eliminar mi cuenta) y en la web `https://<app-web>/eliminar-cuenta` |
| ¿La app es para niños? | No. Solo mayores de 18 (declaración en el registro; los trabajadores además verifican su fecha de nacimiento) |

**Compartir:** SISI no vende datos ni los comparte con terceros para su propio uso. Los proveedores que procesan datos en nombre de SISI no cuentan como "compartir" en Play:
- Bird: SMS;
- Google Firebase: avisos;
- Google Maps: mapas y geocodificación;
- Cloudflare R2: archivos;
- Render y Vercel: servidores;
- Sentry: errores.

Entre usuarios, la contraparte de un trabajo ve el nombre corto, la foto, la calificación y, durante el trabajo, el teléfono. Es la función de la app, no un "compartir" con terceros.

## Datos recolectados

| Categoría de Play | Dato | ¿Obligatorio? | Finalidad (Play) | Detalle |
| --- | --- | --- | --- | --- |
| Ubicación → Ubicación precisa | GPS del trabajador y punto de la solicitud | Trabajador: para recibir solicitudes. Empleador: para ubicar la solicitud | Funcionalidad de la app | Solo en primer plano (ver la declaración abajo). Se guarda la última posición del trabajador, sin historial; después de 30 días sin actividad se borra (propuesta) |
| Información personal → Nombre | Nombre | Opcional (exigible para trabajar, en propuesta) | Funcionalidad; gestión de la cuenta | Se muestra corto ("María P.") |
| Información personal → Número de teléfono | Celular (+591) | Obligatorio | Gestión de la cuenta (ingreso con código); funcionalidad (contacto durante un trabajo) | |
| Información personal → Otra info | Fecha de nacimiento (trabajadores) | Obligatorio para trabajar | Prevención de fraude, seguridad y cumplimiento | Mayoría de edad |
| Fotos y videos → Fotos | Carnet de identidad (anverso y reverso) y selfie | Obligatorio para trabajar | Prevención de fraude, seguridad y cumplimiento | Solo los ve el equipo de revisión, con enlaces de 5 minutos. Los de solicitudes rechazadas se borran a los 90 días (propuesta) |
| Fotos y videos → Fotos | Foto de perfil, fotos de solicitudes y comprobantes de pago | Opcional (comprobante: para pagar la comisión por QR) | Funcionalidad | |
| Mensajes → Otros mensajes en la app | Chat del trabajo, notas de cancelación, reportes y comentarios de calificaciones | Opcional | Funcionalidad; seguridad (moderación automática) | El chat se borra a los 180 días (propuesta) |
| Información financiera → Historial de compras | Comisiones y pagos registrados | Obligatorio para trabajar | Funcionalidad (cobro de la comisión) | Sin datos de tarjeta ni de cuenta bancaria: el pago es por QR fuera de la app |
| Identificadores del dispositivo u otros | Token de avisos (FCM) | Opcional (solo si activa los avisos) | Funcionalidad | |
| Información y rendimiento de apps → Registros de fallas | Informes de errores (Sentry) | Obligatorio (no se puede desactivar) | Análisis | Sin nombre, teléfono, IP ni contenido |

**No se recolecta:** contactos, calendario, archivos, audio, historial web, apps instaladas, publicidad ni salud.

## Declaración de ubicación (solo en primer plano)

- **Permisos declarados:** solo `ACCESS_FINE_LOCATION` y `ACCESS_COARSE_LOCATION`. **No** se pide `ACCESS_BACKGROUND_LOCATION` ni se usa un servicio en primer plano para ubicación.
- **Cuándo se usa:**
  - **Trabajador:** mientras activa "Disponible" con la app abierta, cada 30 s o al moverse 100 m. Sirve para avisarle de solicitudes cercanas y, durante un trabajo "en camino", para mostrarle al empleador el trayecto.
  - **Empleador:** para ubicar la solicitud en el mapa.
- **Explicación previa:** antes del diálogo del sistema, la app explica para qué se usa y que el empleador ve solo la distancia aproximada hasta que el trabajo está asignado.
- **Con la app cerrada no se usa la ubicación:** la disponibilidad vence a los 10 minutos sin ubicación. La ubicación en segundo plano está fuera del piloto (pendientes).

## Otros puntos de Play Console

| Punto | Respuesta |
| --- | --- |
| Acceso a la app | Para revisión: un número de prueba invitado al piloto con su código (lo entrega el equipo en el formulario, nunca en el repositorio) |
| Anuncios | No contiene anuncios |
| Clasificación de contenido | Servicios entre personas; chat entre usuarios moderado |
| Público objetivo | 18 años o más |
| Política de privacidad (URL) | Pendiente: la publica el responsable legal (texto en `backend/legal/politica-de-privacidad.md`) |
