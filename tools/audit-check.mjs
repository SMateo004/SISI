#!/usr/bin/env node
// npm audit de producción con excepciones documentadas (ADR-0047). Falla si aparece una
// vulnerabilidad alta o crítica que no está en docs/seguridad/audit-excepciones.json, o si una
// excepción venció. Uso: node tools/audit-check.mjs (desde la raíz; corre en security.yml).
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const allow = JSON.parse(readFileSync(`${root}docs/seguridad/audit-excepciones.json`, 'utf8'));
const today = new Date().toISOString().slice(0, 10);

let raw;
try {
  raw = execFileSync('npm', ['audit', '--omit=dev', '--json'], {
    cwd: `${root}backend`,
    encoding: 'utf8',
    shell: process.platform === 'win32',
  });
} catch (error) {
  // npm audit sale con código 1 cuando encuentra algo; el JSON igual viene en stdout.
  raw = error.stdout;
}
const report = JSON.parse(raw);
const problems = [];
for (const [name, vuln] of Object.entries(report.vulnerabilities ?? {})) {
  if (!['high', 'critical'].includes(vuln.severity)) continue;
  const entry = allow.find((a) => a.package === name);
  if (!entry) problems.push(`${name} (${vuln.severity}) sin excepción documentada`);
  else if (entry.reviewBy < today) problems.push(`${name}: la excepción venció el ${entry.reviewBy}`);
}
if (problems.length > 0) {
  console.error(problems.join('\n'));
  console.error('\nActualiza el paquete o documenta la excepción en docs/seguridad/dependencias.md.');
  process.exit(1);
}
console.log('npm audit (producción): sin vulnerabilidades altas sin revisar.');
