import { MODERATION_TERMS } from '../../prisma/seed-data/moderation-terms';
import { compileWordTerm, matchesWord, normalizeText, normalizeTokens } from './normalize';
import { checkPattern, runWithTimeout } from './regex-safety';

const hit = (text: string, term: string): boolean =>
  matchesWord(normalizeTokens(text), compileWordTerm(term));

describe('normalizeText', () => {
  it('pasa a minúsculas y quita tildes', () => {
    expect(normalizeText('Cocaína ÚNICA Niño')).toBe('cocaina unica nino');
  });

  it('colapsa letras repetidas', () => {
    expect(normalizeText('cocaaaaína!!!')).toBe('cocaina');
  });

  it('aplica leet solo dentro de palabras con letras', () => {
    expect(normalizeText('c0c4ín4')).toBe('cocaina');
    expect(normalizeText('trabajo de 4 horas por 150')).toBe('trabajo de 4 horas por 150');
    expect(normalizeText('m@rihu@n@')).toBe('marihuana');
  });

  it('une letras sueltas separadas por puntos, espacios, guiones o guiones bajos', () => {
    expect(normalizeText('vendo c.o.c.a')).toBe('vendo coca');
    expect(normalizeText('vendo c o c a ya')).toBe('vendo coca ya');
    expect(normalizeText('p-i-c-h-i-c-a-t-a')).toBe('pichicata');
    expect(normalizeText('a_r_m_a')).toBe('arma');
  });

  it('no une solo dos letras sueltas (evita falsos positivos con "y", "a", "o")', () => {
    expect(normalizeText('casa y o patio')).toBe('casa y o patio');
  });
});

describe('términos de tipo palabra', () => {
  it('coincide por palabra completa, no dentro de otra palabra', () => {
    expect(hit('quiero comprar un arma', 'arma')).toBe(true);
    expect(hit('armar un armario', 'arma')).toBe(false);
  });

  it('el * final convierte la palabra en prefijo', () => {
    expect(hit('busco prostitutas', 'prostitut*')).toBe(true);
    expect(hit('busco prostituta', 'prostitut*')).toBe(true);
  });

  it('frases de varias palabras deben aparecer seguidas', () => {
    expect(hit('masaje con final feliz', 'final feliz')).toBe(true);
    expect(hit('al final quedé feliz', 'final feliz')).toBe(false);
  });

  it('detecta las evasiones simples', () => {
    expect(hit('Vendo C.O.C.A.Í.N.A barata', 'cocain*')).toBe(true);
    expect(hit('vendo c0c41n4', 'cocain*')).toBe(true);
    expect(hit('COCAAAAINA', 'cocain*')).toBe(true);
  });

  it('el término se normaliza igual que el texto (tildes y repeticiones)', () => {
    expect(hit('munición para pistola', 'municion*')).toBe(true);
    expect(hit('llave de paso', 'llave')).toBe(true);
  });
});

describe('protección de regex', () => {
  it('acepta patrones simples', () => {
    expect(checkPattern(String.raw`\bbs ?\d+ (?:cada uno|c u)\b`).ok).toBe(true);
  });

  it('rechaza patrones largos, inválidos, con referencias o lookaround', () => {
    expect(checkPattern('a'.repeat(101))).toMatchObject({ ok: false });
    expect(checkPattern('(abc')).toMatchObject({
      ok: false,
      reason: expect.stringContaining('válida') as string,
    });
    expect(checkPattern(String.raw`(a)\1`)).toMatchObject({ ok: false });
    expect(checkPattern('foo(?=bar)')).toMatchObject({ ok: false });
    expect(checkPattern('(?<!x)foo')).toMatchObject({ ok: false });
  });

  it('rechaza cuantificadores anidados y alternativas repetidas (ReDoS)', () => {
    for (const evil of ['(a+)+$', '(a*)*b', '(a{2,})+', '(a|aa)+$', '(x+x+)+y']) {
      expect(checkPattern(evil)).toMatchObject({ ok: false });
    }
  });

  it('el tiempo límite corta un regex catastrófico', () => {
    const evil = /^(a+)+$/;
    const started = Date.now();
    const result = runWithTimeout(() => evil.test('a'.repeat(40) + '!'), 30);
    expect(result.ok).toBe(false);
    expect(Date.now() - started).toBeLessThan(1000);
  });

  it('devuelve el resultado cuando termina a tiempo', () => {
    expect(runWithTimeout(() => 'hoja de coca'.includes('coca'), 30)).toEqual({
      ok: true,
      value: true,
    });
  });
});

describe('seed de términos', () => {
  it('todos los términos del seed son válidos', () => {
    for (const term of MODERATION_TERMS) {
      if (term.kind === 'regex')
        expect([term.term, checkPattern(term.term).ok]).toEqual([term.term, true]);
      else expect(compileWordTerm(term.term).parts.length).toBeGreaterThan(0);
    }
  });
});
