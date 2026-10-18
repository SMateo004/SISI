import request from 'supertest';
import type { LoginResponseDto } from '../src/auth/dto/auth.dto';
import type { CreatedRequestDto } from '../src/requests/dto/request.dto';
import type { PresignedUploadDto } from '../src/storage/dto/upload.dto';
import { assignJob, type AssignedJob, offerOn, waitNotified } from './utils/jobs';
import { CENTRO, eastOf, publishRequest } from './utils/requests';
import { registeredRoutes, routeKey } from './utils/routes';
import {
  bearer,
  createCategory,
  createTestApp,
  login,
  type TestApp,
  uniqueIp,
} from './utils/test-app';
import { uniqueSuffix } from './utils/unique';
import { fakeJpeg, putPresigned } from './utils/upload';
import { createApprovedWorker, makeAvailable, type TestWorker } from './utils/workers';

/**
 * Autorización objeto por objeto (IDOR, ADR-0047). Cada ruta de usuario que recibe un id
 * se prueba con dos extraños (un empleador y un trabajador) contra objetos de otro: 403 o
 * 404, y el objeto no cambia. La lista sale de las rutas que registró Nest: una ruta nueva
 * con parámetro sin caso aquí hace fallar el test.
 */

interface Scenario {
  /** Empleador dueño de la solicitud con ofertas y del borrador. */
  owner: LoginResponseDto;
  /** Trabajador que ofertó en la solicitud del dueño. */
  bidder: TestWorker;
  draftId: string;
  photoId: string;
  openRequestId: string;
  offerId: string;
  job: AssignedJob;
  messageId: string;
  notificationId: string;
  deviceToken: string;
}

type Call = (s: Scenario, token: string) => request.Test;

/** Ruta → cómo la llama un extraño. */
const CASES: Record<string, Call> = {};
const add = (key: string, call: Call) => {
  CASES[key] = call;
};

/** Rutas con parámetro que no son de un objeto ajeno (con el motivo). */
const EXEMPT: Record<string, string> = {
  'GET /users/:id/reviews': 'reputación pública por diseño: cualquier usuario la ve',
  'PUT /me/worker/documents/:type':
    ':type es un tipo de documento, no un id; la clave ajena se prueba en los casos de body',
};

