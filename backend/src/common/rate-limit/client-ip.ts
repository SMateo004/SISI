/** IP del cliente. Con `trust proxy` activo (main.ts) Express ya resuelve X-Forwarded-For. */
export function clientIp(req: { ip?: string; socket?: { remoteAddress?: string } }): string {
  return req.ip ?? req.socket?.remoteAddress ?? 'desconocida';
}
