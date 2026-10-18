import type { ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Roles } from '../../auth/decorators/auth.decorators';
import type { AppConfigService } from '../../config/app-config';
import type { RateLimitStore } from '../rate-limit/rate-limit.store';
import { AdminGuard, adminLimitKind } from './admin.guard';
import {
  Admin,
  ADMIN_PERMISSIONS,
  AdminExport,
  hasPermission,
  PERMISSIONS_BY_ROLE,
} from './admin-permissions';

/* eslint-disable @typescript-eslint/no-empty-function -- handlers vacíos: solo importan sus metadatos */
class Controllers {
  @Admin('cobros')
  payments(): void {}

  @Admin('cobros')
  @AdminExport()
  exportCsv(): void {}

  @Roles('admin')
  missing(): void {}

  open(): void {}
}
/* eslint-enable @typescript-eslint/no-empty-function */

const LIMITS: Record<string, number> = {
  RATE_ADMIN_READ_PER_MIN: 300,
  RATE_ADMIN_WRITE_PER_MIN: 60,
  RATE_ADMIN_EXPORT_PER_HOUR: 10,
};

function setup(allowed = true) {
  const consumed: { key: string; limit: number; windowSec: number }[] = [];
  const store = {
    consume: (rules: { key: string; limit: number; windowSec: number }[]) => {
      consumed.push(...rules);
      return Promise.resolve({ allowed, retryAfterSec: allowed ? 0 : 30 });
    },
  } as unknown as RateLimitStore;
  const guard = new AdminGuard(new Reflector(), store, {
    get: (key: string) => LIMITS[key],
  } as unknown as AppConfigService);
  const context = (
    handler: keyof Controllers,
    method: string,
    user?: { id: string; role: 'user' | 'admin' },
  ) =>
    ({
      // eslint-disable-next-line @typescript-eslint/unbound-method -- solo se leen sus metadatos
      getHandler: () => Controllers.prototype[handler],
      getClass: () => Controllers,
      switchToHttp: () => ({ getRequest: () => ({ method, path: `/admin/${handler}`, user }) }),
    }) as unknown as ExecutionContext;
  return { guard, consumed, context };
}

const ADMIN = { id: 'a1', role: 'admin' as const };

describe('permisos del panel', () => {
  it('en el MVP el rol admin tiene todos los permisos y user ninguno', () => {
    for (const p of ADMIN_PERMISSIONS) {
      expect(hasPermission('admin', p)).toBe(true);
      expect(hasPermission('user', p)).toBe(false);
    }
    expect(PERMISSIONS_BY_ROLE.admin).toHaveLength(7);
  });

  it('tipo de límite: GET lee, el resto escribe, y la exportación tiene el suyo', () => {
    expect(adminLimitKind('GET', false)).toBe('read');
    expect(adminLimitKind('post', false)).toBe('write');
    expect(adminLimitKind('DELETE', false)).toBe('write');
    expect(adminLimitKind('GET', true)).toBe('export');
  });
});

describe('AdminGuard', () => {
  it('deja pasar las rutas que no son del panel sin consumir límites', async () => {
    const { guard, consumed, context } = setup();
    await expect(guard.canActivate(context('open', 'GET'))).resolves.toBe(true);
    expect(consumed).toEqual([]);
  });

  it('con permiso: consume el límite de escritura del admin', async () => {
    const { guard, consumed, context } = setup();
    await expect(guard.canActivate(context('payments', 'POST', ADMIN))).resolves.toBe(true);
    expect(consumed).toEqual([{ key: 'admin:write:user:a1', limit: 60, windowSec: 60 }]);
  });

  it('la exportación usa su límite por hora', async () => {
    const { guard, consumed, context } = setup();
    await guard.canActivate(context('exportCsv', 'GET', ADMIN));
    expect(consumed).toEqual([{ key: 'admin:export:user:a1', limit: 10, windowSec: 3600 }]);
  });

  it('una ruta @Roles("admin") sin permiso declarado se rechaza (falla cerrada)', async () => {
    const { guard, context } = setup();
    await expect(guard.canActivate(context('missing', 'GET', ADMIN))).rejects.toMatchObject({
      code: 'ADMIN_PERMISSION_DENIED',
    });
  });

  it('sin el permiso del área: 403', async () => {
    const { guard, context } = setup();
    await expect(
      guard.canActivate(context('payments', 'POST', { id: 'u1', role: 'user' })),
    ).rejects.toMatchObject({ code: 'ADMIN_PERMISSION_DENIED' });
  });

  it('límite agotado: 429 con Retry-After', async () => {
    const { guard, context } = setup(false);
    await expect(guard.canActivate(context('payments', 'GET', ADMIN))).rejects.toMatchObject({
      status: 429,
    });
  });
});
