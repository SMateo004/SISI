# SISI — Reglas de negocio

> Fuente única de verdad para las reglas. El plan de negocio y el código deben respetarlas. Si una regla cambia, se cambia aquí primero. Valores marcados (propuesta) aún deben validarse.

## R1. Cuentas y modos
- R1.1 Cada persona tiene **una sola cuenta** identificada por su número de teléfono.
- R1.2 Toda cuenta nueva inicia en **modo empleador**.
- R1.3 El modo trabajador requiere **upgrade**: carnet de identidad (anverso y reverso), selfie, teléfono verificado, mayoría de edad, categorías elegidas, medio de transporte y radio máximo de trabajo. **Además, la cuenta debe tener su nombre cargado** (aprobado el 2026-10-18, Fase 7): sin nombre no se envía la solicitud de trabajador ni se pasa a modo trabajador, aunque el perfil ya esté aprobado. El empleador ve el nombre corto del trabajador en cada oferta (R5.3).
- R1.4 Estados del perfil de trabajador: `sin_solicitar`, `pendiente_revision`, `aprobado`, `rechazado`, `bloqueado_deuda`, `suspendido_moderacion`.
- R1.5 El interruptor de modo solo cambia a trabajador si el estado es `aprobado`. En otro caso muestra el motivo.
- R1.6 Un trabajador bloqueado puede seguir usando la app como empleador.

## R2. Categorías
- R2.1 Lista cerrada administrada por la empresa. No existen categorías libres.
- R2.2 Cada categoría tiene: nombre, descripción, rango de precio de referencia (mín–máx en Bs), comisión (por defecto 13 %), requisitos extra de verificación, ciudad(es) donde está activa y si está activa.
- R2.3 Solo se publican **servicios**; está prohibida la venta de productos.

## R3. Solicitudes y precio
- R3.1 El empleador elige categoría, describe el trabajo, puede adjuntar fotos, fija la ubicación y **propone un precio**.
- R3.2 La app muestra el rango de referencia de la categoría y advierte si el precio está por debajo del mínimo.
- R3.3 Toda solicitud pasa por el filtro de moderación antes de enviarse a trabajadores. Si coincide con términos prohibidos queda `retenida` para revisión.
- R3.4 Estados de solicitud: `borrador`, `retenida`, `buscando`, `con_ofertas`, `asignada`, `cancelada`, `expirada`.
- R3.5 El precio ofertado **incluye el traslado** del trabajador.

## R4. Matching por cercanía (valores en propuesta)
- R4.1 Candidatos: trabajadores `aprobado`, disponibles, de esa categoría, cuya distancia ≤ su radio máximo y no bloqueados.
- R4.2 Envío por anillos: anillo 1 = 5 más cercanos ≤ 2 km; anillo 2 ≤ 5 km; anillo 3 ≤ 10 km.
- R4.3 Cada anillo espera 45 s antes de ampliar si no hay ofertas suficientes.
- R4.4 Orden dentro del anillo: distancia, y como desempate calificación.
- R4.5 Si tras el último anillo no hay ofertas, la solicitud queda `expirada` y se avisa al empleador.

## R5. Ofertas
- R5.1 El trabajador ve distancia, descripción, fotos y precio propuesto antes de ofertar.
- R5.2 Puede **aceptar el precio** o **contraofertar** un monto.
- R5.3 El empleador ve las ofertas en vivo con precio, calificación y tiempo estimado de llegada, y elige una.
- R5.4 Al aceptarse una oferta, las demás se cierran y se revelan datos de contacto entre las dos partes.

## R6. Trabajo
- R6.1 Estados: `asignado` → `en_camino` → `en_curso` → `terminado`; o `cancelado`.
- R6.2 El empleador confirma el término. Ambos se califican (1–5 estrellas + comentario).
- R6.3 Al pasar a `terminado` se calcula la comisión: `comision = precio_final × porcentaje_categoria` y se registra en el ledger del periodo actual.

## R7. Comisiones, cortes y pagos
- R7.1 Comisión por defecto: **13 %**, solo al trabajador.
- R7.2 Corte semanal: domingo 23:59 (hora de Bolivia, UTC−4). (propuesta)
- R7.3 Fecha límite de pago: miércoles 23:59 siguiente al corte. (propuesta)
- R7.4 Medio de pago MVP: QR bancario con **referencia única por corte**; la empresa registra el pago con comprobante. Fase 2: pasarela automática.
- R7.5 Tope de deuda: si la comisión pendiente supera 150 Bs antes del corte, se exige pago para seguir recibiendo solicitudes. (propuesta)
- R7.6 Avisos: al cerrar el corte, 24 h antes del vencimiento y el día del vencimiento.
- R7.7 Vencido sin pago → estado `bloqueado_deuda`. Pago confirmado → desbloqueo automático.
- R7.8 Estados de corte: `abierto`, `cerrado_pendiente`, `pagado`, `vencido`.
- R7.9 **Ledger inmutable:** tipos de movimiento `comision`, `pago`, `ajuste`. Nunca se edita ni borra; se corrige con un `ajuste`.

## R8. Perfil y ganancias del trabajador
- R8.1 Muestra: ganado en el periodo (bruto), comisión del periodo, neto, saldo pendiente y fecha límite.
- R8.2 Historial de pagos: periodo, monto, fecha de pago, estado, comprobante.
- R8.3 Historial de trabajos con monto y comisión de cada uno.

## R9. Moderación y seguridad
- R9.1 Prohibido: servicios sexuales, drogas, armas, actividades ilegales o inmorales, venta de productos.
- R9.2 Filtro de texto en solicitudes y chat; coincidencias se retienen.
- R9.3 Reportes en solicitudes, perfiles y chat; 3 reportes válidos → `suspendido_moderacion` hasta revisión.
- R9.4 Contacto oculto hasta aceptar una oferta; chat dentro de la app.
- R9.5 Documentos de identidad privados, accesibles solo por enlaces temporales para el administrador.

## R10. Escala (mega app)
- R10.1 Toda entidad relevante lleva `city_id`; precios, comisiones y categorías pueden variar por ciudad.
- R10.2 Funciones nuevas (pago en app, agendados, cuentas empresa) se encienden con feature flags.
