import type { INestApplication } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import request from 'supertest';
import type { App } from 'supertest/types';
import { PrismaService } from '../prisma/prisma.service';
import { REDIS_CLIENT } from '../redis/redis.constants';
import type { HealthResponseDto } from './dto/health-response.dto';
import { HealthController } from './health.controller';
import { HealthService } from './health.service';

/** /health con dependencias simuladas: no necesita Docker. */
describe('GET /health', () => {
  let app: INestApplication<App>;
  const prisma = { $queryRaw: jest.fn() };
  const redis = { ping: jest.fn() };

  beforeAll(async () => {
    const moduleRef = await Test.createTestingModule({
      controllers: [HealthController],
      providers: [
        HealthService,
        { provide: PrismaService, useValue: prisma },
        { provide: REDIS_CLIENT, useValue: redis },
      ],
    }).compile();
    moduleRef.useLogger(false);
    app = moduleRef.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('responde 200 cuando base de datos, PostGIS y Redis están arriba', async () => {
    prisma.$queryRaw.mockResolvedValueOnce([{ '?column?': 1 }]);
    prisma.$queryRaw.mockResolvedValueOnce([{ version: '3.5.2' }]);
    redis.ping.mockResolvedValue('PONG');

    const res = await request(app.getHttpServer()).get('/health').expect(200);
    const body = res.body as HealthResponseDto;

    expect(body.status).toBe('ok');
    expect(body.checks.database.status).toBe('up');
    expect(body.checks.postgis).toEqual({ status: 'up', version: '3.5.2' });
    expect(body.checks.redis.status).toBe('up');
  });

  it('responde 503 si Redis no responde', async () => {
    prisma.$queryRaw.mockResolvedValueOnce([{ '?column?': 1 }]);
    prisma.$queryRaw.mockResolvedValueOnce([{ version: '3.5.2' }]);
    redis.ping.mockRejectedValue(new Error('ECONNREFUSED'));

    const res = await request(app.getHttpServer()).get('/health').expect(503);
    const body = res.body as HealthResponseDto;

    expect(body.status).toBe('error');
    expect(body.checks.redis.status).toBe('down');
    expect(body.checks.database.status).toBe('up');
  });

  it('responde 503 si la base de datos falla', async () => {
    prisma.$queryRaw.mockRejectedValue(new Error('connection refused'));
    redis.ping.mockResolvedValue('PONG');

    const res = await request(app.getHttpServer()).get('/health').expect(503);
    const body = res.body as HealthResponseDto;

    expect(body.checks.database.status).toBe('down');
    expect(body.checks.postgis.status).toBe('down');
  });
});
