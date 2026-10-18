# ADR-0054: Apps en tiendas: firma, versión mínima, "Acerca de" e iOS

- Estado: aceptada
- Fecha: 2026-10-18
- Fase: 7

## Contexto
La app Android tiene que llegar a la pista de pruebas internas de Google Play. Hasta ahora el release se firmaba con la llave de debug. Además, el piloto necesita poder obligar a actualizar una versión con errores. iOS espera la cuenta de Apple, pero el proyecto debe quedar listo.

## Decisión
- **Firma de Android:**
  - upload key fuera del repositorio: `android/key.properties` en una máquina, o variables en CI (`ANDROID_KEYSTORE_*`, el keystore en base64 en un secreto del Environment `production`);
  - Google Play App Signing firma lo que se publica;
  - con `SISI_REQUIRE_RELEASE_SIGNING=true` (mobile-release), Gradle falla si falta la llave;
  - el workflow verifica con `apksigner` que el APK no quedó firmado con debug.
- **Identificador y nombre** configurables (`-PAPP_ID`, `-PAPP_NAME`, desde variables del Environment): el identificador no se puede cambiar después de publicar y depende del nombre comercial.
- **mobile-release:** con un tag sobre `main` o a mano.
  - Antes de compilar: textos legales finales y versión igual al tag.
  - Produce AAB y APK firmados, con versión y build del pubspec y Sentry.
  - La primera subida a Play Console es manual.
  - `mobile-ci` compila un APK de debug en cada cambio, para validar Gradle.
- **Versión mínima:**
  - `APP_MIN_VERSION_ANDROID`, `_IOS` y `_WEB` en `app_settings`;
  - la app envía `X-App-Platform` y `X-App-Version`;
  - una versión menor recibe 426 `APP_UPGRADE_REQUIRED` en todo, salvo configuración, salud, textos legales y eliminación de cuenta;
  - la app muestra "Actualiza la app" con el enlace a la tienda (`APP_STORE_URL_*`);
  - `GET /app/config?platform&version` lo anticipa al abrir;
  - sin headers (panel, scripts, desarrollo) no se aplica.
- **"Acerca de":** versión y build por `--dart-define=APP_VERSION/APP_BUILD` (sin `package_info_plus`), ambiente fuera de producción, textos legales, ayuda por WhatsApp y "Eliminar mi cuenta".
- **iOS:** bundle `bo.sisi.sisiMobile` (provisional), textos de permisos revisados, `UIBackgroundModes: remote-notification` y `Runner.entitlements` con `aps-environment`. El push en iOS se enciende con `--dart-define=IOS_PUSH=true` cuando la llave APNs esté en Firebase. TestFlight espera la cuenta de Apple.

## Consecuencias
- Un release mal firmado no sale.
- El ícono, el splash, el nombre y el identificador definitivos esperan el nombre comercial: hoy siguen los de Flutter y "SISI".
- Para el push en iOS, al tener la cuenta, hay que enlazar los entitlements en Xcode (Signing & Capabilities → Push Notifications) y cargar la llave APNs.
