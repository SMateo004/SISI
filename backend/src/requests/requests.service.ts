import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CategoryResolver } from '../categories/category-resolver';
import { decimal, toBs } from '../categories/effective-category';
import { ApiError } from '../common/errors/api-error';
import { RateLimitStore } from '../common/rate-limit/rate-limit.store';
import { RateLimitedException } from '../common/rate-limit/rate-limited.exception';
import type { AppConfigService } from '../config/app-config';
import type { Prisma } from '../generated/prisma/client';
import { parseRings } from '../matching/matching.config';
import { ModerationService } from '../moderation/moderation.service';
import { OutboxService } from '../outbox/outbox.service';
import { PrismaService } from '../prisma/prisma.service';
import type { PresignedUploadDto } from '../storage/dto/upload.dto';
import { StorageService } from '../storage/storage.service';
import {
  type AllowedImageType,
  assertUploadAllowed,
  assertUploadedObject,
  newObjectKey,
  STORAGE_PREFIX,
} from '../storage/upload-policy';
import type {
  AdminHeldRequestDto,
  CreatedRequestDto,
  CreateRequestDto,
  PublishResultDto,
  RequestDto,
  RequestPageDto,
} from './dto/request.dto';
import { assertValidCoordinates, isInsideServiceArea, type LatLng, outsideCity } from './location';
import { priceWarnings } from './price-warning';
import type { RequestStatus } from './request-status.machine';
import { RequestStatusService } from './request-status.service';
import { RequestsRepository } from './requests.repository';

const requestInclude = {
  category: { select: { id: true, slug: true, name: true } },
  photos: { orderBy: { position: 'asc' } },
} satisfies Prisma.ServiceRequestInclude;

type RequestRow = Prisma.ServiceRequestGetPayload<{ include: typeof requestInclude }>;

const MESSAGES = {
  published: '¡Listo! Estamos buscando trabajadores cerca de ti.',
  held: 'Recibimos tu solicitud. La estamos revisando y te avisaremos cuando se publique.',
};

/** Texto que ve el empleador según el estado. Nunca revela qué término coincidió (R3.3). */
function statusMessage(row: Pick<RequestRow, 'status' | 'cancelReason'>): string | null {
  switch (row.status) {
    case 'borrador':
      return 'Todavía no publicaste esta solicitud.';
    case 'retenida':
      return MESSAGES.held;
    case 'buscando':
      return 'Buscando trabajadores cerca de ti.';
    case 'con_ofertas':
      return 'Tienes ofertas. Elige la que prefieras.';
    case 'asignada':
      return 'Ya tienes un trabajador asignado.';
    case 'cancelada':
      return row.cancelReason === 'moderacion'
        ? 'Tu solicitud no pudo publicarse porque no cumple las normas de uso de SISI.'
        : 'Cancelaste esta solicitud.';
    case 'expirada':
      return 'Nadie ofertó a tiempo. Puedes publicarla de nuevo.';
    default:
      return null;
  }
}

const notFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'REQUEST_NOT_FOUND', 'La solicitud no existe.');

