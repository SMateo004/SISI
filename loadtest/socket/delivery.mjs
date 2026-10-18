// Tiempo de entrega de request:new (ADR-0053): desde que la API responde la publicación hasta
// que el socket del trabajador recibe el evento. Corre con Node 24 en Docker, con el
// socket.io-client del backend (sin instalar nada):
//
//   docker run --rm -v "$PWD:/sisi" -w /sisi/loadtest/socket -e NODE_PATH=/sisi/backend/node_modules \
//     -e API_URL=https://<api-staging> -e USERS=/sisi/loadtest/usuarios.json -e CATEGORY_ID=<plomería> \
//     node:24-alpine node delivery.mjs
//
// Conecta SOCKETS trabajadores (con ubicación cerca del centro), publica PUBLISHES solicitudes
// (una cada INTERVAL_MS) y reporta p50, p95 y p99 de la entrega.
import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';

const require = createRequire(`${process.env.NODE_PATH ?? '.'}/`);
const { io } = require('socket.io-client');

const API = process.env.API_URL;
if (!API) throw new Error('Falta API_URL');
const users = JSON.parse(readFileSync(process.env.USERS ?? '../usuarios.json', 'utf8'));
const SOCKETS = Number(process.env.SOCKETS ?? 50);
const PUBLISHES = Number(process.env.PUBLISHES ?? 30);
const INTERVAL_MS = Number(process.env.INTERVAL_MS ?? 4000);
const CENTER = { latitude: -17.7834, longitude: -63.1821 };

const headers = (token) => ({
  Authorization: `Bearer ${token}`,
  'Content-Type': 'application/json',
});
const api = async (token, method, path, body) => {
  const res = await fetch(`${API}${path}`, {
    method,
    headers: headers(token),
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text();
  return { status: res.status, body: text ? JSON.parse(text) : null };
};

const published = new Map(); // requestId → instante de la respuesta de publish
const latencies = [];
const seen = new Set();

const workers = users.workers.slice(0, SOCKETS);
const sockets = [];
for (const w of workers) {
  await api(w.accessToken, 'PUT', '/worker/availability', {
    available: true,
    latitude: CENTER.latitude + (Math.random() - 0.5) * 0.02,
    longitude: CENTER.longitude + (Math.random() - 0.5) * 0.02,
  });
  const socket = io(API, { auth: { token: w.accessToken }, transports: ['websocket'] });
  socket.on('request:new', (payload) => {
    const at = Date.now();
    const id = payload.requestId ?? payload.id;
    const sentAt = published.get(id);
    const key = `${id}:${w.id}`;
    if (sentAt && !seen.has(key)) {
      seen.add(key);
      latencies.push(at - sentAt);
    }
  });
  sockets.push(socket);
}
await new Promise((r) => setTimeout(r, 3000));
console.log(`${String(sockets.filter((s) => s.connected).length)}/${String(SOCKETS)} sockets conectados`);

for (let i = 0; i < PUBLISHES; i++) {
  const e = users.employers[i % users.employers.length];
  const created = await api(e.accessToken, 'POST', '/requests', {
    categoryId: process.env.CATEGORY_ID,
    description: 'Medición de entrega: se tapó el desagüe del baño.',
    ...CENTER,
    address: 'Prueba de entrega',
    proposedPriceBs: '150.00',
  });
  if (created.status !== 201) {
    console.error('No se pudo crear', created.status, created.body);
    continue;
  }
  const id = created.body.request.id;
  const pub = await api(e.accessToken, 'POST', `/requests/${id}/publish`);
  published.set(id, Date.now());
  if (pub.status !== 200) console.error('No se pudo publicar', pub.status, pub.body);
  await new Promise((r) => setTimeout(r, INTERVAL_MS));
}
await new Promise((r) => setTimeout(r, 10_000));
for (const s of sockets) s.close();

latencies.sort((a, b) => a - b);
const p = (q) => latencies[Math.min(latencies.length - 1, Math.floor(q * latencies.length))] ?? null;
console.log(
  JSON.stringify(
    {
      publicadas: published.size,
      entregas: latencies.length,
      p50_ms: p(0.5),
      p95_ms: p(0.95),
      p99_ms: p(0.99),
      max_ms: latencies.at(-1) ?? null,
    },
    null,
    2,
  ),
);
