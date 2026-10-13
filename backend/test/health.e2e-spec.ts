import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types';
import { AppModule } from '../src/app.module';
import { setupApp } from '../src/app.setup';
import type { HealthResponseDto } from '../src/health/dto/health-response.dto';

/** /health contra Postgres+PostGIS y Redis reales (docker compose o services de CI). */
describe('GET /health (e2e)', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({ imports: [AppModule] }).compile();
    app = moduleRef.createNestApplication();
    setupApp(app);
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  it('responde 200 con base de datos, PostGIS y Redis arriba', async () => {
    const res = await request(app.getHttpServer()).get('/health').expect(200);
    const body = res.body as HealthResponseDto;

    expect(body.status).toBe('ok');
    expect(body.checks.database.status).toBe('up');
    expect(body.checks.postgis.status).toBe('up');
    expect(body.checks.postgis.version).toMatch(/^\d+\.\d+/);
    expect(body.checks.redis.status).toBe('up');
  });
});
