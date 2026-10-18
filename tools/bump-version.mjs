#!/usr/bin/env node
// Versión única del monorepo (ADR-0046): backend/package.json y los pubspec de mobile y admin.
//   node tools/bump-version.mjs 0.9.0     → backend 0.9.0, apps 0.9.0+<build anterior + 1>
//   node tools/bump-version.mjs --check   → falla si las tres no coinciden (lo usa el release)
// El número de build (+N) sube siempre: Google Play exige un versionCode creciente.
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const pkgPath = `${root}backend/package.json`;
const pubspecs = [`${root}apps/mobile/pubspec.yaml`, `${root}apps/admin/pubspec.yaml`];
const SEMVER = /^\d+\.\d+\.\d+$/;

const read = (p) => readFileSync(p, 'utf8');
const pubspecVersion = (text) => {
  const m = /^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$/m.exec(text);
  if (!m) throw new Error('pubspec sin "version: X.Y.Z+N"');
  return { name: m[1], build: Number(m[2]) };
};

const arg = process.argv[2];
if (arg === '--check') {
  const backend = JSON.parse(read(pkgPath)).version;
  const apps = pubspecs.map((p) => pubspecVersion(read(p)).name);
  const tag = process.argv[3]?.replace(/^v/, '');
  const all = [backend, ...apps, ...(tag ? [tag] : [])];
  if (new Set(all).size !== 1) {
    console.error(`Versiones distintas: backend ${backend}, apps ${apps.join(', ')}${tag ? `, tag ${tag}` : ''}`);
    process.exit(1);
  }
  console.log(`Versión ${backend} en backend, mobile y admin${tag ? ' y en el tag' : ''}.`);
} else if (arg && SEMVER.test(arg)) {
  const pkg = JSON.parse(read(pkgPath));
  pkg.version = arg;
  writeFileSync(pkgPath, `${JSON.stringify(pkg, null, 2)}\n`);
  for (const p of pubspecs) {
    const text = read(p);
    const { build } = pubspecVersion(text);
    writeFileSync(p, text.replace(/^version:.*$/m, `version: ${arg}+${build + 1}`));
  }
  console.log(`Versión ${arg}. Actualiza CHANGELOG.md, haz commit y crea el tag v${arg} en main.`);
} else {
  console.error('Uso: node tools/bump-version.mjs <X.Y.Z> | --check [vX.Y.Z]');
  process.exit(1);
}
