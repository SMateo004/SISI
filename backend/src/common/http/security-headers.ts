import type { NextFunction, Request, Response } from 'express';

/**
 * Headers de seguridad de la API (ADR-0047), sin dependencias. La API solo responde JSON
 * (y el CSV del panel), así que la CSP no permite nada. Swagger (/docs, fuera de producción)
 * necesita su propia página: ahí no se pone CSP.
 */
export function securityHeaders(options: { https: boolean }) {
  return (req: Request, res: Response, next: NextFunction): void => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('Referrer-Policy', 'no-referrer');
    res.setHeader('Cross-Origin-Resource-Policy', 'same-site');
    if (!req.path.startsWith('/docs')) {
      res.setHeader('Content-Security-Policy', "default-src 'none'; frame-ancestors 'none'");
    }
    if (options.https) {
      res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    }
    // Respuestas con datos personales: ningún proxy ni navegador las guarda. Un handler que
    // quiera otra cosa (p. ej. el CSV) la reemplaza.
    res.setHeader('Cache-Control', 'no-store');
    next();
  };
}

/**
 * El navegador no aplica CORS a un websocket: el origen se verifica a mano. Las apps nativas
 * no envían Origin y pasan; un navegador desde otro dominio, no.
 */
export function isAllowedSocketOrigin(origin: string | undefined, allowed: readonly string[]) {
  return origin === undefined || allowed.includes(origin);
}
