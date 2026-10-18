import { RequestMethod } from '@nestjs/common';
import { METHOD_METADATA, PATH_METADATA } from '@nestjs/common/constants';
import { DiscoveryService, MetadataScanner, ModulesContainer, Reflector } from '@nestjs/core';
import { IS_PUBLIC_KEY, ROLES_KEY } from '../../src/auth/decorators/auth.decorators';
import { ADMIN_PERMISSION_KEY } from '../../src/common/admin/admin-permissions';
import type { TestApp } from './test-app';

export interface RegisteredRoute {
  method: 'get' | 'post' | 'put' | 'patch' | 'delete';
  path: string;
  roles: string[] | undefined;
  permission: string | undefined;
  isPublic: boolean;
}

const METHODS: Partial<Record<RequestMethod, RegisteredRoute['method']>> = {
  [RequestMethod.GET]: 'get',
  [RequestMethod.POST]: 'post',
  [RequestMethod.PUT]: 'put',
  [RequestMethod.PATCH]: 'patch',
  [RequestMethod.DELETE]: 'delete',
};

const join = (...parts: string[]): string =>
  `/${parts
    .flatMap((p) => p.split('/'))
    .filter(Boolean)
    .join('/')}`;

/**
 * Todas las rutas HTTP que Nest registró, leídas de los metadatos de los controladores
 * (así una ruta nueva entra sola a los barridos de /admin e IDOR).
 */
export function registeredRoutes(t: TestApp): RegisteredRoute[] {
  const discovery = new DiscoveryService(t.app.get(ModulesContainer));
  const scanner = new MetadataScanner();
  const reflector = new Reflector();
  const routes: RegisteredRoute[] = [];
  for (const wrapper of discovery.getControllers()) {
    const instance = wrapper.instance as object | undefined;
    const metatype = wrapper.metatype as (abstract new (...args: never[]) => unknown) | null;
    if (!instance || !metatype) continue;
    const prefixes = [
      reflector.get<string | string[] | undefined>(PATH_METADATA, metatype) ?? '',
    ].flat();
    const proto = Object.getPrototypeOf(instance) as Record<string, unknown>;
    for (const name of scanner.getAllMethodNames(proto)) {
      const handler = proto[name] as (...args: unknown[]) => unknown;
      const method = reflector.get<RequestMethod | undefined>(METHOD_METADATA, handler);
      const verb = method === undefined ? undefined : METHODS[method];
      if (!verb) continue;
      const paths = [
        reflector.get<string | string[] | undefined>(PATH_METADATA, handler) ?? '',
      ].flat();
      for (const prefix of prefixes) {
        for (const path of paths) {
          routes.push({
            method: verb,
            path: join(prefix, path),
            roles: reflector.getAllAndOverride<string[] | undefined>(ROLES_KEY, [
              handler,
              metatype,
            ]),
            permission: reflector.getAllAndOverride<string | undefined>(ADMIN_PERMISSION_KEY, [
              handler,
              metatype,
            ]),
            isPublic:
              reflector.getAllAndOverride<boolean | undefined>(IS_PUBLIC_KEY, [
                handler,
                metatype,
              ]) ?? false,
          });
        }
      }
    }
  }
  return routes;
}

export const routeKey = (r: Pick<RegisteredRoute, 'method' | 'path'>): string =>
  `${r.method.toUpperCase()} ${r.path}`;
