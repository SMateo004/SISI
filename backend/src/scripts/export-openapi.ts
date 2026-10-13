// Debe ir primero: define variables de entorno ficticias antes de cargar AppModule.
import './openapi-env';

import { mkdirSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { Test } from '@nestjs/testing';
import { AppModule } from '../app.module';
import { buildOpenApiDocument } from '../app.setup';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';

/**
 * Genera packages/api_contract/openapi.json sin conectarse a la base ni a Redis.
 * Uso: npm run openapi:export
 */
async function main(): Promise<void> {
  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(PrismaService)
    .useValue({ $disconnect: () => Promise.resolve() })
    .overrideProvider(REDIS_CLIENT)
    .useValue({ status: 'end' })
    .compile();
  const app = moduleRef.createNestApplication({ logger: false });
  await app.init();

  const out = resolve(__dirname, '../../../packages/api_contract/openapi.json');
  mkdirSync(dirname(out), { recursive: true });
  writeFileSync(out, `${JSON.stringify(buildOpenApiDocument(app), null, 2)}\n`);
  await app.close();
  console.log(`OpenAPI escrito en ${out}`);
}

void main();
