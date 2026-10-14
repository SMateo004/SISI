import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

export interface RefreshTokenRecord {
  id: string;
  userId: string;
  familyId: string;
  tokenHash: string;
  expiresAt: Date;
  usedAt: Date | null;
  revokedAt: Date | null;
}

export type NewRefreshToken = Pick<
  RefreshTokenRecord,
  'id' | 'userId' | 'familyId' | 'tokenHash' | 'expiresAt'
>;

/** Acceso a refresh_tokens. Separado para probar la rotación sin base de datos. */
export interface RefreshTokenRepository {
  create(token: NewRefreshToken): Promise<void>;
  findById(id: string): Promise<RefreshTokenRecord | null>;
  /**
   * Marca `oldId` como usado y crea su reemplazo en una sola transacción.
   * Devuelve false si otro request ya lo había usado (carrera = reutilización).
   */
  rotate(oldId: string, replacement: NewRefreshToken): Promise<boolean>;
  revokeFamily(familyId: string): Promise<void>;
}

export const REFRESH_TOKEN_REPOSITORY = Symbol('REFRESH_TOKEN_REPOSITORY');

@Injectable()
export class PrismaRefreshTokenRepository implements RefreshTokenRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(token: NewRefreshToken): Promise<void> {
    await this.prisma.refreshToken.create({ data: token });
  }

  findById(id: string): Promise<RefreshTokenRecord | null> {
    return this.prisma.refreshToken.findUnique({ where: { id } });
  }

  async rotate(oldId: string, replacement: NewRefreshToken): Promise<boolean> {
    return this.prisma.$transaction(async (tx) => {
      const { count } = await tx.refreshToken.updateMany({
        where: { id: oldId, usedAt: null, revokedAt: null },
        data: { usedAt: new Date(), replacedById: replacement.id },
      });
      if (count === 0) return false;
      await tx.refreshToken.create({ data: replacement });
      return true;
    });
  }

  async revokeFamily(familyId: string): Promise<void> {
    await this.prisma.refreshToken.updateMany({
      where: { familyId, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }
}
