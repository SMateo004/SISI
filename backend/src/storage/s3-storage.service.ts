import {
  DeleteObjectCommand,
  GetObjectCommand,
  HeadObjectCommand,
  NotFound,
  PutObjectCommand,
  S3Client,
  S3ServiceException,
} from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import type { Env } from '../config/env.schema';
import { type PresignedUpload, StorageService, type StoredObject } from './storage.service';

export type StorageEnv = Pick<
  Env,
  | 'STORAGE_ENDPOINT'
  | 'STORAGE_REGION'
  | 'STORAGE_FORCE_PATH_STYLE'
  | 'STORAGE_BUCKET'
  | 'STORAGE_ACCESS_KEY'
  | 'STORAGE_SECRET_KEY'
>;

/** Implementación S3 (R2, RustFS, AWS). Valida su configuración al crearse (arranque de la API). */
export class S3StorageService extends StorageService {
  private readonly client: S3Client;
  private readonly bucket: string;

  constructor(env: StorageEnv) {
    super();
    const missing = (
      ['STORAGE_BUCKET', 'STORAGE_ACCESS_KEY', 'STORAGE_SECRET_KEY'] as const
    ).filter((key) => !env[key]);
    if (missing.length > 0) {
      throw new Error(`Falta configurar el almacenamiento: ${missing.join(', ')}`);
    }
    this.bucket = env.STORAGE_BUCKET ?? '';
    this.client = new S3Client({
      endpoint: env.STORAGE_ENDPOINT,
      region: env.STORAGE_REGION,
      forcePathStyle: env.STORAGE_FORCE_PATH_STYLE,
      credentials: {
        accessKeyId: env.STORAGE_ACCESS_KEY ?? '',
        secretAccessKey: env.STORAGE_SECRET_KEY ?? '',
      },
      // Los checksums CRC por defecto del SDK v3 rompen las URLs prefirmadas en R2/RustFS.
      requestChecksumCalculation: 'WHEN_REQUIRED',
      responseChecksumValidation: 'WHEN_REQUIRED',
    });
  }

  async presignUpload(input: {
    key: string;
    contentType: string;
    sizeBytes: number;
    expiresInSec: number;
  }): Promise<PresignedUpload> {
    const url = await getSignedUrl(
      this.client,
      new PutObjectCommand({
        Bucket: this.bucket,
        Key: input.key,
        ContentType: input.contentType,
        ContentLength: input.sizeBytes,
      }),
      {
        expiresIn: input.expiresInSec,
        // Tipo y tamaño quedan firmados: subir otro tipo u otro tamaño da 403.
        signableHeaders: new Set(['content-type', 'content-length']),
      },
    );
    return {
      url,
      method: 'PUT',
      headers: { 'Content-Type': input.contentType },
      expiresAt: new Date(Date.now() + input.expiresInSec * 1000).toISOString(),
    };
  }

  presignDownload(key: string, expiresInSec: number): Promise<string> {
    return getSignedUrl(this.client, new GetObjectCommand({ Bucket: this.bucket, Key: key }), {
      expiresIn: expiresInSec,
    });
  }

  async head(key: string): Promise<StoredObject | null> {
    try {
      const res = await this.client.send(new HeadObjectCommand({ Bucket: this.bucket, Key: key }));
      return { sizeBytes: res.ContentLength ?? 0, contentType: res.ContentType };
    } catch (error) {
      if (error instanceof NotFound) return null;
      if (error instanceof S3ServiceException && error.$metadata.httpStatusCode === 404)
        return null;
      throw error;
    }
  }

  async delete(key: string): Promise<void> {
    await this.client.send(new DeleteObjectCommand({ Bucket: this.bucket, Key: key }));
  }
}
