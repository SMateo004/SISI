import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AuditHook } from '../audit/admin-audit.service';
import { ApiError } from '../common/errors/api-error';
import { normalizePhone } from '../common/phone/phone';
import type { AppConfigService } from '../config/app-config';
import { FeatureFlagsService } from '../feature-flags/feature-flags.service';
import { PILOT_FLAG, pilotOnlyTextsActive } from '../legal/pilot-texts';
import { PrismaService } from '../prisma/prisma.service';

export { PILOT_FLAG };

export interface PilotInterestInput {
  phone: string;
  role: 'worker' | 'employer' | 'ambos';
  categoryId?: string;
  zone?: string;
}

/**
 * Piloto cerrado (ADR-0052). Con el flag `pilot.closed` encendido en la ciudad, un número que no
 * tiene cuenta y no está en la lista no recibe código (no se gasta un SMS): la app le muestra
 * "Pronto en tu zona" y puede dejar su interés. Las cuentas existentes siguen entrando.
 * Hoy toda cuenta nueva nace en la ciudad por defecto; la lista es por ciudad para cuando haya más.
 */
@Injectable()
export class PilotService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly flags: FeatureFlagsService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async defaultCity(): Promise<{ id: string; name: string }> {
    return this.prisma.city.findUniqueOrThrow({
      where: { slug: this.config.get('DEFAULT_CITY_SLUG', { infer: true }) },
      select: { id: true, name: true },
    });
  }

  /**
   * Cerrado con el flag encendido. En producción, además, mientras los textos vigentes sean los
   * v0 del piloto (ADR-0051): si el flag faltara o se apagara, se falla cerrado.
   */
  async isClosed(cityId: string): Promise<boolean> {
    if (await this.flags.isEnabled(PILOT_FLAG, cityId)) return true;
    if (this.config.get('APP_ENV', { infer: true }) !== 'production') return false;
    return pilotOnlyTextsActive(this.prisma);
  }

  /** Lanza 403 PILOT_NOT_ALLOWED si ese número no puede crear una cuenta hoy. */
  async assertCanSignIn(phoneE164: string): Promise<void> {
    const city = await this.defaultCity();
    if (!(await this.isClosed(city.id))) return;
    const existing = await this.prisma.user.findUnique({
      where: { phone: phoneE164 },
      select: { id: true },
    });
    if (existing) return;
    const allowed = await this.prisma.pilotAllowedPhone.findUnique({
      where: { cityId_phone: { cityId: city.id, phone: phoneE164 } },
      select: { id: true },
    });
    if (allowed) return;
    throw new ApiError(
      HttpStatus.FORBIDDEN,
      'PILOT_NOT_ALLOWED',
      `Pronto en tu zona. Por ahora la app funciona solo con invitación en ${city.name}.`,
      { cityName: city.name },
    );
  }

  private normalize(raw: string): string {
    return normalizePhone(raw, this.config.get('PHONE_ALLOWED_COUNTRY_CODES', { infer: true }));
  }

  /** "Pronto en tu zona": guarda (o actualiza) el interés de ese número. */
  async registerInterest(input: PilotInterestInput): Promise<void> {
    let phone: string;
    try {
      phone = this.normalize(input.phone);
    } catch {
      throw new ApiError(HttpStatus.BAD_REQUEST, 'PHONE_INVALID', 'Revisa el número de celular.');
    }
    const city = await this.defaultCity();
    const categoryId = input.categoryId
      ? ((await this.prisma.category.findUnique({ where: { id: input.categoryId } }))?.id ?? null)
      : null;
    const data = {
      role: input.role,
      categoryId,
      zone: input.zone?.trim() ? input.zone.trim() : null,
    };
    await this.prisma.pilotInterest.upsert({
      where: { cityId_phone: { cityId: city.id, phone } },
      create: { cityId: city.id, phone, ...data },
      update: data,
    });
  }

  // ─── Panel ───

  async overview(cityId?: string) {
    const city = cityId
      ? await this.prisma.city.findUniqueOrThrow({
          where: { id: cityId },
          select: { id: true, name: true },
        })
      : await this.defaultCity();
    const [enabled, allowlist, interestCount] = await Promise.all([
      this.flags.isEnabled(PILOT_FLAG, city.id),
      this.prisma.pilotAllowedPhone.findMany({
        where: { cityId: city.id },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.pilotInterest.count({ where: { cityId: city.id } }),
    ]);
    return { city, enabled, allowlist, interestCount };
  }

  /**
   * Agrega números (pegados de una lista: uno por línea, con o sin +591). Devuelve los agregados,
   * los que ya estaban y los inválidos. Queda en la auditoría.
   */
  async addPhones(
    cityId: string,
    rawPhones: string[],
    note: string | undefined,
    adminId: string,
    audit: AuditHook,
    reason: string,
  ) {
    const invalid: string[] = [];
    const phones = new Set<string>();
    for (const raw of rawPhones.map((p) => p.trim()).filter(Boolean)) {
      try {
        phones.add(this.normalize(raw));
      } catch {
        invalid.push(raw);
      }
    }
    return this.prisma.$transaction(async (tx) => {
      const existing = new Set(
        (
          await tx.pilotAllowedPhone.findMany({
            where: { cityId, phone: { in: [...phones] } },
            select: { phone: true },
          })
        ).map((r) => r.phone),
      );
      const added = [...phones].filter((p) => !existing.has(p));
      if (added.length > 0) {
        await tx.pilotAllowedPhone.createMany({
          data: added.map((phone) => ({ cityId, phone, note: note ?? null, addedById: adminId })),
        });
        await audit.record(tx, {
          action: 'pilot.allowlist_add',
          targetType: 'city',
          targetId: cityId,
          cityId,
          before: null,
          after: { added: added.length, note: note ?? null },
          reason,
        });
      }
      return { added, alreadyListed: [...existing], invalid };
    });
  }

  async removePhone(id: string, audit: AuditHook, reason: string): Promise<void> {
    await this.prisma.$transaction(async (tx) => {
      const row = await tx.pilotAllowedPhone.findUnique({ where: { id } });
      if (!row) {
        throw new ApiError(
          HttpStatus.NOT_FOUND,
          'PILOT_PHONE_NOT_FOUND',
          'Ese número no está en la lista.',
        );
      }
      await tx.pilotAllowedPhone.delete({ where: { id } });
      await audit.record(tx, {
        action: 'pilot.allowlist_remove',
        targetType: 'city',
        targetId: row.cityId,
        cityId: row.cityId,
        before: { phone: row.phone, note: row.note },
        after: null,
        reason,
      });
    });
  }

  async interest(cityId: string | undefined, take = 200) {
    const city = cityId ? { id: cityId } : await this.defaultCity();
    return this.prisma.pilotInterest.findMany({
      where: { cityId: city.id },
      orderBy: { createdAt: 'desc' },
      take,
      include: { category: { select: { name: true } } },
    });
  }
}
