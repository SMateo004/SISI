/**
 * Normalización de texto para moderación (R9.2, ADR-0018). El resultado solo se usa para
 * comparar; nunca se muestra ni se guarda en lugar del texto original.
 *
 * 1. Minúsculas y sin tildes (NFD + quitar marcas): "Cocaína" → "cocaina", "ñ" → "n".
 * 2. Sustituciones leet solo dentro de palabras con letras: "c0c4" → "coca"; "4 horas" no cambia.
 * 3. Todo lo que no es letra ni dígito separa palabras.
 * 4. Letras repetidas colapsadas: "cocaaaa" → "coca" (los términos se normalizan igual).
 * 5. Evasión por separación: 3 o más letras sueltas seguidas se unen ("c.o.c.a" → "coca").
 */
const LEET: Record<string, string> = {
  '0': 'o',
  '1': 'i',
  '3': 'e',
  '4': 'a',
  '5': 's',
  '7': 't',
  '@': 'a',
  $: 's',
};

const HAS_LETTER = /\p{L}/u;
const SEPARATORS = /[^\p{L}\p{N}]+/gu;
const REPEATED = /(\p{L})\1+/gu;

function deLeet(word: string): string {
  if (!HAS_LETTER.test(word.replace(/[@$]/g, 'a'))) return word;
  return word.replace(/[013457@$]/g, (ch) => LEET[ch] ?? ch);
}

/** Une secuencias de ≥3 letras sueltas ("c o c a" → "coca"). */
function joinSpelledOut(tokens: string[]): string[] {
  const out: string[] = [];
  let run: string[] = [];
  const flush = (): void => {
    if (run.length >= 3) out.push(run.join(''));
    else out.push(...run);
    run = [];
  };
  for (const token of tokens) {
    if (token.length === 1 && HAS_LETTER.test(token)) {
      run.push(token);
    } else {
      flush();
      out.push(token);
    }
  }
  flush();
  return out;
}

/** Palabras normalizadas del texto. */
export function normalizeTokens(input: string): string[] {
  const lowered = input.toLowerCase().normalize('NFD').replace(/\p{M}/gu, '');
  // Leet por palabra (separando solo por espacios, para no perder "c0c@" antes de quitar símbolos).
  const deLeeted = lowered.split(/\s+/).map(deLeet).join(' ');
  const tokens = deLeeted
    .replace(SEPARATORS, ' ')
    .trim()
    .split(' ')
    .filter((t) => t.length > 0)
    .map((t) => t.replace(REPEATED, '$1'));
  return joinSpelledOut(tokens);
}

/** Texto normalizado como una sola cadena separada por espacios (para los regex). */
export function normalizeText(input: string): string {
  return normalizeTokens(input).join(' ');
}

/**
 * Término de tipo `word`: una o más palabras; un `*` al final de una palabra la
 * convierte en prefijo ("prostitut*" coincide con "prostituta", "prostitutas").
 */
export interface WordPattern {
  parts: { value: string; prefix: boolean }[];
}

export function compileWordTerm(term: string): WordPattern {
  const parts = term
    .trim()
    .split(/\s+/)
    .filter((p) => p.length > 0)
    .map((raw) => {
      const prefix = raw.endsWith('*');
      const value = normalizeTokens(prefix ? raw.slice(0, -1) : raw).join('');
      return { value, prefix };
    })
    .filter((p) => p.value.length > 0);
  return { parts };
}

/** ¿Aparece la secuencia de palabras del término en el texto normalizado? */
export function matchesWord(tokens: readonly string[], pattern: WordPattern): boolean {
  const { parts } = pattern;
  if (parts.length === 0) return false;
  outer: for (let i = 0; i + parts.length <= tokens.length; i++) {
    for (let j = 0; j < parts.length; j++) {
      const part = parts[j];
      const token = tokens[i + j];
      if (!part || token === undefined) continue outer;
      const ok = part.prefix ? token.startsWith(part.value) : token === part.value;
      if (!ok) continue outer;
    }
    return true;
  }
  return false;
}
