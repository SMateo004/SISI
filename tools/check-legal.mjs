#!/usr/bin/env node
// Falla si algún texto legal sigue siendo borrador (ADR-0051). Lo corren deploy-production y
// mobile-release: la versión de producción no se construye con marcadores.
import { readdirSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const MARKER = 'PENDIENTE DE REVISIÓN LEGAL';
const dir = fileURLToPath(new URL('../backend/legal/', import.meta.url));
const drafts = readdirSync(dir)
  .filter((f) => f.endsWith('.md'))
  .filter((f) => readFileSync(`${dir}${f}`, 'utf8').includes(MARKER));
if (drafts.length > 0) {
  console.error(`Textos legales sin revisión: ${drafts.join(', ')} (llevan "${MARKER}").`);
  console.error('Producción no se construye con borradores. Reemplázalos por el texto aprobado.');
  process.exit(1);
}
console.log('Textos legales finales.');
