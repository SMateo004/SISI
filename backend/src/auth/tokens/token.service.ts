import { createHash, randomUUID } from 'node:crypto';
import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { ApiError } from '../../common/errors/api-error';
import type { AppConfigService } from '../../config/app-config';
import {
  REFRESH_TOKEN_REPOSITORY,
  type NewRefreshToken,
  type RefreshTokenRepository,
} from './refresh-token.repository';

export type Role = 'user' | 'admin';

export interface TokenSubject {
  id: string;
  role: Role;
}

export interface AccessPayload {
  sub: string;
  role: Role;
  typ: 'access';
}

/** Payload recién verificado: la firma es válida, pero el tipo aún no se comprobó. */
type Untrusted<T extends { typ: string }> = Omit<T, 'typ'> & { typ?: string };

interface RefreshPayload {
  sub: string;
  fam: string;
  jti: string;
  typ: 'refresh';
}

export interface IssuedTokens {
  accessToken: string;
  refreshToken: string;
  tokenType: 'Bearer';
  /** Segundos de vida del token de acceso. */
  expiresIn: number;
  refreshExpiresIn: number;
}

/** Carga el rol vigente del usuario al rotar (o null si la cuenta ya no existe). */
export const TOKEN_SUBJECT_LOADER = Symbol('TOKEN_SUBJECT_LOADER');
export type TokenSubjectLoader = (userId: string) => Promise<TokenSubject | null>;

const sha256 = (value: string): string => createHash('sha256').update(value).digest('hex');

const sessionError = (code: string): ApiError =>
  new ApiError(
    HttpStatus.UNAUTHORIZED,
    code,
    'Tu sesión ya no es válida. Vuelve a ingresar con tu número.',
  );

/**
 * JWT de acceso corto + refresh rotativo con familia (ADR-0009).
 * Reutilizar un refresh ya usado revoca toda la familia (posible robo del token).
 */
@Injectable()
export class TokenService {
  private readonly logger = new Logger(TokenService.name);
  private readonly accessTtl: number;
  private readonly refreshTtl: number;
  private readonly refreshSecret: string;

  constructor(
    private readonly jwt: JwtService,
    @Inject(ConfigService) config: AppConfigService,
    @Inject(REFRESH_TOKEN_REPOSITORY) private readonly repo: RefreshTokenRepository,
    @Inject(TOKEN_SUBJECT_LOADER) private readonly loadSubject: TokenSubjectLoader,
  ) {
    this.accessTtl = config.get('JWT_ACCESS_TTL_SEC', { infer: true });
    this.refreshTtl = config.get('JWT_REFRESH_TTL_SEC', { infer: true });
    this.refreshSecret = config.get('JWT_REFRESH_SECRET', { infer: true });
  }

  /** Inicia una sesión nueva (familia nueva). */
  async issue(subject: TokenSubject): Promise<IssuedTokens> {
    const familyId = randomUUID();
    const { token, record } = await this.newRefresh(subject.id, familyId);
    await this.repo.create(record);
    return this.pair(subject, token);
  }

  async rotate(refreshToken: string): Promise<IssuedTokens & { subject: TokenSubject }> {
    const payload = await this.verifyRefresh(refreshToken, false);
    const stored = await this.repo.findById(payload.jti);
    if (
      stored?.tokenHash !== sha256(refreshToken) ||
      stored.userId !== payload.sub ||
      stored.familyId !== payload.fam
    ) {
      throw sessionError('SESSION_INVALID');
    }
    if (stored.revokedAt) throw sessionError('SESSION_REVOKED');
    if (stored.usedAt) {
      await this.revokeForReuse(stored.familyId, stored.userId);
      throw sessionError('SESSION_REUSED');
    }
    if (stored.expiresAt.getTime() <= Date.now()) throw sessionError('SESSION_EXPIRED');

    const subject = await this.loadSubject(stored.userId);
    if (!subject) {
      await this.repo.revokeFamily(stored.familyId);
      throw sessionError('SESSION_INVALID');
    }

    const { token, record } = await this.newRefresh(subject.id, stored.familyId);
    const rotated = await this.repo.rotate(stored.id, record);
    if (!rotated) {
      // Otro request usó este refresh en paralelo: se trata como reutilización.
      await this.revokeForReuse(stored.familyId, stored.userId);
      throw sessionError('SESSION_REUSED');
    }
    return { ...(await this.pair(subject, token)), subject };
  }

  /** Cierra la sesión: revoca la familia. Idempotente; un token inválido no da error. */
  async revoke(refreshToken: string): Promise<void> {
    try {
      const payload = await this.verifyRefresh(refreshToken, true);
      const stored = await this.repo.findById(payload.jti);
      if (stored?.tokenHash === sha256(refreshToken)) {
        await this.repo.revokeFamily(stored.familyId);
      }
    } catch {
      // Logout de un token inválido o vencido: no hay nada que revocar.
    }
  }

  async verifyAccess(token: string): Promise<AccessPayload> {
    const payload = await this.jwt.verifyAsync<Untrusted<AccessPayload>>(token, {
      algorithms: ['HS256'],
    });
    if (payload.typ !== 'access') throw new Error('No es un token de acceso');
    return { ...payload, typ: 'access' };
  }

  private async verifyRefresh(token: string, ignoreExpiration: boolean): Promise<RefreshPayload> {
    let payload: Untrusted<RefreshPayload>;
    try {
      payload = await this.jwt.verifyAsync<Untrusted<RefreshPayload>>(token, {
        secret: this.refreshSecret,
        algorithms: ['HS256'],
        ignoreExpiration,
      });
    } catch {
      throw sessionError('SESSION_INVALID');
    }
    if (payload.typ !== 'refresh') throw sessionError('SESSION_INVALID');
    return { ...payload, typ: 'refresh' };
  }

  private async newRefresh(
    userId: string,
    familyId: string,
  ): Promise<{ token: string; record: NewRefreshToken }> {
    const jti = randomUUID();
    const payload: RefreshPayload = { sub: userId, fam: familyId, jti, typ: 'refresh' };
    const token = await this.jwt.signAsync(payload, {
      secret: this.refreshSecret,
      expiresIn: this.refreshTtl,
    });
    return {
      token,
      record: {
        id: jti,
        userId,
        familyId,
        tokenHash: sha256(token),
        expiresAt: new Date(Date.now() + this.refreshTtl * 1000),
      },
    };
  }

  private async pair(subject: TokenSubject, refreshToken: string): Promise<IssuedTokens> {
    const payload: AccessPayload = { sub: subject.id, role: subject.role, typ: 'access' };
    const accessToken = await this.jwt.signAsync(payload, { expiresIn: this.accessTtl });
    return {
      accessToken,
      refreshToken,
      tokenType: 'Bearer',
      expiresIn: this.accessTtl,
      refreshExpiresIn: this.refreshTtl,
    };
  }

  private async revokeForReuse(familyId: string, userId: string): Promise<void> {
    this.logger.warn(`Refresh reutilizado: se revoca la familia ${familyId} (usuario ${userId})`);
    await this.repo.revokeFamily(familyId);
  }
}
