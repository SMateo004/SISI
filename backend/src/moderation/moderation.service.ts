import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Redis } from 'ioredis';
import { ApiError } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import type {
  ModerationTerm,
  ModerationTermKind,
  ProhibitedCategory,
} from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import {
  compileWordTerm,
  matchesWord,
  normalizeText,
  normalizeTokens,
  type WordPattern,
} from './normalize';
import { checkPattern, REGEX_FLAGS, runWithTimeout } from './regex-safety';

export interface ModerationMatch {
  termId: string;
  term: string;
  kind: ModerationTermKind;
  category: ProhibitedCategory;
}

export interface ModerationResult {
  /** Debe retenerse para revisión humana (R3.3). */
  held: boolean;
  matches: ModerationMatch[];
  /** Los regex no terminaron a tiempo: se retiene por seguridad. */
  timedOut: boolean;
}

interface CompiledTerms {
  version: string;
  words: { term: ModerationTerm; pattern: WordPattern }[];
  regexes: { term: ModerationTerm; regex: RegExp }[];
}

const VERSION_KEY = 'moderation:terms:version';
const MAX_TEXT_LENGTH = 5000;

/**
 * Filtro de texto reutilizable (solicitudes ahora; chat en la Fase 4). ADR-0018.
 * Los términos se compilan en memoria por instancia y se recargan cuando cambia la
 * versión guardada en Redis (cada alta, baja o edición la incrementa).
 */
@Injectable()
export class ModerationService {
  private readonly logger = new Logger(ModerationService.name);
  private compiled: CompiledTerms | null = null;

  constructor(
    private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async check(text: string): Promise<ModerationResult> {
    const terms = await this.terms();
    const input = text.slice(0, MAX_TEXT_LENGTH);
    const tokens = normalizeTokens(input);
    const matches: ModerationMatch[] = [];

    for (const { term, pattern } of terms.words) {
      if (matchesWord(tokens, pattern)) matches.push(toMatch(term));
    }

    let timedOut = false;
    if (terms.regexes.length > 0) {
      const normalized = normalizeText(input);
      // Todos los regex de un texto comparten un mismo presupuesto de tiempo.
      const result = runWithTimeout(
        () => terms.regexes.filter(({ regex }) => regex.test(normalized)).map(({ term }) => term),
        this.config.get('MODERATION_REGEX_TIMEOUT_MS', { infer: true }),
      );
      if (result.ok) matches.push(...result.value.map(toMatch));
      else {
        timedOut = true;
        this.logger.warn('Los regex de moderación excedieron el tiempo: se retiene por seguridad');
      }
    }
    return { held: matches.length > 0 || timedOut, matches, timedOut };
  }

  /** Valida un término antes de guardarlo (lanza 400 con el motivo). */
  validate(term: string, kind: ModerationTermKind): string {
    const trimmed = term.trim();
    if (kind === 'regex') {
      const check = checkPattern(trimmed);
      if (!check.ok)
        throw new ApiError(HttpStatus.BAD_REQUEST, 'MODERATION_PATTERN_INVALID', check.reason);
      return trimmed;
    }
    if (compileWordTerm(trimmed).parts.length === 0 || trimmed.length < 2) {
      throw new ApiError(
        HttpStatus.BAD_REQUEST,
        'MODERATION_TERM_INVALID',
        'El término debe tener al menos 2 letras.',
      );
    }
    return trimmed;
  }

  /** Marca que los términos cambiaron: todas las instancias recargan en la siguiente consulta. */
  async invalidate(): Promise<void> {
    await this.redis.incr(VERSION_KEY);
  }

  private async terms(): Promise<CompiledTerms> {
    const version = (await this.redis.get(VERSION_KEY)) ?? '0';
    if (this.compiled?.version === version) return this.compiled;

    const rows = await this.prisma.moderationTerm.findMany({ where: { active: true } });
    const compiled: CompiledTerms = { version, words: [], regexes: [] };
    for (const term of rows) {
      if (term.kind === 'word') {
        compiled.words.push({ term, pattern: compileWordTerm(term.term) });
        continue;
      }
      try {
        compiled.regexes.push({ term, regex: new RegExp(term.term, REGEX_FLAGS) });
      } catch {
        this.logger.error(`Patrón de moderación inválido ignorado: ${term.id}`);
      }
    }
    this.compiled = compiled;
    return compiled;
  }
}

const toMatch = (term: ModerationTerm): ModerationMatch => ({
  termId: term.id,
  term: term.term,
  kind: term.kind,
  category: term.category,
});
