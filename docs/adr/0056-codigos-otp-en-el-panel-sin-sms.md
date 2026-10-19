# ADR-0056: Códigos de ingreso en el panel mientras no hay SMS

- Estado: aceptada
- Fecha: 2026-10-19
- Fase: 7

## Contexto
Staging usa `OTP_PROVIDER=console` porque el proveedor de SMS todavía no está configurado (ADR-0011). Así, el código de cada ingreso solo aparece en los logs de Render, y para probar la app con varias personas (empleadores y trabajadores) alguien tiene que buscarlo ahí. El dueño del producto pidió (2026-10-19) verlos en el panel, por usuario y en tiempo real.

## Decisión
- **Copia en Redis:** cuando el código sale por el proveedor de consola, `OtpService` guarda una copia en claro en Redis (`ConsoleOtpFeed`, clave `console-otp:feed`, un hash por teléfono).
  - Dura lo que el código (`OTP_TTL_SEC`); al usarse se marca como usado.
  - La copia está fuera del espacio `otp:*`, que sigue guardando solo el hash (ADR-0009). El e2e de autenticación lo verifica y nombra esta excepción.
- **Endpoint:** `GET /admin/otp-codes` (permiso `usuarios`) devuelve los códigos vigentes con teléfono, nombre, modo (empleador o trabajador) o "registro nuevo", hora del pedido, vencimiento y uso.
- **Pantalla "Códigos OTP"** en el panel. Se actualiza cada 3 s, consultando la lista cada vez (polling), sin agregar un evento de tiempo real: el catálogo de eventos de doc 02 §6 no cambia.
- **Nunca en producción ni con SMS real.** `ConsoleOtpFeed.enabled` exige `OTP_PROVIDER=console` y `APP_ENV` distinto de `production`. Si no se cumple, no guarda nada y el endpoint devuelve `enabled: false` con la lista vacía. Además, el proveedor de consola no puede construirse en producción (ADR-0011, ADR-0047).

## Consecuencias
- Se prueba staging con varias personas sin pasar por los logs de Render.
- Quien entra al panel puede ingresar a cualquier cuenta de staging con su código. Ya era así con acceso a los logs; staging sigue sin ser para usuarios reales (runbook).
- Los códigos de eliminación de cuenta pasan por el mismo `OtpService`, así que también se ven.
- Al configurar Bird (`OTP_PROVIDER=bird`), la pantalla queda vacía sola, sin cambiar código.
