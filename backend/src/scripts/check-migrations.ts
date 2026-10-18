import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

/**
 * Expandir y luego contraer (ADR-0046): una migración se aplica antes de que arranque el código
 * nuevo y el anterior sigue atendiendo mientras tanto, así que nunca puede romperlo. Las
 * sentencias destructivas solo pasan con una marca explícita en la línea anterior:
 *
 *   -- contract: <motivo y release en la que el código dejó de usarlo>
 *
 * Uso: npm run check:migrations (corre en backend-ci y en deploy-production).
 */

/**
 * Las migraciones hasta esta (incluida) son anteriores al primer despliegue a producción: no
 * había código viejo corriendo. No se editan (cambiaría su checksum); las nuevas sí se revisan.
 */
export const PRE_PRODUCTION_BASELINE = '20261020000000_outbox_request_id';
const DESTRUCTIVE: { pattern: RegExp; what: string }[] = [
  {
    pattern: /\bDROP\s+(TABLE|COLUMN|TYPE|SCHEMA|VIEW|FUNCTION|TRIGGER|CONSTRAINT|INDEX)\b/i,
    what: 'DROP',
  },
  { pattern: /\bRENAME\b/i, what: 'RENAME' },
  { pattern: /\bSET\s+NOT\s+NULL\b/i, what: 'SET NOT NULL' },
  { pattern: /\bTRUNCATE\b/i, what: 'TRUNCATE' },
  {
    pattern: /\bALTER\s+COLUMN\s+\S+\s+(SET\s+DATA\s+)?TYPE\b/i,
    what: 'cambio de tipo de columna',
  },
  { pattern: /\bDELETE\s+FROM\b/i, what: 'DELETE' },
];

export interface MigrationProblem {
  line: number;
  what: string;
  text: string;
}

/** Sentencias destructivas sin `-- contract:` en la línea anterior (los comentarios no cuentan). */
export function findDestructive(sql: string): MigrationProblem[] {
  const lines = sql.split(/\r?\n/);
  const problems: MigrationProblem[] = [];
  lines.forEach((raw, i) => {
    const code = raw.replace(/--.*$/, '');
    for (const { pattern, what } of DESTRUCTIVE) {
      if (!pattern.test(code)) continue;
      const previous = (lines[i - 1] ?? '').trim();
      if (/^--\s*contract:\s*\S/i.test(previous)) continue;
      problems.push({ line: i + 1, what, text: raw.trim() });
    }
  });
  return problems;
}

function main(): void {
  const dir = join(process.cwd(), 'prisma', 'migrations');
  let failed = false;
  for (const name of readdirSync(dir).sort()) {
    if (name <= PRE_PRODUCTION_BASELINE) continue;
    let sql: string;
    try {
      sql = readFileSync(join(dir, name, 'migration.sql'), 'utf8');
    } catch {
      continue;
    }
    for (const p of findDestructive(sql)) {
      failed = true;
      console.error(
        `${name}/migration.sql:${String(p.line)} ${p.what} sin "-- contract:": ${p.text}`,
      );
    }
  }
  if (failed) {
    console.error('\nUna migración no puede romper el código que sigue corriendo (ADR-0046).');
    process.exit(1);
  }
  console.log('Migraciones compatibles hacia atrás.');
}

if (
  process.argv[1]?.endsWith('check-migrations.ts') ||
  process.argv[1]?.endsWith('check-migrations.js')
) {
  main();
}
