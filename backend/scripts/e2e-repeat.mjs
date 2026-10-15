// Corre la suite e2e N veces seguidas (por defecto 20) y guarda la salida completa de
// cada corrida en .e2e-runs/ (ignorado por git). Sale con 1 si alguna falló (ADR-0028).
//   npm run test:e2e:repeat -- 20
import { spawnSync } from 'node:child_process';
import { mkdirSync, rmSync, writeFileSync, appendFileSync } from 'node:fs';
import { join } from 'node:path';

const runs = Number(process.argv[2] ?? 20);
if (!Number.isInteger(runs) || runs < 1) {
  console.error('Uso: npm run test:e2e:repeat -- <corridas>');
  process.exit(2);
}

const dir = '.e2e-runs';
rmSync(dir, { recursive: true, force: true });
mkdirSync(dir);
const summary = join(dir, 'summary.txt');
writeFileSync(summary, '');

let failed = 0;
for (let i = 1; i <= runs; i++) {
  const start = Date.now();
  const res = spawnSync('npm', ['run', 'test:e2e'], { encoding: 'utf8', shell: true });
  const output = `${res.stdout}\n${res.stderr}`;
  const file = join(dir, `run-${String(i).padStart(2, '0')}.log`);
  writeFileSync(file, output);
  const tests = /^Tests:.*$/m.exec(output)?.[0] ?? 'sin resumen';
  const failures = [...output.matchAll(/^\s+● (.+)$/gm)].map((m) => m[1]);
  const ok = res.status === 0;
  if (!ok) failed++;
  const line = `corrida ${i}/${runs} ${ok ? 'OK ' : 'FALLÓ'} ${Math.round((Date.now() - start) / 1000)} s · ${tests}${
    failures.length > 0 ? `\n  ${[...new Set(failures)].join('\n  ')}` : ''
  }`;
  appendFileSync(summary, `${line}\n`);
  console.log(line);
}

const result = `\n${runs - failed} de ${runs} corridas en verde.`;
appendFileSync(summary, `${result}\n`);
console.log(result);
process.exit(failed === 0 ? 0 : 1);
