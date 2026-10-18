// Genera apps/mobile/vercel.json (app web) con los headers de seguridad (ADR-0047) y la página
// pública de eliminación de cuenta (ADR-0049). Lo corre deploy-web.
//   API_URL=https://<api> SOCKET_URL=https://<api> node tool/vercel-json.mjs
import { writeFileSync } from 'node:fs';
import { securityHeaders } from '../../../tools/web-security-headers.mjs';

const config = {
  $schema: 'https://openapi.vercel.sh/vercel.json',
  framework: null,
  outputDirectory: 'build/web',
  rewrites: [
    { source: '/eliminar-cuenta', destination: '/eliminar-cuenta/index.html' },
    { source: '/(.*)', destination: '/index.html' },
  ],
  headers: securityHeaders({
    apiUrl: process.env.API_URL,
    socketUrl: process.env.SOCKET_URL,
    camera: true,
    location: true,
    maps: true,
  }),
};

writeFileSync(new URL('../vercel.json', import.meta.url), `${JSON.stringify(config, null, 2)}\n`);
console.log('vercel.json de la app web con headers de seguridad.');
