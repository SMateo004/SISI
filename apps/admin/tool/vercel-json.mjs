// Genera apps/admin/vercel.json con el proxy /api/* → API_URL (ADR-0040): el admin llama a la
// API por su propio origen para que la cookie httpOnly del refresh sea de primera parte.
//   API_URL=https://<api>.onrender.com node tool/vercel-json.mjs
import { writeFileSync } from 'node:fs';

const api = (process.env.API_URL ?? '').replace(/\/+$/, '');
if (!/^https:\/\/[^/]+$/.test(api)) {
  throw new Error(`API_URL debe ser un origen https sin ruta (recibido: "${api}")`);
}

const config = {
  $schema: 'https://openapi.vercel.sh/vercel.json',
  framework: null,
  outputDirectory: 'build/web',
  rewrites: [
    { source: '/api/:path*', destination: `${api}/:path*` },
    { source: '/(.*)', destination: '/index.html' },
  ],
  headers: [
    {
      source: '/(.*)',
      headers: [
        { key: 'X-Frame-Options', value: 'DENY' },
        { key: 'Referrer-Policy', value: 'no-referrer' },
        { key: 'X-Content-Type-Options', value: 'nosniff' },
      ],
    },
  ],
};

writeFileSync(new URL('../vercel.json', import.meta.url), `${JSON.stringify(config, null, 2)}\n`);
console.log(`vercel.json: /api/* → ${api}`);
