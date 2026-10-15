import { readdirSync } from 'node:fs';
import { basename, dirname } from 'node:path';

/**
 * Identificadores únicos dentro de una corrida e2e (ADR-0028), sin reloj ni azar.
 *
 * Jest da a cada archivo su propio registro de módulos, así que un contador de módulo
 * vuelve a 0 en cada archivo. Por eso cada archivo recibe un bloque fijo: su posición
 * entre los *.e2e-spec.ts ordenados. Entre corridas no se repiten porque global-setup
 * vacía la base y Redis, y el candado impide dos corridas a la vez.
 */
let cachedIndex: number | undefined;

function fileIndex(): number {
  if (cachedIndex !== undefined) return cachedIndex;
  const testPath = expect.getState().testPath;
  if (!testPath) throw new Error('unique.ts solo se usa dentro de un archivo de test');
  const specs = readdirSync(dirname(testPath))
    .filter((f) => f.endsWith('.e2e-spec.ts'))
    .sort();
  const index = specs.indexOf(basename(testPath));
  if (index < 0) throw new Error(`Archivo de test desconocido: ${testPath}`);
  if (index > 99) throw new Error('Más de 100 archivos e2e: ampliar el esquema de unique.ts');
  cachedIndex = index;
  return index;
}

let counter = 0;
const next = (): number => {
  if (counter >= 100_000) throw new Error('Más de 100 000 identificadores en un archivo');
  return counter++;
};

/**
 * Número en letras, para que la normalización de moderación no lo altere: sin dígitos
 * (el leet los cambia) y sin letras repetidas seguidas (se colapsan). Cada dígito en
 * base 25 (a-y) va precedido de "z".
 */
const letters = (n: number): string => {
  let s = '';
  do {
    s = `z${String.fromCharCode(97 + (n % 25))}${s}`;
    n = Math.floor(n / 25);
  } while (n > 0);
  return s;
};

/** Celular boliviano único (7 + 2 dígitos del archivo + 5 del contador). */
export const uniquePhone = (): string =>
  `7${String(fileIndex()).padStart(2, '0')}${String(next()).padStart(5, '0')}`;

/** IP única (vía X-Forwarded-For) para que los límites por IP no se crucen. */
export const uniqueIp = (): string => {
  const n = next();
  return `10.${fileIndex()}.${Math.floor(n / 250) % 250}.${(n % 250) + 1}`;
};

/** Sufijo único de solo letras (archivo + contador), para slugs, claves y términos. */
export const uniqueSuffix = (): string => {
  // El archivo ocupa siempre 2 grupos (25² > 100) para que la concatenación no sea ambigua.
  const file = fileIndex();
  return `${letters(Math.floor(file / 25)).slice(-2)}${letters(file % 25).slice(-2)}${letters(next())}`;
};