describe('IDOR: objetos de otro usuario (e2e, ADR-0047)', () => {
  let t: TestApp;
  let s: Scenario;
  let strangerEmployer: LoginResponseDto;
  let strangerWorker: TestWorker;
  const server = () => t.app.getHttpServer();
  const http = () => request(server());

  beforeAll(async () => {
    t = await createTestApp({ worker: true });

    // Solicitud con una oferta: dueño y un trabajador de su categoría.
    const category = await createCategory(t);
    const owner = await login(t);
    const bidder = await createApprovedWorker(t, { categorySlugs: [category.slug] });
    await makeAvailable(t, bidder, eastOf(CENTRO, 300));
    const openRequestId = await publishRequest(t, owner.accessToken, { categoryId: category.id });
    await waitNotified(t, openRequestId, bidder.id);
    const offer = await offerOn(t, bidder, openRequestId);

    // Borrador con una foto.
    const draft = (
      await http()
        .post('/requests')
        .set('X-Forwarded-For', uniqueIp())
        .set(...bearer(owner.accessToken))
        .send({
          categoryId: category.id,
          description: 'Se rompió la llave de paso del baño y no puedo cerrar el agua.',
          ...CENTRO,
          address: 'Calle Junín 150',
          proposedPriceBs: '150.00',
        })
        .expect(201)
    ).body as CreatedRequestDto;
    const file = fakeJpeg();
    const upload = (
      await http()
        .post(`/requests/${draft.request.id}/photos/upload-url`)
        .set(...bearer(owner.accessToken))
        .send({ contentType: 'image/jpeg', sizeBytes: file.length })
        .expect(201)
    ).body as PresignedUploadDto;
    expect(await putPresigned(upload, file)).toBe(200);
    await http()
      .put(`/requests/${draft.request.id}/photos`)
      .set(...bearer(owner.accessToken))
      .send({ key: upload.key })
      .expect(200);
    const photo = await t.prisma.serviceRequestPhoto.findFirstOrThrow({
      where: { requestId: draft.request.id },
    });

    // Trabajo asignado con un mensaje en el chat.
    const job = await assignJob(t);
    await http()
      .post(`/jobs/${job.jobId}/messages`)
      .set(...bearer(job.worker.accessToken))
      .send({ body: 'Voy saliendo, llego en 15 minutos.' })
      .expect(201);
    const message = await t.prisma.chatMessage.findFirstOrThrow({ where: { jobId: job.jobId } });

    // Aviso sin leer y dispositivo del dueño.
    const notification = await t.prisma.notification.create({
      data: {
        userId: owner.user.id,
        cityId: (await t.prisma.user.findUniqueOrThrow({ where: { id: owner.user.id } })).cityId,
        type: 'offer_new',
        title: 'Nueva oferta',
        body: 'Tienes una oferta',
        dedupeKey: `idor-${uniqueSuffix()}`,
      },
    });
    const deviceToken = `idor-device-token-${uniqueSuffix()}-0000000000`;
    await http()
      .post('/me/devices')
      .set(...bearer(owner.accessToken))
      .send({ token: deviceToken, platform: 'android' })
      .expect((res) => {
        expect(res.status).toBeLessThan(300);
      });

    s = {
      owner,
      bidder,
      draftId: draft.request.id,
      photoId: photo.id,
      openRequestId,
      offerId: offer.id,
      job,
      messageId: message.id,
      notificationId: notification.id,
      deviceToken,
    };

    // Extraños: un empleador y un trabajador aprobado de otra categoría (no le llegó nada).
    strangerEmployer = await login(t);
    const other = await createCategory(t);
    strangerWorker = await createApprovedWorker(t, { categorySlugs: [other.slug] });
  });

  afterAll(async () => {
    await t.close();
  });

  // Solicitudes del empleador.
  add('POST /requests/:id/photos/upload-url', (x, tk) =>
    http()
      .post(`/requests/${x.draftId}/photos/upload-url`)
      .set(...bearer(tk))
      .send({ contentType: 'image/jpeg', sizeBytes: 2048 }),
  );
  add('PUT /requests/:id/photos', (x, tk) =>
    http()
      .put(`/requests/${x.draftId}/photos`)
      .set(...bearer(tk))
      .send({ key: `requests/${x.draftId}/foto.jpg` }),
  );
  add('DELETE /requests/:id/photos/:photoId', (x, tk) =>
    http()
      .delete(`/requests/${x.draftId}/photos/${x.photoId}`)
      .set(...bearer(tk)),
  );
  add('POST /requests/:id/publish', (x, tk) =>
    http()
      .post(`/requests/${x.draftId}/publish`)
      .set(...bearer(tk)),
  );
  add('POST /requests/:id/cancel', (x, tk) =>
    http()
      .post(`/requests/${x.openRequestId}/cancel`)
      .set(...bearer(tk)),
  );
  add('GET /requests/:id', (x, tk) =>
    http()
      .get(`/requests/${x.openRequestId}`)
      .set(...bearer(tk)),
  );
  // Ofertas.
  add('GET /worker/requests/:id', (x, tk) =>
    http()
      .get(`/worker/requests/${x.openRequestId}`)
      .set(...bearer(tk)),
  );
  add('POST /requests/:id/offers', (x, tk) =>
    http()
      .post(`/requests/${x.openRequestId}/offers`)
      .set('X-Forwarded-For', uniqueIp())
      .set(...bearer(tk))
      .send({ type: 'accept' }),
  );
  add('DELETE /requests/:id/offers/mine', (x, tk) =>
    http()
      .delete(`/requests/${x.openRequestId}/offers/mine`)
      .set(...bearer(tk)),
  );
  add('GET /requests/:id/offers', (x, tk) =>
    http()
      .get(`/requests/${x.openRequestId}/offers`)
      .set(...bearer(tk)),
  );
  add('POST /requests/:id/offers/:offerId/accept', (x, tk) =>
    http()
      .post(`/requests/${x.openRequestId}/offers/${x.offerId}/accept`)
      .set(...bearer(tk)),
  );
  // Trabajos.
  add('GET /jobs/:id/contact', (x, tk) =>
    http()
      .get(`/jobs/${x.job.jobId}/contact`)
      .set(...bearer(tk)),
  );
  add('GET /jobs/:id', (x, tk) =>
    http()
      .get(`/jobs/${x.job.jobId}`)
      .set(...bearer(tk)),
  );
  for (const step of ['on-the-way', 'start', 'finish', 'confirm']) {
    add(`POST /jobs/:id/${step}`, (x, tk) =>
      http()
        .post(`/jobs/${x.job.jobId}/${step}`)
        .set(...bearer(tk)),
    );
  }
  add('POST /jobs/:id/dispute', (x, tk) =>
    http()
      .post(`/jobs/${x.job.jobId}/dispute`)
      .set(...bearer(tk))
      .send({ note: 'No terminó el trabajo.' }),
  );
  add('POST /jobs/:id/cancel', (x, tk) =>
    http()
      .post(`/jobs/${x.job.jobId}/cancel`)
      .set(...bearer(tk))
      .send({ reason: 'cambio_de_planes' }),
  );
  add('GET /jobs/:id/location', (x, tk) =>
    http()
      .get(`/jobs/${x.job.jobId}/location`)
      .set(...bearer(tk)),
  );
  // Chat y calificaciones.
  add('GET /jobs/:id/messages', (x, tk) =>
    http()
      .get(`/jobs/${x.job.jobId}/messages`)
      .set(...bearer(tk)),
  );
  add('POST /jobs/:id/messages', (x, tk) =>
    http()
      .post(`/jobs/${x.job.jobId}/messages`)
      .set(...bearer(tk))
      .send({ body: 'Hola, soy un extraño.' }),
  );
  add('POST /jobs/:id/messages/read', (x, tk) =>
    http()
      .post(`/jobs/${x.job.jobId}/messages/read`)
      .set(...bearer(tk))
      .send({ upToId: x.messageId }),
  );
  add('POST /jobs/:id/review', (x, tk) =>
    http()
      .post(`/jobs/${x.job.jobId}/review`)
      .set(...bearer(tk))
      .send({ stars: 1 }),
  );
  add('GET /jobs/:id/reviews', (x, tk) =>
    http()
      .get(`/jobs/${x.job.jobId}/reviews`)
      .set(...bearer(tk)),
  );
  // Avisos y dispositivos: responden 204 aunque no sean suyos (no filtran nada); lo que
  // importa es que no cambien, y se verifica en la base.
  add('POST /me/notifications/:id/read', (x, tk) =>
    http()
      .post(`/me/notifications/${x.notificationId}/read`)
      .set(...bearer(tk)),
  );
  add('DELETE /me/devices/:token', (x, tk) =>
    http()
      .delete(`/me/devices/${x.deviceToken}`)
      .set(...bearer(tk)),
  );
  const silent = new Set(['POST /me/notifications/:id/read', 'DELETE /me/devices/:token']);

  it('toda ruta de usuario con parámetro tiene su caso (o una excepción explicada)', () => {
    const withParams = registeredRoutes(t)
      .filter((r) => !r.path.startsWith('/admin') && !r.isPublic && r.path.includes(':'))
      .map(routeKey);
    const missing = withParams.filter((k) => !(k in CASES) && !(k in EXEMPT));
    expect(missing).toEqual([]);
    // Y ningún caso apunta a una ruta que ya no existe.
    expect(Object.keys(CASES).filter((k) => !withParams.includes(k))).toEqual([]);
  });

  it('un extraño (empleador o trabajador) recibe 403 o 404 en cada ruta', async () => {
    const wrong: string[] = [];
    for (const stranger of [strangerEmployer, strangerWorker]) {
      for (const [key, call] of Object.entries(CASES)) {
        const res = await call(s, stranger.accessToken);
        const ok = silent.has(key) ? res.status === 204 : [403, 404].includes(res.status);
        if (!ok) wrong.push(`${key} → ${String(res.status)} ${JSON.stringify(res.body)}`);
      }
    }
    expect(wrong).toEqual([]);
  });

  it('y nada cambió: borrador, solicitud, oferta, trabajo, chat, aviso y dispositivo', async () => {
    const draft = await t.prisma.serviceRequest.findUniqueOrThrow({
      where: { id: s.draftId },
      include: { photos: true },
    });
    expect(draft.status).toBe('borrador');
    expect(draft.photos.map((p) => p.id)).toEqual([s.photoId]);
    const open = await t.prisma.serviceRequest.findUniqueOrThrow({
      where: { id: s.openRequestId },
    });
    expect(open.status).toBe('con_ofertas');
    const offer = await t.prisma.offer.findUniqueOrThrow({ where: { id: s.offerId } });
    expect(offer.status).toBe('activa');
    const job = await t.prisma.job.findUniqueOrThrow({ where: { id: s.job.jobId } });
    expect(job.status).toBe('asignado');
    expect(await t.prisma.chatMessage.count({ where: { jobId: s.job.jobId } })).toBe(1);
    expect(await t.prisma.review.count({ where: { jobId: s.job.jobId } })).toBe(0);
    const notification = await t.prisma.notification.findUniqueOrThrow({
      where: { id: s.notificationId },
    });
    expect(notification.readAt).toBeNull();
    expect(await t.prisma.deviceToken.count({ where: { token: s.deviceToken } })).toBe(1);
  });

  describe('ids ajenos en el body', () => {
    it('claves de archivo de otro usuario: 403 UPLOAD_KEY_FORBIDDEN', async () => {
      // Foto de perfil con la clave de otro.
      const avatar = await http()
        .put('/me/photo')
        .set(...bearer(strangerEmployer.accessToken))
        .send({ key: `avatars/${s.owner.user.id}/foto.jpg` });
      expect(avatar.status).toBe(403);
      // Documento con la clave de otro trabajador (lo intenta alguien que todavía arma su
      // solicitud de trabajador: a uno aprobado ya no se le aceptan documentos).
      const doc = await http()
        .put('/me/worker/documents/ci_front')
        .set(...bearer(strangerEmployer.accessToken))
        .send({ key: `identity/${s.bidder.id}/ci_front-1.jpg` });
      expect(doc.status).toBe(403);
      // Comprobante con la clave de otro trabajador.
      const receipt = await http()
        .post('/me/billing/submissions')
        .set(...bearer(strangerWorker.accessToken))
        .send({ receiptKey: `receipts/${s.bidder.id}/comprobante.jpg`, declaredAmountBs: '10.00' });
      expect(receipt.status).toBe(403);
      // Foto de su propio borrador con la clave del borrador ajeno.
      const ownDraft = (
        await http()
          .post('/requests')
          .set('X-Forwarded-For', uniqueIp())
          .set(...bearer(strangerEmployer.accessToken))
          .send({
            categoryId: (await t.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } }))
              .id,
            description: 'Necesito cambiar el grifo de la cocina, gotea mucho.',
            ...CENTRO,
            address: 'Calle Junín 150',
            proposedPriceBs: '150.00',
          })
          .expect(201)
      ).body as CreatedRequestDto;
      const photo = await http()
        .put(`/requests/${ownDraft.request.id}/photos`)
        .set(...bearer(strangerEmployer.accessToken))
        .send({ key: `requests/${s.draftId}/foto.jpg` });
      expect(photo.status).toBe(403);
    });

    it('reportes sobre lo que uno no conoce: 404 REPORT_TARGET_NOT_FOUND', async () => {
      const targets = [
        { targetType: 'job', targetId: s.job.jobId },
        { targetType: 'request', targetId: s.openRequestId },
        { targetType: 'chat_message', targetId: s.messageId },
        { targetType: 'user', targetId: s.owner.user.id },
      ];
      for (const target of targets) {
        const res = await http()
          .post('/reports')
          .set(...bearer(strangerEmployer.accessToken))
          .send({ ...target, reason: 'fraude', note: 'Intento de reporte ajeno.' });
        expect({ target, status: res.status, code: (res.body as { code?: string }).code }).toEqual({
          target,
          status: 404,
          code: 'REPORT_TARGET_NOT_FOUND',
        });
      }
    });
  });
});
