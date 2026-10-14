import { randomUUID } from 'node:crypto';
import { HttpStatus } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { StoredObject } from './storage.service';

/** Tipos permitidos (propuesta aprobada para el MVP): fotos JPEG, PNG y HEIC. */
export const ALLOWED_IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/heic'] as const;
export type AllowedImageType = (typeof ALLOWED_IMAGE_TYPES)[number];

const EXTENSIONS: Record<AllowedImageType, string> = {
  'image/jpeg': 'jpg',
  'image/png': 'png',
  'image/heic': 'heic',
};

/** Prefijos del bucket privado (ADR-0012). identity/ solo lo lee un admin (R9.5). */
export const STORAGE_PREFIX = {
  identity: (userId: string) => `identity/${userId}/`,
  avatars: (userId: string) => `avatars/${userId}/`,
} as const;

export function isAllowedImageType(value: string): value is AllowedImageType {
  return (ALLOWED_IMAGE_TYPES as readonly string[]).includes(value);
}

export function assertUploadAllowed(
  contentType: string,
  sizeBytes: number,
  maxBytes: number,
): void {
  if (!isAllowedImageType(contentType)) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'UPLOAD_TYPE_NOT_ALLOWED',
      'Solo se aceptan fotos JPEG, PNG o HEIC.',
    );
  }
  if (!Number.isInteger(sizeBytes) || sizeBytes <= 0) {
    throw new ApiError(HttpStatus.BAD_REQUEST, 'UPLOAD_EMPTY', 'La foto está vacía.');
  }
  if (sizeBytes > maxBytes) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'UPLOAD_TOO_LARGE',
      `La foto pesa más de ${Math.round(maxBytes / (1024 * 1024))} MB.`,
    );
  }
}

/** Clave nueva e impredecible dentro del prefijo del usuario. */
export function newObjectKey(prefix: string, contentType: AllowedImageType, name?: string): string {
  return `${prefix}${name ? `${name}-` : ''}${randomUUID()}.${EXTENSIONS[contentType]}`;
}

/**
 * Confirma una subida: la clave debe ser del prefijo del usuario y el objeto debe
 * existir con tipo y tamaño válidos (defensa adicional a la firma de la URL).
 */
export function assertUploadedObject(
  key: string,
  expectedPrefix: string,
  object: StoredObject | null,
  maxBytes: number,
): { sizeBytes: number; contentType: AllowedImageType } {
  if (!key.startsWith(expectedPrefix) || key.includes('..')) {
    throw new ApiError(
      HttpStatus.FORBIDDEN,
      'UPLOAD_KEY_FORBIDDEN',
      'Ese archivo no te pertenece.',
    );
  }
  if (!object) {
    throw new ApiError(
      HttpStatus.BAD_REQUEST,
      'UPLOAD_NOT_FOUND',
      'No encontramos la foto. Vuelve a subirla.',
    );
  }
  const contentType = object.contentType ?? '';
  assertUploadAllowed(contentType, object.sizeBytes, maxBytes);
  return { sizeBytes: object.sizeBytes, contentType: contentType as AllowedImageType };
}
