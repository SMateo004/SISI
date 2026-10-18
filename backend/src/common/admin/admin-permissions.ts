import { applyDecorators, SetMetadata } from '@nestjs/common';
import { ApiBearerAuth, ApiForbiddenResponse } from '@nestjs/swagger';
import { Roles } from '../../auth/decorators/auth.decorators';
import type { Role } from '../../auth/tokens/token.service';
import { ApiErrorBody } from '../errors/api-error';

/**
 * Permisos del panel por área (ADR-0040). En el MVP el rol `admin` los tiene todos; un rol de
 * moderador o de finanzas solo agrega una fila en PERMISSIONS_BY_ROLE (y su valor en el enum).
 */
export const ADMIN_PERMISSIONS = [
  'dashboard',
  'verificaciones',
  'moderacion',
  'cobros',
  'catalogo',
  'configuracion',
  'usuarios',
  'auditoria',
] as const;

export type AdminPermission = (typeof ADMIN_PERMISSIONS)[number];

export const PERMISSIONS_BY_ROLE: Readonly<Record<Role, readonly AdminPermission[]>> = {
  user: [],
  admin: ADMIN_PERMISSIONS,
};

export const hasPermission = (role: Role, permission: AdminPermission): boolean =>
  PERMISSIONS_BY_ROLE[role].includes(permission);

export const ADMIN_PERMISSION_KEY = 'sisi:admin-permission';
export const ADMIN_EXPORT_KEY = 'sisi:admin-export';

/**
 * Ruta del panel: exige rol admin, sesión del panel (aud=admin) y el permiso del área.
 * Todo controlador /admin lo usa (el test de barrido falla si falta).
 */
export const Admin = (permission: AdminPermission) =>
  applyDecorators(
    Roles('admin'),
    SetMetadata(ADMIN_PERMISSION_KEY, permission),
    ApiBearerAuth(),
    ApiForbiddenResponse({
      type: ApiErrorBody,
      description: 'FORBIDDEN, ADMIN_SESSION_REQUIRED o ADMIN_PERMISSION_DENIED',
    }),
  );

/** Exportación pesada (CSV): límite propio, más bajo que el de lectura. */
export const AdminExport = () => SetMetadata(ADMIN_EXPORT_KEY, true);
