import type { PresignedUploadDto } from '../../src/storage/dto/upload.dto';

/** JPEG mínimo válido (cabecera SOI/EOI) rellenado hasta `size` bytes. */
export function fakeJpeg(size = 2048): Buffer {
  const body = Buffer.alloc(size, 0x20);
  body[0] = 0xff;
  body[1] = 0xd8;
  body[size - 2] = 0xff;
  body[size - 1] = 0xd9;
  return body;
}

/** Sube el archivo como lo haría la app: PUT directo al almacenamiento con la URL prefirmada. */
export async function putPresigned(upload: PresignedUploadDto, body: Buffer): Promise<number> {
  const res = await fetch(upload.uploadUrl, {
    method: upload.method,
    headers: upload.headers,
    body: new Uint8Array(body),
  });
  return res.status;
}
