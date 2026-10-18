import { createParamDecorator, type ExecutionContext } from '@nestjs/common';
import type { Request } from 'express';
import type { AuthenticatedRequest } from '../auth/decorators/auth.decorators';
import { clientIp } from '../common/rate-limit/client-ip';

/** Quién actúa desde el panel y desde dónde (ADR-0041). */
export interface AdminContext {
  adminId: string;
  ip: string;
  /** X-Forwarded-For recibido (informativo: detrás del proxy de Vercel, ADR-0040). */
  forwardedFor: string | null;
  userAgent: string | null;
}

const clip = (value: string | string[] | undefined, max: number): string | null => {
  const text = Array.isArray(value) ? value.join(', ') : value;
  return text ? text.slice(0, max) : null;
};

export function adminContextOf(req: Request & AuthenticatedRequest): AdminContext {
  if (req.user?.role !== 'admin') throw new Error('AdminCtx fuera de una ruta del panel');
  return {
    adminId: req.user.id,
    ip: clientIp(req).slice(0, 64),
    forwardedFor: clip(req.headers['x-forwarded-for'], 256),
    userAgent: clip(req.headers['user-agent'], 256),
  };
}

/** Contexto del admin del request, para pasarlo a los servicios que auditan. */
export const AdminCtx = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): AdminContext =>
    adminContextOf(ctx.switchToHttp().getRequest<Request & AuthenticatedRequest>()),
);
