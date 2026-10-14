import request from 'supertest';
import type { PresignedUploadDto } from '../src/storage/dto/upload.dto';
import type { UserDto } from '../src/users/dto/user.dto';
import { bearer, createTestApp, login, type TestApp } from './utils/test-app';
import { fakeJpeg, putPresigned } from './utils/upload';

describe('Mi cuenta (e2e)', () => {
  let t: TestApp;
  const server = () => t.app.getHttpServer();

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t.close();
  });

  it('GET y PATCH /me (nombre)', async () => {
    const { accessToken } = await login(t);
    const res = await request(server())
      .patch('/me')
      .set(...bearer(accessToken))
      .send({ name: '  María   Pérez ' })
      .expect(200);
    expect((res.body as UserDto).name).toBe('María Pérez');
    const me = await request(server())
      .get('/me')
      .set(...bearer(accessToken))
      .expect(200);
    expect(me.body).toMatchObject({ name: 'María Pérez', photoUrl: null, activeMode: 'employer' });

    const bad = await request(server())
      .patch('/me')
      .set(...bearer(accessToken))
      .send({ name: 'A' })
      .expect(400);
    expect(bad.body).toMatchObject({ message: 'El nombre debe tener entre 2 y 60 caracteres.' });
    // No se pueden tocar otros campos (p. ej. el rol).
    await request(server())
      .patch('/me')
      .set(...bearer(accessToken))
      .send({ role: 'admin' })
      .expect(400);
  });

  it('sube la foto de perfil con URL prefirmada y la devuelve firmada', async () => {
    const { accessToken, user } = await login(t);
    const photo = fakeJpeg(4096);
    const upload = (
      await request(server())
        .post('/me/photo/upload-url')
        .set(...bearer(accessToken))
        .send({ contentType: 'image/jpeg', sizeBytes: photo.length })
        .expect(201)
    ).body as PresignedUploadDto;
    expect(upload.key.startsWith(`avatars/${user.id}/`)).toBe(true);

    // Un archivo de otro tamaño no entra con esa URL.
    expect(await putPresigned(upload, fakeJpeg(5000))).toBe(403);
    expect(await putPresigned(upload, photo)).toBe(200);

    const confirmed = (
      await request(server())
        .put('/me/photo')
        .set(...bearer(accessToken))
        .send({ key: upload.key })
        .expect(200)
    ).body as UserDto;
    expect(confirmed.photoUrl).toContain('X-Amz-Signature');
    const download = await fetch(confirmed.photoUrl ?? '');
    expect(download.status).toBe(200);
    expect((await download.arrayBuffer()).byteLength).toBe(photo.length);
  });

  it('rechaza tipos y tamaños no permitidos', async () => {
    const { accessToken } = await login(t);
    const pdf = await request(server())
      .post('/me/photo/upload-url')
      .set(...bearer(accessToken))
      .send({ contentType: 'application/pdf', sizeBytes: 100 })
      .expect(400);
    expect(pdf.body).toMatchObject({ message: 'Solo se aceptan fotos JPEG, PNG o HEIC.' });
    const big = await request(server())
      .post('/me/photo/upload-url')
      .set(...bearer(accessToken))
      .send({ contentType: 'image/jpeg', sizeBytes: 8 * 1024 * 1024 + 1 })
      .expect(400);
    expect(big.body).toMatchObject({ code: 'UPLOAD_TOO_LARGE' });
  });

  it('no permite usar como foto un archivo de otro usuario', async () => {
    const owner = await login(t);
    const photo = fakeJpeg();
    const upload = (
      await request(server())
        .post('/me/photo/upload-url')
        .set(...bearer(owner.accessToken))
        .send({ contentType: 'image/jpeg', sizeBytes: photo.length })
        .expect(201)
    ).body as PresignedUploadDto;
    expect(await putPresigned(upload, photo)).toBe(200);

    const intruder = await login(t);
    const res = await request(server())
      .put('/me/photo')
      .set(...bearer(intruder.accessToken))
      .send({ key: upload.key })
      .expect(403);
    expect(res.body).toMatchObject({ code: 'UPLOAD_KEY_FORBIDDEN' });
  });
});
