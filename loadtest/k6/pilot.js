// Prueba de carga del piloto (ADR-0053). Solo contra staging (o local), NUNCA contra producción.
//
//   docker run --rm -v "$PWD/loadtest:/lt" -e API_URL=https://<api-staging> \
//     -e USERS=/lt/usuarios.json grafana/k6:2.3.0 run /lt/k6/pilot.js
//
// Escenario propuesto (variables para escalarlo):
//   - WORKERS trabajadores disponibles mandan su ubicación cada 30 s y ofertan a lo que les llega;
//   - EMPLOYERS empleadores publican solicitudes (REQUESTS_PER_MIN; con 6 por minuto hay ~30
//     abiertas a la vez), eligen la primera oferta,
//     chatean y confirman; los trabajadores elegidos avanzan el trabajo;
//   - DURATION de carga sostenida y luego un pico de 2× por 5 minutos.
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Counter, Trend } from 'k6/metrics';
import exec from 'k6/execution';

const API = __ENV.API_URL;
if (!API) throw new Error('Falta API_URL');
if (/\bapi\.[^.]+\.(bo|com)$/.test(API) && __ENV.I_KNOW_THIS_IS_NOT_PROD !== 'si') {
  throw new Error('¿Producción? La prueba de carga corre solo contra staging (ADR-0053).');
}
const users = JSON.parse(open(__ENV.USERS || '/lt/usuarios.json'));
const WORKERS = Number(__ENV.WORKERS || users.workers.length);
const EMPLOYERS = Number(__ENV.EMPLOYERS || users.employers.length);
const DURATION = __ENV.DURATION || '30m';
// ~30 solicitudes abiertas a la vez: cada una vive unos 5 minutos (búsqueda, ofertas, elección).
const REQUESTS_PER_MIN = Number(__ENV.REQUESTS_PER_MIN || 6);
const RAMP = __ENV.RAMP || '2m';
const SPIKE = __ENV.SPIKE || '5m';
const CENTER = { lat: -17.7834, lng: -63.1821 };

const firstOffer = new Trend('sisi_first_offer_ms', true);
const assigned = new Counter('sisi_jobs_assigned');
const completed = new Counter('sisi_jobs_completed');

export const options = {
  scenarios: {
    workers: {
      executor: 'constant-vus',
      vus: WORKERS,
      duration: DURATION,
      exec: 'worker',
    },
    employers: {
      executor: 'ramping-arrival-rate',
      exec: 'employer',
      startRate: 0,
      timeUnit: '1m',
      preAllocatedVUs: EMPLOYERS,
      maxVUs: EMPLOYERS,
      stages: [
        { duration: RAMP, target: REQUESTS_PER_MIN },
        { duration: DURATION, target: REQUESTS_PER_MIN },
        // Pico: el doble por 5 minutos.
        { duration: '30s', target: REQUESTS_PER_MIN * 2 },
        { duration: SPIKE, target: REQUESTS_PER_MIN * 2 },
        { duration: '1m', target: 0 },
      ],
    },
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],
    'http_req_duration{name:location}': ['p(95)<300'],
    'http_req_duration{name:publish}': ['p(95)<800'],
    'http_req_duration{name:offer}': ['p(95)<500'],
    'http_req_duration{name:chat}': ['p(95)<400'],
  },
};

// El token de acceso vence a los 15 min: ante un 401 se renueva con el refresh (rotativo) y
// se reintenta una vez.
const sessions = {};
function session(kind, index) {
  const key = `${kind}${index}`;
  if (!sessions[key]) {
    const u = users[kind][index];
    sessions[key] = { access: u.accessToken, refresh: u.refreshToken };
  }
  return sessions[key];
}

function refresh(s) {
  const res = http.post(`${API}/auth/refresh`, JSON.stringify({ refreshToken: s.refresh }), {
    headers: { 'Content-Type': 'application/json' },
    tags: { name: 'refresh' },
  });
  if (res.status !== 200) return false;
  const body = res.json();
  s.access = body.accessToken;
  s.refresh = body.refreshToken;
  return true;
}

function call(kind, index, method, path, body, name) {
  const s = session(kind, index);
  const send = () =>
    http.request(method, `${API}${path}`, body ? JSON.stringify(body) : null, {
      headers: {
        Authorization: `Bearer ${s.access}`,
        'Content-Type': 'application/json',
        'X-App-Platform': 'android',
        'X-App-Version': '0.9.0',
      },
      tags: { name },
      // El 401 de un token vencido no cuenta como error: se renueva y se reintenta.
      responseCallback: http.expectedStatuses({ min: 200, max: 399 }, 401),
    });
  let res = send();
  if (res.status === 401 && refresh(s)) res = send();
  if (__ENV.DEBUG && res.status >= 400) {
    console.log(`${name} ${String(res.status)} ${String(res.body).slice(0, 100)}`);
  }
  return res;
}

