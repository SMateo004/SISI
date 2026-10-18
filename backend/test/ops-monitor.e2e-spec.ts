import { ConfigService } from '@nestjs/config';
import request from 'supertest';
import type { AppConfigService } from '../src/config/app-config';
import { OpsDrill } from '../src/observability/ops-drill';
import { OpsMetrics } from '../src/observability/ops-metrics';
import { OpsMonitor } from '../src/observability/ops-monitor';
import { bearer, createTestApp, loginAsAdmin, type TestApp } from './utils/test-app';

/**
 * Alertas operativas (ADR-0048) con Postgres y Redis reales: el simulacro de staging deja cada
 * condición sobre su umbral y el monitor la detecta. Los contadores usan una hora lejana para
 * no mezclarse con los fallos de OTP o push de otras suites.
 */
describe('OpsMonitor y simulacro (e2e)', () => {
  let t: TestApp;
  let monitor: OpsMonitor;
  let drill: OpsDrill;
  const FUTURE = Date.UTC(2100, 0, 1, 12, 0, 0);

  beforeAll(async () => {
    t = await createTestApp({ worker: true });
    monitor = t.app.get(OpsMonitor);
    drill = new OpsDrill(
      t.prisma,
      t.app.get(OpsMetrics),
      t.app.get<AppConfigService>(ConfigService),
    );
  });

  afterAll(async () => {
    await drill.run('clear');
    await t.close();
  });

  it('outbox atascado: el simulacro alerta y clear lo deshace', async () => {
    await drill.run('outbox');
    const kinds = (await monitor.check()).map((a) => a.kind);
    expect(kinds).toContain('outbox_stuck');
    await drill.run('clear');
    expect(await t.prisma.outboxEvent.count({ where: { type: 'ops.drill' } })).toBe(0);
  });

  it('fallos de OTP y de push sobre el umbral', async () => {
    const before = (await monitor.check(FUTURE)).map((a) => a.kind);
    expect(before).not.toContain('otp_failing');
    expect(before).not.toContain('push_failing');
    await drill.run('otp', FUTURE);
    await drill.run('push', FUTURE + 1);
    const after = (await monitor.check(FUTURE + 2)).map((a) => a.kind);
    expect(after).toEqual(expect.arrayContaining(['otp_failing', 'push_failing']));
  });

  it('una vuelta con candado: dos instancias no revisan a la vez', async () => {
    const [a, b] = await Promise.all([monitor.tick(), monitor.tick()]);
    expect([a, b].filter((r) => r === null)).toHaveLength(1);
  });

  it('simulacro de 5xx: solo admin y responde 500 (va a Sentry)', async () => {
    const admin = await loginAsAdmin(t);
    const res = await request(t.url)
      .post('/admin/ops/drill-500')
      .set(...bearer(admin.accessToken));
    expect(res.status).toBe(500);
    expect(JSON.stringify(res.body)).not.toContain('Simulacro');
  });
});
