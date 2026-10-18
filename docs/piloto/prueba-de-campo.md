# Guion de la prueba de campo (Santa Cruz)

> Fase 7. Hasta ahora la ubicación se probó simulada. Esta prueba confirma con teléfonos reales lo que depende del GPS, la batería, la red y el sistema operativo. Planilla: `prueba-de-campo-resultados.csv` (una fila por caso y teléfono).

## Preparación

**Teléfonos:** 2 o 3 Android reales, de gama baja y media (ejemplo: uno con 3 GB de RAM y Android 11, otro con Android 13 o 14), de operadoras distintas (Tigo, Entel, Viva).

**App:** el APK firmado de `mobile-release`, contra **staging** (o producción, si ya existe, con números invitados).
- En cada teléfono: "Opciones de desarrollador" para ver el uso de batería por app, y sin ahorro de batería extremo.

**Cuentas:**
- **T1 y T2:** trabajadores aprobados en Plomería.
- **E1:** empleador.
- Un admin con el panel abierto en una computadora.

**Lugares** (elegir 5 puntos conocidos con su coordenada tomada de Google Maps):
- Plaza 24 de Septiembre;
- un punto del 2.º anillo;
- un punto del 4.º anillo;
- una calle con edificios altos;
- una zona abierta.

**Antes de salir:**
- relojes de los teléfonos en hora automática;
- batería al 100 %;
- anotar el modelo, la versión de Android y la operadora en la planilla.

## Casos

### A. GPS real y precisión
1. **A1.** En cada uno de los 5 puntos, T1 activa "Disponible". En el panel (o en la base), anotar la coordenada que llegó y calcular la distancia al punto real.
   - **Esperado:** menos de 30 m al aire libre y menos de 80 m entre edificios.
2. **A2.** T1 camina 300 m.
   - **Esperado:** la ubicación se actualiza al moverse 100 m o cada 30 s.
3. **A3.** E1 publica a 1 km de T1.
   - **Esperado:** a T1 le llega la solicitud con una distancia coherente (± 15 %). El ETA se compara con el real en el caso F.

### B. Batería durante 1 hora disponible
4. **B1.** T1 con "Disponible" 1 hora, con la pantalla encendida (brillo medio) y la app en primer plano. Anotar la batería al inicio y al final, y el uso de la app según Android.
5. **B2.** Igual, con la pantalla apagada a los 30 s: la app deja de mandar ubicación (solo primer plano).
   - **Esperado:** sin consumo de GPS, y después de 10 minutos la disponibilidad vence. Confirmar en el panel que T1 ya no figura como disponible.
6. **Esperado:** en B1, un consumo menor al 15 % por hora en gama media. Si es mayor, anotar el modelo para revisar `WORKER_LOCATION_PERSIST_*`.

### C. Push con la app cerrada
7. **C1.** T2 con los avisos activados ("Activar" en la tarjeta del inicio). Cerrar la app (quitarla de recientes).
   - E1 publica una solicitud cerca. **Esperado:** el aviso llega en menos de 10 s y, al tocarlo, abre la solicitud.
   - Repetir con el teléfono bloqueado 5 minutos.
8. **C2.** Igual, con la app en segundo plano: el aviso llega.
9. **C3.** Aviso de oferta para E1, con su app cerrada.
10. **C4.** En un teléfono con ahorro de batería del fabricante (Xiaomi, Samsung): anotar si el aviso se retrasa o no llega.

### D. Reconexión al perder la señal
11. **D1.** T1 disponible con la app abierta. Modo avión 2 minutos y desactivarlo.
    - **Esperado:** el socket reconecta solo, la ubicación vuelve a enviarse y las solicitudes publicadas durante el corte aparecen (por la lista; no se pierden).
12. **D2.** Igual, con 10 minutos de modo avión.
    - **Esperado:** la disponibilidad vence (10 min sin ubicación). Al volver, la app lo muestra y se puede reactivar.
13. **D3.** Con un chat abierto, E1 envía 3 mensajes durante el corte. **Esperado:** llegan al reconectar, en orden.

### E. Cambio entre datos móviles y WiFi
14. **E1.** Con un trabajo "en camino", pasar de WiFi a datos y de datos a WiFi.
    - **Esperado:** no se cierra la sesión, el seguimiento del trayecto sigue y el chat no pierde mensajes.

### F. Flujo completo hasta la comisión
15. **F1.** E1 publica en Plomería (precio sugerido).
    1. T1 y T2 ofertan; T2 contraoferta.
    2. E1 elige a T1.
    3. Anotar el tiempo a la primera oferta.
    4. T1 avanza a "En camino", con seguimiento en el mapa del empleador, y luego a "Empecé".
    5. Chatean.
    6. T1 marca "Terminé" y E1 confirma.
    7. Se califican.
16. **F2.** En Ganancias, T1 ve la comisión del trabajo (13 % redondeado), su referencia y el QR.
17. **F3.** T1 paga por QR (monto real chico, o simulado en staging) y sube el comprobante.
    - En el panel, el admin lo registra. **Esperado:** el saldo baja y T1 recibe el aviso.
18. **F4.** Comparar el ETA estimado con el tiempo real de llegada.

## Al terminar
- Completar la planilla, con capturas o videos como evidencia (nombre del archivo en la columna "evidencia").
- Revisar Sentry: errores de la app durante la prueba, por modelo de teléfono.
- **Resultado esperado:** todos los casos "ok" o con un pendiente anotado. Ajustes probables:
  - `ETA_SPEEDS_KMH` y `ETA_ROUTE_FACTOR`, con los tiempos reales;
  - `WORKER_LOCATION_PERSIST_*`, si la batería no alcanza;
  - instrucciones de "ahorro de batería" para los trabajadores, si el push se retrasa en algún fabricante.
