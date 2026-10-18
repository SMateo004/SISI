import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

/** Marcador de texto sin revisión legal (ADR-0051). Producción no arranca ni se construye con él. */
export const LEGAL_DRAFT_MARKER = 'PENDIENTE DE REVISIÓN LEGAL';

export type LegalType = 'terms' | 'privacy';

export interface LegalSource {
  file: string;
  type: LegalType;
  version: number;
  title: string;
  contentMd: string;
}

export const isDraft = (content: string): boolean => content.includes(LEGAL_DRAFT_MARKER);

/** Lee un texto legal con su encabezado (type, version, title). */
export function parseLegalFile(file: string, raw: string): LegalSource {
  const match = /^---\r?\n([\s\S]*?)\r?\n---\r?\n([\s\S]*)$/.exec(raw);
  if (!match) throw new Error(`${file}: falta el encabezado --- type/version/title ---`);
  const header = Object.fromEntries(
    (match[1] ?? '')
      .split(/\r?\n/)
      .map((line) => /^(\w+):\s*(.+)$/.exec(line.trim()))
      .filter((m): m is RegExpExecArray => m !== null)
      .map((m) => [m[1], m[2]?.trim()]),
  ) as Record<string, string | undefined>;
  const type = header.type;
  const version = Number(header.version);
  if (type !== 'terms' && type !== 'privacy')
    throw new Error(`${file}: type debe ser terms o privacy`);
  if (!Number.isInteger(version) || version < 1)
    throw new Error(`${file}: version debe ser un entero ≥ 1`);
  if (!header.title) throw new Error(`${file}: falta title`);
  return { file, type, version, title: header.title, contentMd: (match[2] ?? '').trim() };
}

/** Todos los textos de backend/legal (la fuente de verdad; el seed los carga en la base). */
export function readLegalSources(dir = join(process.cwd(), 'legal')): LegalSource[] {
  return readdirSync(dir)
    .filter((f) => f.endsWith('.md'))
    .sort()
    .map((f) => parseLegalFile(f, readFileSync(join(dir, f), 'utf8')));
}
