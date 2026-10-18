import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CategoryResolver } from '../categories/category-resolver';
import { ApiError } from '../common/errors/api-error';
import { isAdult, parseIsoDate } from '../common/time/age';
import type { AppConfigService } from '../config/app-config';
import type { WorkerDocument, WorkerProfile } from '../generated/prisma/client';
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
import {
  REQUIRED_DOCUMENTS,
  type RequiredDocumentType,
  type SubmitUpgradeDto,
  type WorkerProfileDto,
} from './dto/worker.dto';
import { canApply, type WorkerStatus } from './worker-status.machine';
import { WorkerStatusService } from './worker-status.service';

type ProfileWithRelations = WorkerProfile & {
  documents: WorkerDocument[];
  categories: { categoryId: string }[];
};

/** Upgrade a trabajador (R1.3) y documentos de identidad (R9.5). */
@Injectable()
export class WorkersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly storage: StorageService,
    private readonly categories: CategoryResolver,
    private readonly status: WorkerStatusService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async getMyProfile(userId: string): Promise<WorkerProfileDto> {
    return toDto(await this.findProfile(userId));
  }

  async documentUploadUrl(
    userId: string,
    type: RequiredDocumentType,
    contentType: string,
    sizeBytes: number,
  ): Promise<PresignedUploadDto> {
    await this.assertEditable(userId);
    assertUploadAllowed(contentType, sizeBytes, this.maxBytes());
    const key = newObjectKey(
      STORAGE_PREFIX.identity(userId),
      contentType as AllowedImageType,
      type,
    );
    const { url, ...rest } = await this.storage.presignUpload({
      key,
      contentType,
      sizeBytes,
      expiresInSec: this.config.get('UPLOAD_URL_TTL_SEC', { infer: true }),
    });
    return { key, uploadUrl: url, ...rest };
  }

  /** Registra el documento subido (reemplaza al anterior del mismo tipo). */
  async confirmDocument(
    userId: string,
    type: RequiredDocumentType,
    key: string,
  ): Promise<WorkerProfileDto> {
    await this.assertEditable(userId);
    const prefix = STORAGE_PREFIX.identity(userId);
    if (!key.startsWith(`${prefix}${type}-`)) {
      throw new ApiError(
        HttpStatus.FORBIDDEN,
        'UPLOAD_KEY_FORBIDDEN',
        'Ese archivo no corresponde a este documento.',
      );
    }
    const object = assertUploadedObject(key, prefix, await this.storage.head(key), this.maxBytes());

    await this.prisma.workerProfile.upsert({ where: { userId }, create: { userId }, update: {} });
    const previous = await this.prisma.workerDocument.findUnique({
      where: { workerId_type: { workerId: userId, type } },
    });
    await this.prisma.workerDocument.upsert({
      where: { workerId_type: { workerId: userId, type } },
      create: { workerId: userId, type, fileKey: key, ...object },
      update: {
        fileKey: key,
        ...object,
        reviewStatus: 'pendiente',
        reviewedById: null,
        reviewedAt: null,
      },
    });
    if (previous && previous.fileKey !== key) await this.storage.delete(previous.fileKey);
    return this.getMyProfile(userId);
  }

  /** Envía la solicitud de upgrade: valida R1.3 y pasa a pendiente_revision. */
  async submitUpgrade(userId: string, dto: SubmitUpgradeDto): Promise<WorkerProfileDto> {
    const user = await this.prisma.user.findUniqueOrThrow({ where: { id: userId } });
    if (!user.phoneVerifiedAt) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'PHONE_NOT_VERIFIED',
        'Primero verifica tu número de celular.',
      );
    }

    const birth = parseIsoDate(dto.birthDate);
    if (!birth || birth.year < 1900) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'BIRTH_DATE_INVALID',
        'La fecha de nacimiento no es válida.',
      );
    }
    if (!isAdult(dto.birthDate, new Date(), this.config.get('TZ_DEFAULT', { infer: true }))) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'WORKER_UNDERAGE',
        'Debes tener al menos 18 años para trabajar en SISI.',
      );
    }

    const profile = await this.findProfile(userId);
    const missing = missingDocuments(profile);
    if (missing.length > 0) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'WORKER_DOCUMENTS_MISSING',
        'Falta subir fotos de tu carnet (ambos lados) o tu selfie.',
        { missingDocuments: missing },
      );
    }
    await this.categories.requireAllActive(dto.categoryIds, user.cityId);

    await this.status.apply(userId, { type: 'SUBMIT' }, userId, async (tx) => {
      await tx.workerProfile.update({
        where: { userId },
        data: {
          birthDate: new Date(`${dto.birthDate}T00:00:00.000Z`),
          transport: dto.transport,
          maxRadiusKm: dto.maxRadiusKm,
        },
      });
      await tx.workerCategory.deleteMany({ where: { workerId: userId } });
      await tx.workerCategory.createMany({
        data: [...new Set(dto.categoryIds)].map((categoryId) => ({ workerId: userId, categoryId })),
      });
    });
    return this.getMyProfile(userId);
  }

  /** Enlace temporal a un documento de identidad. Solo para administradores (R9.5). */
  private async findProfile(userId: string): Promise<ProfileWithRelations | null> {
    return this.prisma.workerProfile.findUnique({
      where: { userId },
      include: { documents: true, categories: { select: { categoryId: true } } },
    });
  }

  private async assertEditable(userId: string): Promise<void> {
    const profile = await this.prisma.workerProfile.findUnique({ where: { userId } });
    const status: WorkerStatus = profile?.status ?? 'sin_solicitar';
    if (!canApply(status, 'SUBMIT')) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'WORKER_PROFILE_LOCKED',
        status === 'pendiente_revision'
          ? 'Tu solicitud está en revisión: no puedes cambiar los documentos.'
          : 'Tu verificación ya fue aprobada: no puedes cambiar los documentos.',
      );
    }
  }

  private maxBytes(): number {
    return this.config.get('UPLOAD_MAX_BYTES', { infer: true });
  }
}

function missingDocuments(profile: ProfileWithRelations | null): RequiredDocumentType[] {
  const uploaded = new Set(profile?.documents.map((d) => d.type) ?? []);
  return REQUIRED_DOCUMENTS.filter((type) => !uploaded.has(type));
}

function toDto(profile: ProfileWithRelations | null): WorkerProfileDto {
  const status: WorkerStatus = profile?.status ?? 'sin_solicitar';
  return {
    status,
    rejectionReason: status === 'rechazado' ? (profile?.rejectionReason ?? null) : null,
    birthDate: profile?.birthDate ? profile.birthDate.toISOString().slice(0, 10) : null,
    transport: profile?.transport ?? null,
    maxRadiusKm: profile?.maxRadiusKm ?? null,
    categoryIds: profile?.categories.map((c) => c.categoryId) ?? [],
    documents: (profile?.documents ?? []).map((d) => ({
      type: d.type,
      reviewStatus: d.reviewStatus,
      uploadedAt: d.updatedAt.toISOString(),
    })),
    submittedAt: profile?.submittedAt?.toISOString() ?? null,
    editable: canApply(status, 'SUBMIT'),
    missingDocuments: missingDocuments(profile),
  };
}
