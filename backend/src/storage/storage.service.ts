export interface PresignedUpload {
  /** URL prefirmada; el cliente hace PUT con el archivo como cuerpo. */
  url: string;
  method: 'PUT';
  /** Headers que el cliente debe enviar tal cual (firmados). Content-Length lo pone el cliente. */
  headers: Record<string, string>;
  expiresAt: string;
}

export interface StoredObject {
  sizeBytes: number;
  contentType: string | undefined;
}

/**
 * Almacenamiento de archivos compatible con S3 (ADR-0012).
 * Producción: Cloudflare R2. Local y CI: RustFS. Todo el bucket es privado:
 * los archivos solo se leen con URLs firmadas de corta duración.
 */
export abstract class StorageService {
  abstract presignUpload(input: {
    key: string;
    contentType: string;
    sizeBytes: number;
    expiresInSec: number;
  }): Promise<PresignedUpload>;

  /**
   * URL firmada de descarga. `noStore`: el navegador no guarda la respuesta en su caché
   * (documentos de identidad, R9.5).
   */
  abstract presignDownload(
    key: string,
    expiresInSec: number,
    options?: { noStore?: boolean },
  ): Promise<string>;

  /** Metadatos del objeto, o null si no existe. */
  abstract head(key: string): Promise<StoredObject | null>;

  abstract delete(key: string): Promise<void>;
}