const jitter = (km) => (Math.random() - 0.5) * (km / 111) * 2;

/** Trabajador: ubicación cada 30 s, ofertas a lo que llega y avance de su trabajo. */
export function worker() {
  const i = (exec.vu.idInTest - 1) % WORKERS;
  const me = `worker:${i}`;
  if (!sessions[`${me}:on`]) {
    const res = call('workers', i, 'PUT', '/worker/availability', {
      available: true,
      latitude: CENTER.lat + jitter(5),
      longitude: CENTER.lng + jitter(5),
    }, 'availability');
    check(res, { 'disponible': (r) => r.status === 200 });
    sessions[`${me}:on`] = true;
  }
  const loc = call('workers', i, 'POST', '/worker/location', {
    latitude: CENTER.lat + jitter(5),
    longitude: CENTER.lng + jitter(5),
  }, 'location');
  check(loc, { 'ubicación': (r) => r.status === 200 || r.status === 201 });

  const incoming = call('workers', i, 'GET', '/worker/requests', null, 'incoming');
  if (__ENV.DEBUG) console.log(`entrantes w${String(i)}: ${String(incoming.status)} ${incoming.body.slice(0, 160)}`);
  if (incoming.status === 200) {
    for (const r of incoming.json()) {
      if (r.myOffer || r.outcome !== 'abierta') continue;
      const counter = Math.random() < 0.2;
      const offered = call('workers', i, 'POST', `/requests/${r.requestId}/offers`,
        counter ? { type: 'counter', amountBs: '180.00' } : { type: 'accept' }, 'offer');
      if (__ENV.DEBUG) console.log(`oferta ${r.requestId}: ${String(offered.status)} ${offered.body.slice(0, 120)}`);
    }
  }

  const jobs = call('workers', i, 'GET', '/jobs?role=worker&limit=5', null, 'jobs');
  if (jobs.status === 200) {
    for (const job of jobs.json().items) {
      const next = { asignado: 'on-the-way', en_camino: 'start', en_curso: 'finish' }[job.status];
      if (!next || job.timeline?.workerFinishedAt) continue;
      call('workers', i, 'POST', `/jobs/${job.id}/messages`, { body: 'Voy en camino, llego pronto.' }, 'chat');
      call('workers', i, 'POST', `/jobs/${job.id}/${next}`, null, 'job_step');
    }
  }
  sleep(30);
}

/** Empleador: publica, espera ofertas, elige la primera, chatea y confirma al terminar. */
export function employer() {
  const i = exec.scenario.iterationInTest % EMPLOYERS;
  const created = call('employers', i, 'POST', '/requests', {
    categoryId: __ENV.CATEGORY_ID,
    description: 'Prueba de carga: gotea la cañería debajo del lavaplatos.',
    latitude: CENTER.lat + jitter(3),
    longitude: CENTER.lng + jitter(3),
    address: 'Prueba de carga',
    proposedPriceBs: '150.00',
  }, 'create');
  if (!check(created, { 'creada': (r) => r.status === 201 })) return;
  const id = created.json().request.id;
  const published = call('employers', i, 'POST', `/requests/${id}/publish`, null, 'publish');
  if (!check(published, { 'publicada': (r) => r.status === 200 })) return;
  const start = Date.now();

  let offer = null;
  for (let t = 0; t < 36 && !offer; t++) {
    sleep(5);
    const offers = call('employers', i, 'GET', `/requests/${id}/offers`, null, 'offers');
    if (__ENV.DEBUG) console.log(`ofertas ${id}: ${String(offers.status)} ${offers.body.slice(0, 80)}`);
    if (offers.status === 200 && offers.json().length > 0) offer = offers.json()[0];
  }
  if (!offer) return;
  firstOffer.add(Date.now() - start);
  const accept = call('employers', i, 'POST', `/requests/${id}/offers/${offer.id}/accept`, null, 'accept');
  if (accept.status !== 200) return;
  assigned.add(1);
  const jobId = accept.json().jobId;
  for (let t = 0; t < 40; t++) {
    sleep(15);
    if (t % 2 === 0) {
      call('employers', i, 'POST', `/jobs/${jobId}/messages`, { body: '¿Cuánto falta para que llegues?' }, 'chat');
    }
    const job = call('employers', i, 'GET', `/jobs/${jobId}`, null, 'job');
    if (job.status === 200 && job.json().timeline?.workerFinishedAt) {
      const ok = call('employers', i, 'POST', `/jobs/${jobId}/confirm`, null, 'confirm');
      if (ok.status === 200) completed.add(1);
      return;
    }
  }
}
