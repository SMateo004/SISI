// Headers de seguridad de las apps web en Vercel (ADR-0047). Los usan los generadores de
// vercel.json de app-web y admin.
//
// La CSP sale primero como Content-Security-Policy-Report-Only: Flutter web (CanvasKit desde
// gstatic), Google Maps, Firebase y Sentry cargan recursos de varios orígenes y hay que verla
// funcionar en staging antes de exigirla. Con CSP_ENFORCE=true pasa a Content-Security-Policy.

const origin = (url) => {
  try {
    return url ? new URL(url).origin : null;
  } catch {
    return null;
  }
};

/**
 * @param {{ apiUrl?: string, socketUrl?: string, camera: boolean, location: boolean, maps: boolean }} o
 */
export function securityHeaders(o) {
  const api = origin(o.apiUrl);
  const socket = origin(o.socketUrl);
  const wss = socket ? socket.replace(/^https:/, 'wss:') : null;
  const connect = [
    "'self'",
    api,
    socket,
    wss,
    'https://*.googleapis.com',
    'https://www.gstatic.com',
    'https://fonts.gstatic.com',
    'https://*.ingest.sentry.io',
    'https://*.ingest.us.sentry.io',
    // Archivos firmados de R2 (fotos, comprobantes, QR) se leen con XHR.
    'https://*.r2.cloudflarestorage.com',
  ].filter(Boolean);
  const scripts = ["'self'", "'wasm-unsafe-eval'", 'https://www.gstatic.com'];
  if (o.maps) scripts.push('https://maps.googleapis.com');
  const csp = [
    "default-src 'self'",
    `script-src ${scripts.join(' ')}`,
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
    "font-src 'self' data: https://fonts.gstatic.com",
    "img-src 'self' data: blob: https:",
    `connect-src ${connect.join(' ')}`,
    "worker-src 'self' blob:",
    "frame-ancestors 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "object-src 'none'",
  ].join('; ');
  const allow = (on) => (on ? '(self)' : '()');
  return [
    {
      source: '/(.*)',
      headers: [
        { key: 'Strict-Transport-Security', value: 'max-age=31536000; includeSubDomains' },
        { key: 'X-Frame-Options', value: 'DENY' },
        { key: 'X-Content-Type-Options', value: 'nosniff' },
        { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
        {
          key: 'Permissions-Policy',
          value: `camera=${allow(o.camera)}, geolocation=${allow(o.location)}, microphone=(), payment=(), usb=()`,
        },
        {
          key:
            process.env.CSP_ENFORCE === 'true'
              ? 'Content-Security-Policy'
              : 'Content-Security-Policy-Report-Only',
          value: csp,
        },
      ],
    },
  ];
}
