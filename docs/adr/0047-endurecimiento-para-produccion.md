# ADR-0047: Endurecimiento para producción

- Estado: aceptada
- Fecha: 2026-10-18
- Fase: 7

## Contexto
Antes de abrir a usuarios reales hacía falta revisar cuatro frentes:
- la configuración con que arranca producción;
- la autorización objeto por objeto (IDOR);
- los límites de peticiones;
- los headers, y que no viajen secretos ni datos personales a logs, Sentry o builds web.

## Decisión
- **Arranque estricto (`APP_ENV=production`)**, además de lo de ADR-0011, ADR-0021 y ADR-0027:
  - `SENTRY_DSN` es obligatorio en api, worker y cron;
  - las URLs firmadas viven a lo sumo 900 s;
  - en la API, `CORS_ORIGINS` debe tener solo orígenes `https` sin comodines ni rutas, y `STORAGE_ENDPOINT` debe ser `https`;
  - Swagger no se publica;
  - el `ConsoleOtpProvider` se niega también en su constructor.
- **IDOR:** un e2e descubre las rutas de usuario con parámetro desde los metadatos de Nest y exige un caso para cada una, o una excepción explicada.
  - Prueba cada ruta con dos extraños (un empleador y un trabajador): 403 o 404, y el objeto no cambia.
  - También cubre ids ajenos en el body: claves de archivo de otro usuario y reportes sobre lo que uno no conoce.
  - No apareció ningún IDOR.
- **Límites:** `@RateLimit` acepta políticas por usuario (`per: 'user'`), aplicadas por `UserRateLimitGuard` después de la autenticación:
  - reportes: 10/h;
  - URLs de subida: 60/h;
  - dispositivos: 20/h;
  - eliminación de cuenta: 5/día;
  - interés del piloto: 10/h por IP.
- **Headers propios, sin dependencia:**
  - `nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: no-referrer`;
  - CSP `default-src 'none'` en la API;
  - `Cache-Control: no-store`;
  - HSTS en https;
  - sin `X-Powered-By`.
  - El handshake del socket rechaza un navegador de otro origen (CORS no protege un websocket); las apps nativas no envían Origin.
- **Vercel:** HSTS, `nosniff`, sin iframes y `Permissions-Policy` por app. La CSP sale en `Report-Only` hasta validarla en staging con Flutter, Maps y Firebase; `CSP_ENFORCE=true` la exige.
- **Datos personales:** `redact` enmascara teléfonos y direcciones, y quita JWT, Bearer, claves de archivo, fechas de nacimiento y códigos. Se usa:
  - en la respuesta de Bird;
  - en `dev-tools`;
  - en el logger JSON;
  - en Sentry (backend y apps): sin IP, cookies, headers, cuerpos ni query.
- **Secretos y dependencias** (`security.yml`):
  - gitleaks sobre todo el historial;
  - `npm audit` de producción con excepciones fechadas en `docs/seguridad/audit-excepciones.json`;
  - `deploy-web` revisa que el build web no lleve secretos de servidor.

## Consecuencias
- Un error de configuración se ve al arrancar, no con usuarios.
- Una ruta nueva con parámetro hace fallar el e2e de IDOR hasta que se le agregue su caso.
- La CSP real se exige recién después de verla en staging.
- **Pendiente:** el arreglo de la vulnerabilidad del CLI de Prisma es subir a 7.10.1, que trae scripts de instalación nuevos y espera aprobación (`docs/seguridad/dependencias.md`).
