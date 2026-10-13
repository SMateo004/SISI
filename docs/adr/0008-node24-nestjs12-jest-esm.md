# ADR-0008: Node 24 LTS, NestJS 12 (ESM) y Jest con require(esm)

- Estado: aceptada
- Fecha: 2026-10-13
- Fase: 0

## Contexto
NestJS 12 se publica solo como ESM. El backend compila a CommonJS (tsc, `module: nodenext`) y carga esos paquetes con `require(esm)` de Node. Jest solo soporta `require(esm)` desde Node 24.9 y con `--experimental-vm-modules`. El dueño del proyecto eligió Node 24 + NestJS 12 en lugar de quedarse en NestJS 11 (rama legacy).

## Decisión
- Node 24 LTS en local (`.nvmrc`), CI (`node-version-file`) y Render (`NODE_VERSION=24`). `engines.node: >=24.9 <25`.
- TypeScript 6.0 (typescript-eslint y ts-jest aún no soportan TS 7). `isolatedModules: true`.
- Prisma 7 estable (7.10) con generador `prisma-client` (salida en `src/generated/prisma`, formato CJS) y driver adapter `@prisma/adapter-pg`. `prisma.config.ts` reemplaza la URL en el schema.
- `npm test` / `npm run test:e2e` corren Jest con `node --experimental-vm-modules`. `moduleNameMapper` quita la extensión `.js` de imports relativos (cliente Prisma generado).
- npm 11 bloquea scripts de instalación: `package.json#allowScripts` aprueba solo `@prisma/engines`, `prisma`, `esbuild` y `unrs-resolver`; se niegan `@scarf/scarf` (telemetría) y `@parcel/watcher` (compila con node-gyp; usa binarios precompilados).

## Consecuencias
Stack al día sin migración pendiente. Al actualizar Prisma/esbuild hay que re-aprobar sus scripts (`npm install-scripts approve <pkg>`). Cuando ts-jest soporte TS 7 o Jest soporte ESM sin flag, revisar este ADR.
