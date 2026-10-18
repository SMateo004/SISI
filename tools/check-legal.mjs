#!/usr/bin/env node
// Falla si algún texto legal sigue siendo borrador (ADR-0051). Lo corren deploy-production y
// mobile-release: la versión de producción no se construye con marcadores.
// Los textos v0 del piloto cerrado (`stage: piloto-cerrado`) pasan si ya no tienen el marcador,
// pero solo valen con el piloto cerrado: el seed de producción enciende pilot.closed y la API no
// arranca si queda apagado.
import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const MARKER = 'PENDIENTE DE REVISIÓN LEGAL';
const PILOT_STAGE = /^stage:\s*piloto-cerrado\s*$/m;
const dir = fileURLToPath(new URL('../backend/legal/', import.meta.url));
const files = readdirSync(dir)
  .filter((f) => f.endsWith('.md'))
  .map((f) => ({ name: f, raw: readFileSync(`${dir}${f}`, 'utf8') }));
const drafts = files.filter((f) => f.raw.includes(MARKER)).map((f) => f.name);
if (drafts.length > 0) {
  console.error(`Textos legales sin revisión: ${drafts.join(', ')} (llevan "${MARKER}").`);
  console.error('Producción no se construye con borradores. Reemplázalos por el texto aprobado.');
  process.exit(1);
}
const pilot = files
  .filter((f) => PILOT_STAGE.test(f.raw.split(/\r?\n---\r?\n/)[0] ?? ''))
  .map((f) => f.name);
if (pilot.length > 0) {
  console.log(
    `Textos v0 del piloto cerrado: ${pilot.join(', ')}. Producción exige pilot.closed encendido (el seed lo enciende; la API no arranca sin él).`,
  );
} else {
  console.log('Textos legales finales.');
}
