# ADR-0012: Almacenamiento de archivos compatible con S3

- Estado: aceptada
- Fecha: 2026-10-14
- Fase: 1

## Contexto
Hay que guardar el carnet (ambos lados), la selfie y la foto de perfil. R9.5: los documentos son privados y solo se leen con enlaces temporales pedidos por un admin. Producción: Cloudflare R2. En local se pidió MinIO, pero MinIO Community fue archivado (abril de 2026) y su imagen ya no está en Docker Hub.

## Decisión
- Interfaz `StorageService` (presignUpload, presignDownload, head, delete) con una sola implementación, `S3StorageService` (AWS SDK v3), que sirve para R2, RustFS y AWS. Valida su configuración al arrancar la API; worker y cron no la cargan.
- **Local y CI: RustFS 1.0.1** (Apache 2.0, reemplazo de MinIO), en `${SISI_S3_PORT:-59000}` y la consola en `${SISI_S3_CONSOLE_PORT:-59001}`. Un contenedor `storage-init` (aws-cli 2.37.8) crea `sisi-local` y `sisi-test` con CORS para localhost:8080/8081. Antes de adoptarlo verifiqué:
  - el PUT prefirmado con tipo y tamaño correctos responde 200;
  - un tamaño o un tipo distinto responde 403;
  - CORS solo para los orígenes permitidos;
  - el GET anónimo responde 403.
- **Subida:** PUT prefirmado de 5 min con `Content-Type` y `Content-Length` **firmados**. No se usa POST prefirmado con condición de tamaño porque R2 no lo soporta. Después, el cliente confirma y la API hace `HEAD` para verificar existencia, tipo, tamaño y que la clave sea del prefijo del usuario.
- **Política de archivos:** JPEG, PNG y HEIC hasta 8 MB (propuesta). Claves impredecibles (`{prefijo}{tipo}-{uuid}.{ext}`).
- **Un bucket privado con prefijos:**
  - `identity/{userId}/…`: carnet y selfie. Solo `GET /admin/workers/{id}/documents/{doc}/url` (rol admin) entrega un enlace de 5 min. El trabajador ve el estado de cada documento, nunca la imagen ni la clave.
  - `avatars/{userId}/…`: foto de perfil, devuelta firmada por 1 h en `/me`.
- `requestChecksumCalculation/responseChecksumValidation: WHEN_REQUIRED`, porque los checksums CRC por defecto del SDK v3 rompen las URLs prefirmadas en R2 y RustFS.
- Reemplazar un documento o la foto borra el objeto anterior.

## Consecuencias
- Si RustFS dejara de servir, se cambia la imagen (SeaweedFS era la alternativa evaluada) sin tocar código.
- R2 necesita su propia regla de CORS con los dominios de la app web (paso manual).
- Las fotos de perfil, si más adelante deben verse sin firma (otros usuarios, caché), pueden ir a un bucket público o CDN separado.
