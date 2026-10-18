import { HttpStatus, Injectable } from '@nestjs/common';
import { AdminAuditService } from '../audit/admin-audit.service';
import type { AdminContext } from '../audit/admin-context';
import { ApiError } from '../common/errors/api-error';
import type { ModerationTerm } from '../generated/prisma/client';
import { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import type {
  CreateModerationTermDto,
  ModerationTermDto,
  ModerationTestResultDto,
  UpdateModerationTermDto,
} from './dto/moderation-terms.dto';
import { ModerationService } from './moderation.service';

const toDto = (t: ModerationTerm): ModerationTermDto => ({
  id: t.id,
  term: t.term,
  kind: t.kind,
  category: t.category,
  active: t.active,
  note: t.note,
});

const notFound = (): ApiError =>
  new ApiError(HttpStatus.NOT_FOUND, 'MODERATION_TERM_NOT_FOUND', 'El término no existe.');

const snapshot = (t: ModerationTerm) => ({
  term: t.term,
  kind: t.kind,
  category: t.category,
  active: t.active,
  note: t.note,
});

/**
 * Términos del filtro (ADR-0018) desde el panel. Los regex se validan con
 * ModerationService.validate; cada cambio se audita y, ya confirmado, invalida la versión
 * para que la API y el worker recarguen los términos.
 */
@Injectable()
export class ModerationTermsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly moderation: ModerationService,
    private readonly audit: AdminAuditService,
  ) {}

  async list(includeInactive: boolean): Promise<ModerationTermDto[]> {
    const terms = await this.prisma.moderationTerm.findMany({
      where: includeInactive ? {} : { active: true },
      orderBy: [{ category: 'asc' }, { term: 'asc' }],
    });
    return terms.map(toDto);
  }

  async create(ctx: AdminContext, dto: CreateModerationTermDto): Promise<ModerationTermDto> {
    const term = this.moderation.validate(dto.term, dto.kind);
    try {
      const created = await this.prisma.$transaction(async (tx) => {
        const row = await tx.moderationTerm.create({
          data: {
            term,
            kind: dto.kind,
            category: dto.category,
            note: dto.note,
            createdById: ctx.adminId,
          },
        });
        await this.audit.record(tx, ctx, {
          action: 'moderation.term_create',
          targetType: 'moderation_term',
          targetId: row.id,
          after: snapshot(row),
          reason: dto.note ?? null,
        });
        return row;
      });
      await this.moderation.invalidate();
      return toDto(created);
    } catch (error) {
      if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === 'P2002') {
        throw new ApiError(HttpStatus.CONFLICT, 'MODERATION_TERM_EXISTS', 'Ese término ya existe.');
      }
      throw error;
    }
  }

  update(ctx: AdminContext, id: string, dto: UpdateModerationTermDto): Promise<ModerationTermDto> {
    return this.change(ctx, id, dto, 'moderation.term_update');
  }

  /** Baja lógica: el término deja de aplicarse, pero queda su historia. */
  async deactivate(ctx: AdminContext, id: string): Promise<void> {
    await this.change(ctx, id, { active: false }, 'moderation.term_deactivate');
  }

  /** Probador: qué términos vigentes coinciden con un texto. No guarda nada. */
  async test(text: string): Promise<ModerationTestResultDto> {
    const result = await this.moderation.check(text);
    return {
      held: result.held,
      timedOut: result.timedOut,
      matches: result.matches.map((m) => ({
        termId: m.termId,
        term: m.term,
        kind: m.kind,
        category: m.category,
      })),
    };
  }

  private async change(
    ctx: AdminContext,
    id: string,
    data: UpdateModerationTermDto,
    action: string,
  ): Promise<ModerationTermDto> {
    const updated = await this.prisma.$transaction(async (tx) => {
      const before = await tx.moderationTerm.findUnique({ where: { id } });
      if (!before) throw notFound();
      const after = await tx.moderationTerm.update({ where: { id }, data });
      await this.audit.record(tx, ctx, {
        action,
        targetType: 'moderation_term',
        targetId: id,
        before: snapshot(before),
        after: snapshot(after),
        reason: data.note ?? null,
      });
      return after;
    });
    await this.moderation.invalidate();
    return toDto(updated);
  }
}
