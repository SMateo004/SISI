import { JwtService } from '@nestjs/jwt';
import type { AppConfigService } from '../../config/app-config';
import type {
  NewRefreshToken,
  RefreshTokenRecord,
  RefreshTokenRepository,
} from './refresh-token.repository';
import { type IssuedTokens, TokenService, type TokenSubject } from './token.service';

class MemoryRefreshRepo implements RefreshTokenRepository {
  readonly rows = new Map<string, RefreshTokenRecord>();

  create(token: NewRefreshToken): Promise<void> {
    this.rows.set(token.id, { ...token, usedAt: null, revokedAt: null });
    return Promise.resolve();
  }

  findById(id: string): Promise<RefreshTokenRecord | null> {
    return Promise.resolve(this.rows.get(id) ?? null);
  }

  rotate(oldId: string, replacement: NewRefreshToken): Promise<boolean> {
    const row = this.rows.get(oldId);
    if (!row || row.usedAt || row.revokedAt) return Promise.resolve(false);
    row.usedAt = new Date();
    return this.create(replacement).then(() => true);
  }

  revokeFamily(familyId: string): Promise<void> {
    for (const row of this.rows.values()) {
      if (row.familyId === familyId) row.revokedAt ??= new Date();
    }
    return Promise.resolve();
  }
}

const ENV: Record<string, unknown> = {
  JWT_ACCESS_TTL_SEC: 900,
  JWT_REFRESH_TTL_SEC: 2_592_000,
  JWT_REFRESH_SECRET: 'refresh-secreto-de-pruebas-32-caracteres',
};
const USER: TokenSubject = { id: '11111111-1111-4111-8111-111111111111', role: 'user' };

function setup() {
  const jwt = new JwtService({
    secret: 'access-secreto-de-pruebas-32-caracteres!',
    signOptions: { algorithm: 'HS256' },
  });
  const repo = new MemoryRefreshRepo();
  const subjects = new Map<string, TokenSubject>([[USER.id, USER]]);
  const service = new TokenService(
    jwt,
    { get: (key: string) => ENV[key] } as unknown as AppConfigService,
    repo,
    (id) => Promise.resolve(subjects.get(id) ?? null),
  );
  return { service, repo, jwt, subjects };
}

const familyOf = (repo: MemoryRefreshRepo, tokens: IssuedTokens, jwt: JwtService): string => {
  const { jti } = jwt.decode<{ jti: string }>(tokens.refreshToken);
  const row = repo.rows.get(jti);
  if (!row) throw new Error('fila no encontrada');
  return row.familyId;
};

describe('TokenService', () => {
  it('emite un acceso de 15 min y un refresh de 30 días guardado como hash', async () => {
    const { service, repo, jwt } = setup();
    const tokens = await service.issue(USER);
    expect(tokens).toMatchObject({
      tokenType: 'Bearer',
      expiresIn: 900,
      refreshExpiresIn: 2_592_000,
    });

    const access = await service.verifyAccess(tokens.accessToken);
    expect(access).toMatchObject({ sub: USER.id, role: 'user', typ: 'access' });
    const { exp, iat } = jwt.decode<{ exp: number; iat: number }>(tokens.accessToken);
    expect(exp - iat).toBe(900);

    const [row] = [...repo.rows.values()];
    expect(row?.tokenHash).toMatch(/^[0-9a-f]{64}$/);
    expect(row?.tokenHash).not.toBe(tokens.refreshToken);
  });

  it('no acepta un refresh como token de acceso', async () => {
    const { service } = setup();
    const tokens = await service.issue(USER);
    await expect(service.verifyAccess(tokens.refreshToken)).rejects.toThrow();
  });

  it('rota: el refresh nuevo funciona y queda en la misma familia', async () => {
    const { service, repo, jwt } = setup();
    const first = await service.issue(USER);
    const second = await service.rotate(first.refreshToken);
    expect(second.refreshToken).not.toBe(first.refreshToken);
    expect(familyOf(repo, second, jwt)).toBe(familyOf(repo, first, jwt));
    const third = await service.rotate(second.refreshToken);
    expect(third.subject).toEqual(USER);
  });

  it('detecta la reutilización y revoca toda la familia', async () => {
    const { service, repo, jwt } = setup();
    const first = await service.issue(USER);
    const second = await service.rotate(first.refreshToken);

    // Un atacante reutiliza el primero, ya usado.
    await expect(service.rotate(first.refreshToken)).rejects.toMatchObject({
      code: 'SESSION_REUSED',
    });
    // El token legítimo más reciente también queda revocado.
    await expect(service.rotate(second.refreshToken)).rejects.toMatchObject({
      code: 'SESSION_REVOKED',
    });
    const family = familyOf(repo, first, jwt);
    expect(
      [...repo.rows.values()].filter((r) => r.familyId === family).every((r) => r.revokedAt),
    ).toBe(true);
  });

  it('no afecta otras sesiones del mismo usuario', async () => {
    const { service } = setup();
    const phone = await service.issue(USER);
    const web = await service.issue(USER);
    await service.rotate(phone.refreshToken);
    await expect(service.rotate(phone.refreshToken)).rejects.toMatchObject({
      code: 'SESSION_REUSED',
    });
    await expect(service.rotate(web.refreshToken)).resolves.toMatchObject({ subject: USER });
  });

  it('trata una rotación concurrente perdida como reutilización', async () => {
    const { service, repo } = setup();
    const first = await service.issue(USER);
    const original = repo.rotate.bind(repo);
    // Simula que otro request marcó el token como usado justo antes.
    repo.rotate = () => Promise.resolve(false);
    await expect(service.rotate(first.refreshToken)).rejects.toMatchObject({
      code: 'SESSION_REUSED',
    });
    repo.rotate = original;
    expect([...repo.rows.values()].every((r) => r.revokedAt)).toBe(true);
  });

  it('logout revoca la familia y es idempotente', async () => {
    const { service } = setup();
    const tokens = await service.issue(USER);
    await service.revoke(tokens.refreshToken);
    await service.revoke(tokens.refreshToken);
    await service.revoke('no-es-un-jwt');
    await expect(service.rotate(tokens.refreshToken)).rejects.toMatchObject({
      code: 'SESSION_REVOKED',
    });
  });

  it('rechaza un refresh firmado con otro secreto o adulterado', async () => {
    const { service, jwt } = setup();
    const forged = await jwt.signAsync({ sub: USER.id, fam: 'x', jti: 'y', typ: 'refresh' });
    await expect(service.rotate(forged)).rejects.toMatchObject({ code: 'SESSION_INVALID' });
  });

  it('revoca si la cuenta ya no existe', async () => {
    const { service, subjects } = setup();
    const tokens = await service.issue(USER);
    subjects.delete(USER.id);
    await expect(service.rotate(tokens.refreshToken)).rejects.toMatchObject({
      code: 'SESSION_INVALID',
    });
  });
});
