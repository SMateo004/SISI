import type { CookieOptions } from 'express';

/** Cookie httpOnly con el refresh del panel admin (ADR-0040). */
export const ADMIN_REFRESH_COOKIE = 'sisi_admin_rt';

/** Header obligatorio en refresh y logout del panel: un formulario de otro sitio no puede enviarlo. */
export const ADMIN_CSRF_HEADER = 'x-sisi-admin';

/**
 * Lee una cookie del header `Cookie` (sin cookie-parser). Ignora pares mal formados y
 * devuelve el primer valor con ese nombre.
 */
export function readCookie(header: string | undefined, name: string): string | undefined {
  if (!header) return undefined;
  for (const part of header.split(';')) {
    const eq = part.indexOf('=');
    if (eq < 0) continue;
    if (part.slice(0, eq).trim() !== name) continue;
    const raw = part.slice(eq + 1).trim();
    try {
      return decodeURIComponent(raw);
    } catch {
      return undefined;
    }
  }
  return undefined;
}

/**
 * Atributos de la cookie. `SameSite=Strict` porque el panel llama a la API por su propio
 * origen (proxy /api de Vercel); `Secure` también en localhost (Chrome lo permite).
 */
export function adminCookieOptions(path: string, maxAgeSec: number): CookieOptions {
  return {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    path,
    maxAge: maxAgeSec * 1000,
  };
}
