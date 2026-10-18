import { Inject, Injectable, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import {
  PrismaRefreshTokenRepository,
  REFRESH_TOKEN_REPOSITORY,
} from '../auth/tokens/refresh-token.repository';
import {
  TOKEN_SUBJECT_LOADER,
  type TokenSubjectLoader,
  TokenService,
} from '../auth/tokens/token.service';
import type { AppConfigService } from '../config/app-config';
import { PrismaService } from '../prisma/prisma.service';
import type { WorkerStatusService } from '../workers/worker-status.service';

/**
 * Usuarios de la prueba de carga (ADR-0053): solo en local y staging, nunca en producción.
 * Teléfonos de un rango reservado (+591 699xxxxx), trabajadores aprobados en plomería y textos
 * legales aceptados; devuelve los tokens para k6 (sin SMS: staging no puede leer códigos).
 */
export const LOADTEST_PHONE_PREFIX = '+591699';

export interface SeededUser {
  id: string;
  phone: string;
  accessToken: string;
  refreshToken: string;
}

@Injectable()
export class LoadtestSeeder {
  constructor(
    private readonly prisma: PrismaService,
    private readonly tokens: TokenService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  private async user(index: number): Promise<{ id: string; phone: string }> {
    const phone = `${LOADTEST_PHONE_PREFIX}${String(index).padStart(5, '0')}`;
    const city = await this.prisma.city.findUniqueOrThrow({
      where: { slug: this.config.get('DEFAULT_CITY_SLUG', { infer: true }) },
    });
    const user = await this.prisma.user.upsert({
      where: { phone },
      create: {
        phone,
        cityId: city.id,
        phoneVerifiedAt: new Date(),
        name: `Carga ${String(index)}`,
      },
      update: {},
    });
    // Textos legales vigentes aceptados (si no, la API responde 403).
    const docs = await this.prisma.legalDocument.findMany({ orderBy: { version: 'desc' } });
    for (const type of ['terms', 'privacy'] as const) {
      const doc = docs.find((d) => d.type === type);
      if (!doc) continue;
      const accepted = await this.prisma.legalAcceptance.count({
        where: { userId: user.id, type, version: doc.version },
      });
      if (accepted === 0) {
        await this.prisma.legalAcceptance.create({
          data: {
            userId: user.id,
            type,
            version: doc.version,
            adultDeclared: true,
            platform: 'loadtest',
          },
        });
      }
    }
    return { id: user.id, phone };
  }

  private async session(u: { id: string; phone: string }): Promise<SeededUser> {
    const pair = await this.tokens.issue({ id: u.id, role: 'user' });
    return { ...u, accessToken: pair.accessToken, refreshToken: pair.refreshToken };
  }

  /** `statuses`: el WorkerStatusService de dev-tools (el estado solo cambia por ahí, ADR-0013). */
  async seed(
    workers: number,
    employers: number,
    statuses: WorkerStatusService,
  ): Promise<{ workers: SeededUser[]; employers: SeededUser[] }> {
    if (!['local', 'staging'].includes(this.config.get('APP_ENV', { infer: true }))) {
      throw new Error('La prueba de carga solo corre en local o staging (ADR-0053).');
    }
    const category = await this.prisma.category.findUniqueOrThrow({ where: { slug: 'plomeria' } });
    const outWorkers: SeededUser[] = [];
    for (let i = 0; i < workers; i++) {
      const u = await this.user(i);
      const profile = await this.prisma.workerProfile.findUnique({ where: { userId: u.id } });
      if (profile?.status !== 'aprobado') {
        await statuses.apply(u.id, { type: 'SUBMIT' }, null, async (tx) => {
          await tx.workerCategory.deleteMany({ where: { workerId: u.id } });
          await tx.workerProfile.update({
            where: { userId: u.id },
            data: {
              transport: 'moto',
              maxRadiusKm: 10,
              birthDate: new Date('1995-01-01'),
              categories: { create: [{ categoryId: category.id }] },
            },
          });
        });
        await statuses.apply(u.id, { type: 'APPROVE' }, null);
      }
      await this.prisma.user.update({ where: { id: u.id }, data: { activeMode: 'worker' } });
      outWorkers.push(await this.session(u));
    }
    const outEmployers: SeededUser[] = [];
    for (let i = 0; i < employers; i++) {
      const u = await this.user(50_000 + i);
      await this.prisma.user.update({ where: { id: u.id }, data: { activeMode: 'employer' } });
      outEmployers.push(await this.session(u));
    }
    return { workers: outWorkers, employers: outEmployers };
  }

  /** Conexiones a Postgres por estado (para medir el pool durante la prueba). */
  async dbStats(): Promise<{ state: string; n: number }[]> {
    return this.prisma.$queryRaw<{ state: string; n: number }[]>`
      SELECT COALESCE(state, 'sin estado') AS state, COUNT(*)::int AS n
      FROM pg_stat_activity WHERE datname = current_database() GROUP BY 1 ORDER BY 1`;
  }
}

/** TokenService sin el resto de la autenticación (OTP, guards). */
@Module({
  imports: [
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: AppConfigService) => ({
        secret: config.get('JWT_SECRET', { infer: true }),
        signOptions: { algorithm: 'HS256' },
      }),
    }),
  ],
  providers: [
    TokenService,
    { provide: REFRESH_TOKEN_REPOSITORY, useClass: PrismaRefreshTokenRepository },
    {
      provide: TOKEN_SUBJECT_LOADER,
      inject: [PrismaService],
      useFactory:
        (prisma: PrismaService): TokenSubjectLoader =>
        async (userId) => {
          const user = await prisma.user.findUnique({ where: { id: userId } });
          return user ? { id: user.id, role: user.role } : null;
        },
    },
    LoadtestSeeder,
  ],
  exports: [LoadtestSeeder],
})
export class LoadtestModule {}
