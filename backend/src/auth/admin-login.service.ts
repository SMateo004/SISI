import { HttpStatus, Inject, Injectable, Logger, type OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { timingSafeEqual } from 'node:crypto';
import type { Redis } from 'ioredis';
import { ApiError } from '../common/errors/api-error';
import { RateLimitedException } from '../common/rate-limit/rate-limited.exception';
import { RateLimitStore } from '../common/rate-limit/rate-limit.store';
import type { AppConfigService } from '../config/app-config';
import { reportAlert } from '../observability/sentry';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import { base32Decode, matchTotp, TOTP_STEP_SEC } from './admin-totp';
import type { TokenSubject } from './tokens/token.service';

/**
 * Cuenta del panel (ADR-0055). No es de ninguna persona ni tiene teléfono: el valor de `phone`
 * no es E.164, así que nunca recibe un código ni entra a la app. Es el actor de la auditoría.
 */
export const ADMIN_ACCOUNT_PHONE = 'panel:admin';
const ADMIN_ACCOUNT_NAME = 'Administrador';

const FAILURES_KEY = 'admin:login:failures';
/** Avisar al quinto fallo en 15 min: un error de tipeo no alcanza, un ataque sí. */
export const FAILURE_ALERT_AT = 5;

const invalid = (): ApiError =>
  new ApiError(HttpStatus.UNAUTHORIZED, 'ADMIN_LOGIN_INVALID', 'Usuario o código incorrecto.');

const sameText = (a: string, b: string): boolean => {
  const left = Buffer.from(a);
  const right = Buffer.from(b);
  return left.length === right.length && timingSafeEqual(left, right);
};

/**
 * Ingreso al panel con usuario fijo y código de una app autenticadora (TOTP).
 * - Un código sirve una sola vez (Redis), aunque siga vigente en la app.
 * - Además del límite por IP, topes de intentos sumando todas las IP (15 min y día): hay una
 *   sola cuenta y un solo factor. Los fallos repetidos y el bloqueo avisan por Sentry.
 */
@Injectable()
export class AdminLoginService implements OnModuleInit {
  private readonly logger = new Logger(AdminLoginService.name);

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    private readonly limits: RateLimitStore,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  onModuleInit(): void {
    const production = this.config.get('APP_ENV', { infer: true }) === 'production';
    if (production && !this.config.get('ADMIN_TOTP_SECRET', { infer: true })) {
      throw new Error(
        'Producción no arranca sin ADMIN_TOTP_SECRET (ingreso al panel, ADR-0055). Genérala con dev-tools admin-totp en local.',
      );
    }
  }

  async login(username: string, code: string, now = Date.now()): Promise<TokenSubject> {
    const secret = this.config.get('ADMIN_TOTP_SECRET', { infer: true });
    if (!secret) {
      throw new ApiError(
        HttpStatus.SERVICE_UNAVAILABLE,
        'ADMIN_LOGIN_NOT_CONFIGURED',
        'El ingreso al panel no está configurado (falta ADMIN_TOTP_SECRET).',
      );
    }
    const decision = await this.limits.consume([
      {
        key: 'adminLogin:all',
        limit: this.config.get('RATE_ADMIN_LOGIN_PER_15MIN', { infer: true }),
        windowSec: 900,
      },
      {
        key: 'adminLogin:day',
        limit: this.config.get('RATE_ADMIN_LOGIN_PER_DAY', { infer: true }),
        windowSec: 86_400,
      },
    ]);
    if (!decision.allowed) {
      this.logger.warn('Ingreso al panel bloqueado por exceso de intentos');
      reportAlert('admin-login-blocked', 'Ingreso al panel bloqueado por exceso de intentos', {
        rule: decision.rule.key,
        retryAfterSec: decision.retryAfterSec,
      });
      throw new RateLimitedException(decision.retryAfterSec);
    }

    const userOk = sameText(username.trim().toLowerCase(), this.username());
    const step = matchTotp(base32Decode(secret), code.trim(), now);
    if (!userOk || step === null) {
      await this.recordFailure();
      throw invalid();
    }

    // Un código, una vez: guardado hasta que deja de ser válido (paso + margen de un paso).
    const fresh = await this.redis.set(
      `admin:totp:used:${String(step)}`,
      '1',
      'EX',
      TOTP_STEP_SEC * 4,
      'NX',
    );
    if (fresh !== 'OK') {
      throw new ApiError(
        HttpStatus.UNAUTHORIZED,
        'ADMIN_CODE_USED',
        'Ese código ya se usó. Espera el siguiente en tu app autenticadora.',
      );
    }
    return this.account();
  }

  /** Fallos seguidos en 15 min: al llegar a FAILURE_ALERT_AT avisa una vez (ADR-0048). */
  private async recordFailure(): Promise<void> {
    const failures = await this.redis.incr(FAILURES_KEY);
    if (failures === 1) await this.redis.expire(FAILURES_KEY, 900);
    if (failures === FAILURE_ALERT_AT) {
      this.logger.warn(`Intentos fallidos de ingreso al panel: ${String(failures)} en 15 min`);
      reportAlert('admin-login-failures', 'Intentos fallidos de ingreso al panel', { failures });
    }
  }

  private username(): string {
    return this.config.get('ADMIN_USERNAME', { infer: true }).trim().toLowerCase();
  }

  /** La cuenta del panel; se crea la primera vez que alguien ingresa. */
  async account(): Promise<TokenSubject> {
    const city = await this.prisma.city.findUniqueOrThrow({
      where: { slug: this.config.get('DEFAULT_CITY_SLUG', { infer: true }) },
      select: { id: true },
    });
    const user = await this.prisma.user.upsert({
      where: { phone: ADMIN_ACCOUNT_PHONE },
      create: {
        phone: ADMIN_ACCOUNT_PHONE,
        name: ADMIN_ACCOUNT_NAME,
        role: 'admin',
        cityId: city.id,
      },
      update: { role: 'admin' },
      select: { id: true, role: true },
    });
    return { id: user.id, role: user.role };
  }
}