/** Solicitudes de servicio (R3, ADR-0019). */
@Injectable()
export class RequestsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly repo: RequestsRepository,
    private readonly status: RequestStatusService,
    private readonly categories: CategoryResolver,
    private readonly moderation: ModerationService,
    private readonly storage: StorageService,
    private readonly rateLimits: RateLimitStore,
    private readonly outbox: OutboxService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {
    this.totalRings = parseRings(config.get('MATCHING_RINGS', { infer: true })).length;
  }

  private readonly totalRings: number;

  /** Crea el borrador (R3.1). Advierte si el precio está bajo el mínimo (R3.2). */
  async create(userId: string, dto: CreateRequestDto): Promise<CreatedRequestDto> {
    const user = await this.requireEmployer(userId);
    const description = dto.description.trim().replace(/\s+/g, ' ');
    const min = this.config.get('REQUEST_DESCRIPTION_MIN', { infer: true });
    const max = this.config.get('REQUEST_DESCRIPTION_MAX', { infer: true });
    if (description.length < min || description.length > max) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'DESCRIPTION_LENGTH',
        `Describe el trabajo con entre ${min} y ${max} caracteres.`,
        { min, max },
      );
    }
    const address = dto.address.trim();
    if (address.length < 5) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'ADDRESS_REQUIRED',
        'Escribe la dirección del trabajo.',
      );
    }
    const price = decimal(dto.proposedPriceBs);
    if (!price.greaterThan(0)) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'PRICE_INVALID',
        'El precio debe ser mayor que 0.',
      );
    }

    const category = await this.categories.requireActive(dto.categoryId, user.cityId);
    const point: LatLng = { lat: dto.latitude, lng: dto.longitude };
    assertValidCoordinates(point);
    if (!isInsideServiceArea(point, await this.repo.serviceArea(user.cityId, point))) {
      throw outsideCity();
    }

    const id = await this.repo.insertDraft({
      employerId: userId,
      categoryId: category.id,
      cityId: user.cityId,
      description,
      point,
      address,
      proposedPriceBs: price,
    });
    return { request: await this.getOwn(userId, id), warnings: priceWarnings(price, category) };
  }

  async photoUploadUrl(
    userId: string,
    requestId: string,
    contentType: string,
    sizeBytes: number,
  ): Promise<PresignedUploadDto> {
    const request = await this.requireOwnDraft(userId, requestId);
    this.assertPhotoSlot(request.photos.length);
    assertUploadAllowed(
      contentType,
      sizeBytes,
      this.config.get('UPLOAD_MAX_BYTES', { infer: true }),
    );
    const key = newObjectKey(STORAGE_PREFIX.requests(requestId), contentType as AllowedImageType);
    const { url, ...rest } = await this.storage.presignUpload({
      key,
      contentType,
      sizeBytes,
      expiresInSec: this.config.get('UPLOAD_URL_TTL_SEC', { infer: true }),
    });
    return { key, uploadUrl: url, ...rest };
  }

  async confirmPhoto(userId: string, requestId: string, key: string): Promise<RequestDto> {
    const request = await this.requireOwnDraft(userId, requestId);
    this.assertPhotoSlot(request.photos.length);
    if (request.photos.some((p) => p.fileKey === key)) return this.getOwn(userId, requestId);
    const prefix = STORAGE_PREFIX.requests(requestId);
    const object = assertUploadedObject(
      key,
      prefix,
      key.startsWith(prefix) ? await this.storage.head(key) : null,
      this.config.get('UPLOAD_MAX_BYTES', { infer: true }),
    );
    const used = new Set(request.photos.map((p) => p.position));
    const position = [0, 1, 2, 3].find((p) => !used.has(p)) ?? request.photos.length;
    await this.prisma.serviceRequestPhoto.create({
      data: { requestId, fileKey: key, position, ...object },
    });
    return this.getOwn(userId, requestId);
  }

  async deletePhoto(userId: string, requestId: string, photoId: string): Promise<void> {
    const request = await this.requireOwnDraft(userId, requestId);
    const photo = request.photos.find((p) => p.id === photoId);
    if (!photo) throw new ApiError(HttpStatus.NOT_FOUND, 'PHOTO_NOT_FOUND', 'La foto no existe.');
    await this.prisma.serviceRequestPhoto.delete({ where: { id: photoId } });
    await this.storage.delete(photo.fileKey);
  }

  /**
   * Publica (R3.3): pasa por moderación. Con coincidencias queda retenida (mensaje
   * neutral); si no, pasa a buscando y emite request.searching.
   */
  async publish(userId: string, requestId: string): Promise<PublishResultDto> {
    const user = await this.requireEmployer(userId);
    const request = await this.requireOwnDraft(userId, requestId);

    const decision = await this.rateLimits.consume([
      {
        key: `request:publish:user:${userId}:hour`,
        limit: this.config.get('RATE_REQUEST_PUBLISH_PER_HOUR', { infer: true }),
        windowSec: 3600,
      },
      {
        key: `request:publish:user:${userId}:day`,
        limit: this.config.get('RATE_REQUEST_PUBLISH_PER_DAY', { infer: true }),
        windowSec: 86_400,
      },
    ]);
    if (!decision.allowed) throw new RateLimitedException(decision.retryAfterSec);

    // La categoría pudo desactivarse entre el borrador y la publicación.
    const category = await this.categories.requireActive(request.categoryId, user.cityId);
    const moderation = await this.moderation.check(`${request.description}\n${request.address}`);
    const now = new Date();

    // Estado y evento en la misma transacción: el matching no depende de memoria (ADR-0022).
    await this.prisma.$transaction(async (tx) => {
      if (moderation.held) {
        await this.status.apply(
          requestId,
          'PUBLISH_HELD',
          userId,
          {
            data: {
              // Copia JSON plana de las coincidencias (solo las ve el admin).
              moderationMatches: JSON.parse(
                JSON.stringify({ matches: moderation.matches, timedOut: moderation.timedOut }),
              ) as Prisma.InputJsonValue,
            },
          },
          tx,
        );
        await this.outbox.add(tx, 'request.held', requestId, {
          requestId,
          matchCount: moderation.matches.length,
        });
      } else {
        await this.status.apply(
          requestId,
          'PUBLISH_CLEAN',
          userId,
          { data: { publishedAt: now } },
          tx,
        );
        await this.outbox.add(tx, 'request.searching', requestId, { requestId });
      }
    });

    return {
      request: await this.getOwn(userId, requestId),
      warnings: priceWarnings(request.proposedPriceBs, category),
      held: moderation.held,
      message: moderation.held ? MESSAGES.held : MESSAGES.published,
    };
  }

  /** El empleador cancela mientras no esté asignada (R3.4). */
  async cancel(userId: string, requestId: string): Promise<RequestDto> {
    await this.requireOwn(userId, requestId);
    await this.prisma.$transaction(async (tx) => {
      await this.status.apply(
        requestId,
        'CANCEL',
        userId,
        { data: { cancelReason: 'empleador', cancelledAt: new Date() } },
        tx,
      );
      // Las ofertas se cierran con la solicitud; el worker avisa con offer:closed.
      await tx.offer.updateMany({
        where: { requestId, status: 'activa' },
        data: { status: 'cerrada' },
      });
      await this.outbox.add(tx, 'request.cancelled', requestId, { requestId });
    });
    return this.getOwn(userId, requestId);
  }

  async listMine(userId: string, cursor: string | undefined, limit = 20): Promise<RequestPageDto> {
    const rows = await this.prisma.serviceRequest.findMany({
      where: { employerId: userId },
      include: requestInclude,
      orderBy: [{ createdAt: 'desc' }, { id: 'desc' }],
      take: limit + 1,
      ...(cursor ? { cursor: { id: cursor }, skip: 1 } : {}),
    });
    const page = rows.slice(0, limit);
    return {
      items: await this.toDtos(page),
      nextCursor: rows.length > limit ? (page.at(-1)?.id ?? null) : null,
    };
  }

  /** Detalle solo para el dueño; a otros les responde 404 (no revela si existe). */
  async getOwn(userId: string, requestId: string): Promise<RequestDto> {
    const [dto] = await this.toDtos([await this.requireOwn(userId, requestId)]);
    if (!dto) throw notFound();
    return dto;
  }

  // ---- Admin (la pantalla llega en la Fase 6) ----

  async listByStatus(status: RequestStatus): Promise<AdminHeldRequestDto[]> {
    const rows = await this.prisma.serviceRequest.findMany({
      where: { status },
      include: requestInclude,
      orderBy: { createdAt: 'asc' },
      take: 100,
    });
    const dtos = await this.toDtos(rows);
    return dtos.map((dto, i) =>
      Object.assign(dto, {
        matches: rows[i]?.moderationMatches ?? null,
        employerId: rows[i]?.employerId ?? '',
      }),
    );
  }

  async release(adminId: string, requestId: string): Promise<RequestDto> {
    const now = new Date();
    await this.prisma.$transaction(async (tx) => {
      await this.status.apply(
        requestId,
        'RELEASE',
        adminId,
        {
          data: { reviewedById: adminId, reviewedAt: now, publishedAt: now },
          reason: 'Liberada por moderación',
        },
        tx,
      );
      await this.outbox.add(tx, 'request.released', requestId, { requestId });
      await this.outbox.add(tx, 'request.searching', requestId, { requestId });
    });
    return this.adminView(requestId);
  }

  async reject(adminId: string, requestId: string, reason: string): Promise<RequestDto> {
    const now = new Date();
    await this.prisma.$transaction(async (tx) => {
      await this.status.apply(
        requestId,
        'REJECT',
        adminId,
        {
          data: {
            reviewedById: adminId,
            reviewedAt: now,
            cancelReason: 'moderacion',
            cancelNote: reason,
            cancelledAt: now,
          },
          reason,
        },
        tx,
      );
      await this.outbox.add(tx, 'request.rejected', requestId, { requestId });
    });
    return this.adminView(requestId);
  }

  // ---- Internos ----

  private async adminView(requestId: string): Promise<RequestDto> {
    const row = await this.prisma.serviceRequest.findUnique({
      where: { id: requestId },
      include: requestInclude,
    });
    if (!row) throw notFound();
    const [dto] = await this.toDtos([row]);
    if (!dto) throw notFound();
    return dto;
  }

  private async requireEmployer(userId: string) {
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
    if (user.activeMode !== 'employer') {
      throw new ApiError(
        HttpStatus.FORBIDDEN,
        'EMPLOYER_MODE_REQUIRED',
        'Cambia a modo empleador para pedir un servicio.',
      );
    }
    return user;
  }

  private async requireOwn(userId: string, requestId: string): Promise<RequestRow> {
    const row = await this.prisma.serviceRequest.findFirst({
      where: { id: requestId, employerId: userId },
      include: requestInclude,
    });
    if (!row) throw notFound();
    return row;
  }

  private async requireOwnDraft(userId: string, requestId: string): Promise<RequestRow> {
    const row = await this.requireOwn(userId, requestId);
    if (row.status !== 'borrador') {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'REQUEST_NOT_DRAFT',
        'Esta solicitud ya fue publicada y no se puede modificar.',
      );
    }
    return row;
  }

  private assertPhotoSlot(current: number): void {
    const max = this.config.get('REQUEST_MAX_PHOTOS', { infer: true });
    if (current >= max) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'TOO_MANY_PHOTOS',
        `Puedes subir hasta ${max} fotos.`,
      );
    }
  }

  private async toDtos(rows: RequestRow[]): Promise<RequestDto[]> {
    const locations = await this.repo.locations(rows.map((r) => r.id));
    const ttl = this.config.get('REQUEST_PHOTO_URL_TTL_SEC', { infer: true });
    return Promise.all(
      rows.map(async (row) => {
        const location = locations.get(row.id);
        return {
          id: row.id,
          status: row.status,
          statusMessage: statusMessage(row),
          category: row.category,
          cityId: row.cityId,
          description: row.description,
          latitude: location?.lat ?? 0,
          longitude: location?.lng ?? 0,
          address: row.address,
          proposedPriceBs: toBs(row.proposedPriceBs),
          photos: await Promise.all(
            row.photos.map(async (p) => ({
              id: p.id,
              position: p.position,
              url: await this.storage.presignDownload(p.fileKey, ttl),
            })),
          ),
          createdAt: row.createdAt.toISOString(),
          publishedAt: row.publishedAt?.toISOString() ?? null,
          cancelledAt: row.cancelledAt?.toISOString() ?? null,
          ring: row.ring,
          totalRings: this.totalRings,
          expiresAt: row.expiresAt?.toISOString() ?? null,
        };
      }),
    );
  }
}
