# SISI — Contexto general del proyecto

> Documento maestro. Toda conversación de este proyecto (plan de negocio o desarrollo con Claude Code) debe partir de aquí. "SISI" es el nombre de trabajo del proyecto; el nombre comercial final está pendiente.
> Última actualización: 13 de octubre de 2026.

## 1. Qué es

SISI es una **app de servicios inmediatos** tipo inDrive, pensada para Bolivia (lanzamiento en Santa Cruz de la Sierra). Quien necesita un trabajo (plomería, electricidad, limpieza, garzón, cuidado del hogar, etc.) publica una solicitud; los **trabajadores más cercanos** la reciben primero y ofertan; el empleador elige.

- **Se venden servicios, nunca productos.**
- **Una sola cuenta, dos modos:** todo usuario entra como **empleador** y puede hacer *upgrade* a **trabajador** (previa verificación). Cambia de modo con un interruptor deslizable.
- **La empresa gana por comisión** cobrada al trabajador. Si el trabajador no paga en la fecha, se bloquea su modo trabajador hasta que pague.
- **Visión a largo plazo:** convertirse en una **mega app / super app de servicios** (más verticales, servicios agendados, pago en app, cuentas empresa, multi-ciudad y multi-país).

## 2. Actores

| Actor | Qué hace |
| --- | --- |
| Empleador | Publica solicitudes, propone precio, recibe ofertas, elige, califica. Paga directo al trabajador (efectivo o QR) en el MVP. |
| Trabajador | Usuario verificado. Recibe solicitudes cercanas de sus categorías, acepta o contraoferta, realiza el trabajo, paga comisión a la empresa. |
| Administrador (la empresa) | Aprueba verificaciones, modera reportes y solicitudes retenidas, gestiona categorías y precios de referencia, registra pagos, bloquea/desbloquea. |

## 3. Decisiones de negocio ya tomadas

- **Comisión: 13 %** del precio acordado, pagada solo por el trabajador. El empleador no paga extra en el MVP.
  - Ejemplo: trabajo de 150 Bs → comisión 19,50 Bs → el trabajador recibe 130,50 Bs.
- **Precio híbrido tipo inDrive:** el empleador propone precio; la app muestra un **rango de referencia** por categoría; los trabajadores aceptan o contraofertan; el empleador elige.
- **Transporte:** el trabajador se mueve por su cuenta. La app muestra la distancia antes de ofertar; **el precio ofertado incluye el traslado**. Fase posterior: recargo automático por distancia pasado cierto radio.
- **Pago del servicio en el MVP:** directo del empleador al trabajador. La empresa no toca ese dinero.
- **Cobro de comisión:** corte semanal (domingo 23:59), pago hasta el miércoles siguiente, por **QR bancario con referencia única** por corte. **Pasarela automática en la segunda fase.**
- **Tope de deuda:** si la comisión acumulada supera un tope (propuesta 150 Bs) antes del corte, se pide pagar para seguir recibiendo trabajos.
- **Bloqueo:** vencida la fecha sin pago se desactiva **solo el modo trabajador**; sigue pudiendo usar la app como empleador. Desbloqueo automático al confirmarse el pago.
- **Perfil del trabajador muestra:** ganado en el periodo (bruto y neto), comisión acumulada, fecha límite de pago e **historial de pagos** a la empresa (periodo, monto, fecha, estado, comprobante).
- **Registro contable inmutable:** los movimientos (ledger) nunca se editan ni se borran; las correcciones son movimientos nuevos.

## 4. Servicios prohibidos y seguridad

Prohibido: prostitución o servicios sexuales, venta o entrega de drogas, armas, cualquier actividad ilegal o inmoral, y venta de productos.

Controles:
- Categorías **cerradas** (lista definida por la empresa); no hay categorías de texto libre.
- Filtro de palabras y patrones en descripciones y chat → retiene para revisión.
- Botón de reporte en solicitudes, perfiles y chat; 3 reportes válidos suspenden hasta revisión.
- Verificación del trabajador: carnet de identidad (ambos lados), selfie, teléfono, mayor de 18 años.
- Datos de contacto ocultos hasta aceptar una oferta; chat dentro de la app.
- Términos de uso que prohíben estos servicios.
- Panel de moderación para la empresa.

## 5. Mercado inicial y categorías

Una ciudad (Santa Cruz de la Sierra) y 4–6 categorías al inicio:

