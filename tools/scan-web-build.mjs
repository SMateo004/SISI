#!/usr/bin/env node
// Revisa un build web antes de publicarlo (ADR-0047): ningún secreto de servidor puede viajar
// al navegador. Las llaves de Maps y la configuración de Firebase web son públicas por diseño
// (se restringen por dominio) y no se buscan aquí.
//   node tools/scan-web-build.mjs apps/mobile/build/web
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';

const PATTERNS = [
  [/-----BEGIN [A-Z ]*PRIVATE KEY-----/, 'llave privada'],
  [/"private_key"\s*:/, 'cuenta de servicio de Google (FIREBASE_SERVICE_ACCOUNT)'],
  [/\bbk_[a-z]{2}\d_[A-Za-z0-9]{16,}/, 'llave de Bird (OTP_PROVIDER_KEY)'],
  [/\bAKIA[0-9A-Z]{16}\b/, 'llave de acceso de AWS'],
  [/\bsk_live_[A-Za-z0-9]{16,}/, 'llave secreta de pagos'],
  [/JWT_(REFRESH_)?SECRET/, 'nombre de un secreto JWT'],
  [/STORAGE_SECRET_KEY|DATABASE_URL|REDIS_URL/, 'variable de servidor'],
];

const dir = process.argv[2];
if (!dir) {
  console.error('Uso: node tools/scan-web-build.mjs <carpeta del build>');
  process.exit(1);
}

const files = [];
const walk = (d) => {
  for (const name of readdirSync(d)) {
    const p = join(d, name);
    if (statSync(p).isDirectory()) walk(p);
    else if (/\.(js|json|html|map|txt|css)$/.test(name)) files.push(p);
  }
};
walk(dir);

const found = [];
for (const file of files) {
  const text = readFileSync(file, 'utf8');
  for (const [pattern, what] of PATTERNS) {
    if (pattern.test(text)) found.push(`${file}: ${what}`);
  }
}
if (found.length > 0) {
  console.error(`Secretos en el build web:\n${found.join('\n')}`);
  process.exit(1);
}
console.log(`Build web sin secretos (${String(files.length)} archivos revisados).`);
