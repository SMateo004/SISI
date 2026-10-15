import { createContext, Script } from 'node:vm';

/**
 * Protección contra regex lentos (ReDoS), ADR-0018. Sin dependencias nativas (RE2 necesita
 * binarios): validación estática conservadora al guardar + ejecución con tiempo límite
 * dentro de `vm` (V8 interrumpe el backtracking al vencer el timeout).
 */
export const MAX_PATTERN_LENGTH = 100;
/**
 * Tiempo por entrada adversaria al guardar. Un patrón catastrófico tarda segundos con 500
 * caracteres; 100 ms (y un reintento) evita rechazar patrones sanos cuando la CPU está
 * ocupada (pausas de GC, otros procesos).
 */
export const SAVE_TEST_TIMEOUT_MS = 100;
export const MATCH_TIMEOUT_MS = 50;
export const REGEX_FLAGS = 'iu';

export type PatternCheck = { ok: true; regex: RegExp } | { ok: false; reason: string };

const BACKREFERENCE = /\\[1-9]|\\k</;
const LOOKAROUND_OR_NAMED = /\(\?(?:[=!]|<)/;
/** Grupo que contiene un cuantificador y a su vez está cuantificado: (a+)+, (a*)*, (a{2,})+ */
const NESTED_QUANTIFIER =
  /\((?:[^()\\]|\\.)*(?:[+*]|\{\d+,?\d*\})(?:[^()\\]|\\.)*\)(?:[+*]|\{\d+,?\d*\})/;
/** Grupo con alternativas que está cuantificado: (a|ab)+ puede ser exponencial. */
const QUANTIFIED_ALTERNATION = /\((?:[^()\\]|\\.)*\|(?:[^()\\]|\\.)*\)(?:[+*]|\{\d+,?\d*\})/;

/** Entradas adversarias típicas para patrones con backtracking catastrófico. */
function adversarialInputs(pattern: string): string[] {
  const literals = [...new Set(pattern.replace(/\\./g, '').replace(/[^a-z0-9 ]/gi, ''))].slice(
    0,
    5,
  );
  const chars = literals.length > 0 ? literals : ['a'];
  const inputs = chars.flatMap((c) => [c.repeat(500) + '!', (c + ' ').repeat(250) + '!']);
  inputs.push('a'.repeat(1000) + '!', ' '.repeat(1000) + '!', 'ab'.repeat(500) + '!');
  return inputs;
}

/**
 * Ejecuta `fn` de forma síncrona con un tiempo límite. Devuelve `timeout` si se excede.
 * Las funciones se ejecutan dentro del contexto de vm para que el timeout las alcance.
 */
export function runWithTimeout<T>(
  fn: () => T,
  timeoutMs: number,
): { ok: true; value: T } | { ok: false } {
  const context = createContext({ fn });
  try {
    const value = new Script('fn()').runInContext(context, { timeout: timeoutMs }) as T;
    return { ok: true, value };
  } catch (error) {
    if ((error as { code?: string }).code === 'ERR_SCRIPT_EXECUTION_TIMEOUT') return { ok: false };
    throw error;
  }
}

/** Valida un patrón antes de guardarlo. */
export function checkPattern(pattern: string): PatternCheck {
  if (pattern.length === 0) return { ok: false, reason: 'El patrón está vacío.' };
  if (pattern.length > MAX_PATTERN_LENGTH) {
    return { ok: false, reason: `El patrón admite hasta ${MAX_PATTERN_LENGTH} caracteres.` };
  }
  let regex: RegExp;
  try {
    regex = new RegExp(pattern, REGEX_FLAGS);
  } catch {
    return { ok: false, reason: 'El patrón no es una expresión regular válida.' };
  }
  if (BACKREFERENCE.test(pattern)) {
    return { ok: false, reason: 'No se permiten referencias hacia atrás (\\1, \\k<...>).' };
  }
  if (LOOKAROUND_OR_NAMED.test(pattern)) {
    return { ok: false, reason: 'No se permiten lookahead, lookbehind ni grupos con nombre.' };
  }
  if (NESTED_QUANTIFIER.test(pattern) || QUANTIFIED_ALTERNATION.test(pattern)) {
    return {
      ok: false,
      reason:
        'No se permiten cuantificadores anidados ni alternativas repetidas: pueden ser muy lentos.',
    };
  }
  for (const input of adversarialInputs(pattern)) {
    // Solo se rechaza si se pasa del tiempo dos veces seguidas (no por una pausa puntual).
    const slow = [1, 2].every(
      () => !runWithTimeout(() => regex.test(input), SAVE_TEST_TIMEOUT_MS).ok,
    );
    if (slow) {
      return { ok: false, reason: 'El patrón es demasiado lento con ciertos textos.' };
    }
  }
  return { ok: true, regex };
}