| Categoría | Ejemplos |
| --- | --- |
| Plomería | Fugas, destapes, grifería |
| Electricidad | Tomacorrientes, cortocircuitos, luminarias |
| Limpieza | Casas, oficinas, post-obra, vidrios |
| Cuidado del hogar | Jardinería, pintura, armado de muebles |
| Eventos | Garzón, ayudante de cocina, bartender |
| Mudanzas y carga | Cargadores, ayudantes |

Cuidado de niños, adultos mayores y mascotas: solo en etapas posteriores y con antecedentes verificados.

## 6. Visión mega app (etapas)

| Etapa | Cuándo | Qué se suma |
| --- | --- | --- |
| 1. Servicios inmediatos | MVP, una ciudad | 4–6 categorías, ofertas tipo inDrive, comisión 13 %, cobro semanal |
| 2. Crecimiento | Meses 4–12 | Más categorías, servicios agendados, pago en app, billetera, niveles de trabajador, 2.ª y 3.ª ciudad |
| 3. Mega app | Año 2+ | Cuentas empresa, suscripciones, garantía y seguro, academia/certificaciones, publicidad, multi-país |

Verticales futuras: hogar, limpieza, eventos, técnicos (celulares, PC, electrodomésticos, aire acondicionado), vehículos (mecánico a domicilio, auxilio), belleza a domicilio, clases, mascotas, cuidado de personas.

Funciones mega app: inmediato + agendado, trabajos por hora o jornada, equipos (pedir 5 garzones), cuentas empresa, billetera y pago en app, niveles de trabajador con comisión menor, garantía de la plataforma, asistente con IA (sugiere categoría y precio, filtra prohibidos), referidos, academia. Cada vertical se activa desde el panel admin sin publicar versión nueva.

## 7. Stack técnico (resumen)

- **App:** Flutter (Android, iOS y web) + Riverpod + go_router.
- **Panel admin:** Flutter web en el mismo monorepo.
- **Backend:** Node.js + NestJS (TypeScript), monolito modular.
- **Base de datos:** PostgreSQL + PostGIS (consultas por distancia). ORM Prisma + SQL directo para lo geográfico.
- **Tiempo real:** Socket.IO (con adaptador Redis para varias instancias).
- **Colas y caché:** Redis-compatible + BullMQ.
- **Push:** Firebase Cloud Messaging. **Mapas:** Google Maps o Mapbox. **Archivos:** S3 / Cloudflare R2.
- **Login:** teléfono + código (SMS/WhatsApp), JWT.

## 8. Despliegue

- **Backend en Render:** Web Service `api` (NestJS + Socket.IO), Background Worker `worker` (BullMQ), Cron Job `billing-cron` (corte semanal y bloqueos), Render Postgres (con `CREATE EXTENSION postgis;`), Render Key Value (Redis-compatible, política *noeviction* para colas). Todo definido en `render.yaml`.
- **Frontend web en Vercel:** dos proyectos, `app-web` (app.tudominio.com) y `admin` (admin.tudominio.com). Flutter web compilado en GitHub Actions y subido a Vercel; `vercel.json` redirige rutas a `index.html`.
- **Apps móviles:** Google Play y App Store, apuntando a la API en Render.
- Ambientes `staging` (rama develop) y `production` (rama main).

## 9. Organización del trabajo

- **Tiempo 1 — Plan de negocio (4–6 semanas):** validación con trabajadores y empleadores reales, rangos de precio, reglas cerradas, Business Model Canvas, términos legales, proyección.
- **Tiempo 2 — Desarrollo con Claude Code (12–16 semanas):** fases 0 a 7 (base, cuentas, solicitudes, matching y ofertas, trabajo, cobros, admin, piloto).

## 10. Decisiones pendientes

- [ ] Nombre comercial y marca.
- [ ] Día de corte, plazo de pago y tope de deuda definitivos.
- [ ] Zonas exactas del lanzamiento.
- [ ] Categorías iniciales finales y rangos de precio de referencia (en Bs).
- [ ] Si habrá suscripción como alternativa a la comisión.
- [ ] Revisión legal y tributaria (empresa, facturación de la comisión, relación con trabajadores independientes, datos personales).

## 11. Documentos del proyecto

- `00-contexto-general-SISI.md` — este documento.
- `01-reglas-de-negocio.md` — reglas exactas para el plan de negocio y para el código.
- `02-contexto-tecnico-claude-code.md` — arquitectura, estructura, modelo de datos, fases y CLAUDE.md.
- `03-herramientas-y-cuentas.md` — software, servicios y cuentas necesarias.
- Plan completo con diagramas: https://claude.ai/code/artifact/947ccf26-d6fc-4aa0-bcd7-ff494303b9b1
