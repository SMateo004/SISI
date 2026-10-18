import { AuditModule } from '../audit/audit.module';
import { writeFileSync } from 'node:fs';
import { LoadtestModule, LoadtestSeeder } from './loadtest-seed';
import { RetentionModule } from '../retention/retention.module';
import { RetentionService } from '../retention/retention.service';
import { StorageModule } from '../storage/storage.module';
import { ObservabilityModule } from '../observability/observability.module';
import { type DrillKind, OpsDrill } from '../observability/ops-drill';
import { SettingsModule } from '../settings/settings.module';
import { parseArgs } from 'node:util';
import { generateTotpSecret, otpauthUri } from '../auth/admin-totp';
import { Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { maskPhone, normalizePhone } from '../common/phone/phone';
import type { AppConfigService } from '../config/app-config';
import { BillingCatchUpService } from '../billing/billing-catchup.service';
import { BillingCoreModule } from '../billing/billing-core.module';
import { BillingDebtStatusProvider } from '../billing/billing-debt-status.provider';
import { AppConfigModule } from '../config/config.module';
import { JobStatusModule } from '../jobs/job-status.module';
import { JobStatusService } from '../jobs/job-status.service';
import { WorkerAvailabilityModule } from '../locations/locations.module';
import { ModerationService } from '../moderation/moderation.service';
import { OutboxModule } from '../outbox/outbox.module';
import { PrismaModule } from '../prisma/prisma.module';
import { PrismaService } from '../prisma/prisma.service';
import { RedisModule } from '../redis/redis.module';
import { ReportsService } from '../reports/reports.service';
import {
  DEBT_STATUS_PROVIDER,
  LoggingWorkerNotifier,
  WORKER_NOTIFIER,
} from '../workers/worker.ports';
import { type WorkerEventInput, WorkerStatusService } from '../workers/worker-status.service';

/**
 * Herramientas de desarrollo y staging. NUNCA es un endpoint y se niega a correr con
 * APP_ENV=production. La revisión real de trabajadores llega con el panel admin (Fase 6).
 *
 *   npm run dev:tools -- review-worker --phone 70012345 --approve
 *   npm run dev:tools -- review-worker --phone 70012345 --reject "La foto del carnet está borrosa"
 *   npm run dev:tools -- worker-event --phone 70012345 --event BLOCK_FOR_DEBT
 *   npm run dev:tools -- worker-event --phone 70012345 --event SUSPEND --reason "3 reportes"
 *   npm run dev:tools -- create-category --name "Plomería (prueba)" --min 80 --max 250
 *   npm run dev:tools -- admin-totp   (clave nueva de la app autenticadora del panel, ADR-0055)
 *   npm run dev:tools -- quick-worker --phone 70012345 --categories plomeria,limpieza --transport moto --radius 10
 *   npm run dev:tools -- resolve-dispute --job <uuid> --decision confirm --reason "Se verificó con ambas partes"
 *   npm run dev:tools -- billing-run --at 2026-10-19T04:05:00Z   (cron de cobros con reloj simulado)
 *   npm run dev:tools -- resolve-report --report <uuid> --approve --reason "Se verificó"   (o --reject "motivo")
 *   npm run dev:tools -- ops-drill outbox|otp|push|clear   (simulacro de alertas en staging, ADR-0048)
 *   npm run dev:tools -- loadtest-seed --workers 200 --employers 40 --out loadtest/usuarios.json   (solo local/staging)
 *   npm run dev:tools -- db-stats --times 12   (conexiones a Postgres cada 5 s, para la prueba de carga)
 *   npm run dev:tools -- retention --dry-run   (cuenta lo que borraría la retención; sin --dry-run, borra; ADR-0050)
 */
@Module({
  // WorkerStatusService apaga la disponibilidad al bloquear o suspender (Redis, ADR-0024).
  imports: [
    AppConfigModule,
    PrismaModule,
    RedisModule,
    WorkerAvailabilityModule,
    OutboxModule,
    JobStatusModule,
    BillingCoreModule,
    // ReportsService audita cuando lo llama el panel; aquí el actor es null (sin filas).
    AuditModule,
    SettingsModule,
    ObservabilityModule,
    StorageModule,
    RetentionModule,
    LoadtestModule,
  ],
  providers: [
    OpsDrill,
    WorkerStatusService,
    ModerationService,
    ReportsService,
    { provide: DEBT_STATUS_PROVIDER, useClass: BillingDebtStatusProvider },
    { provide: WORKER_NOTIFIER, useClass: LoggingWorkerNotifier },
  ],
})
class DevToolsModule {}

const logger = new Logger('dev-tools');

async function main(): Promise<void> {
  const [command, ...rest] = process.argv.slice(2);
  const { values } = parseArgs({
    args: rest,
    allowPositionals: true,
    options: {
      phone: { type: 'string' },
      approve: { type: 'boolean' },
      reject: { type: 'string' },
      event: { type: 'string' },
      reason: { type: 'string' },
      name: { type: 'string' },
      categories: { type: 'string' },
      transport: { type: 'string' },
      radius: { type: 'string' },
      min: { type: 'string' },
      max: { type: 'string' },
      job: { type: 'string' },
      decision: { type: 'string' },
      report: { type: 'string' },
      at: { type: 'string' },
      'dry-run': { type: 'boolean' },
      workers: { type: 'string' },
      employers: { type: 'string' },
      out: { type: 'string' },
      times: { type: 'string' },
    },
  });

  const app = await NestFactory.createApplicationContext(DevToolsModule, {
    logger: ['error', 'warn', 'log'],
  });
  try {
    const config = app.get<AppConfigService>(ConfigService);
    if (config.get('APP_ENV', { infer: true }) === 'production') {
      throw new Error('dev-tools no se puede usar con APP_ENV=production.');
    }
    const prisma = app.get(PrismaService);
    const status = app.get(WorkerStatusService);

    const userIdFor = async (raw: string | undefined): Promise<string> => {
      if (!raw) throw new Error('Falta --phone');
      const phone = normalizePhone(raw, config.get('PHONE_ALLOWED_COUNTRY_CODES', { infer: true }));
      const user = await prisma.user.findUnique({ where: { phone } });
      if (!user) throw new Error(`No existe una cuenta con el teléfono ${phone}`);
      return user.id;
    };

    switch (command) {
      case 'review-worker': {
        const userId = await userIdFor(values.phone);
        const event: WorkerEventInput = values.approve
          ? { type: 'APPROVE' }
          : values.reject
            ? { type: 'REJECT', reason: values.reject }
            : (() => {
                throw new Error('Usa --approve o --reject "motivo"');
              })();
        const { profile } = await status.apply(userId, event, null);
        logger.log(`Perfil de ${maskPhone(values.phone ?? '')} ahora en estado ${profile.status}`);
        break;
      }
      case 'worker-event': {
        const userId = await userIdFor(values.phone);
        const reason = values.reason ?? 'Prueba manual (dev-tools)';
        const events: Record<string, WorkerEventInput> = {
          BLOCK_FOR_DEBT: { type: 'BLOCK_FOR_DEBT' },
          DEBT_PAID: { type: 'DEBT_PAID' },
          SUSPEND: { type: 'SUSPEND', reason },
          CONFIRM_SUSPENSION: { type: 'CONFIRM_SUSPENSION', resolution: reason },
          LIFT_SUSPENSION: { type: 'LIFT_SUSPENSION', resolution: reason },
        };
        const event = events[values.event ?? ''];
        if (!event) throw new Error(`--event debe ser uno de: ${Object.keys(events).join(', ')}`);
        const change = await status.apply(userId, event, null);
        logger.log(
          `Estado: ${change.profile.status}${change.modeForcedToEmployer ? ' (la cuenta pasó a modo employer)' : ''}`,
        );
        break;
      }
      case 'create-category': {
        if (!values.name || !values.min || !values.max) {
          throw new Error('Usa --name, --min y --max (en Bs)');
        }
        const slug = `prueba-${Date.now().toString(36)}`;
        const city = await prisma.city.findUniqueOrThrow({
          where: { slug: config.get('DEFAULT_CITY_SLUG', { infer: true }) },
        });
        const category = await prisma.category.create({
          data: {
            slug,
            name: values.name,
            priceMinBs: values.min,
            priceMaxBs: values.max,
            cities: { create: { cityId: city.id } },
          },
        });
        logger.log(`Categoría de prueba creada: ${category.name} (${category.id})`);
        break;
      }
      case 'admin-totp': {
        // Clave nueva para el ingreso al panel (ADR-0055). Se muestra solo en esta terminal
        // (no en el log): va a ADMIN_TOTP_SECRET del ambiente y a la app autenticadora.
        const secret = generateTotpSecret();
        const username = config.get('ADMIN_USERNAME', { infer: true });
        process.stdout.write(
          [
            '',
            'Clave nueva del panel (no la compartas ni la subas al repo):',
            '',
            `  ADMIN_TOTP_SECRET=${secret}`,
            '',
            'En la app autenticadora: "Agregar código" → "Ingresar clave de configuración",',
            `cuenta "SISI ${username}", clave de arriba, "Basada en el tiempo". O este enlace como QR:`,
            '',
            `  ${otpauthUri(secret, username)}`,
            '',
            'Después: ponla en el ambiente de la API (backend/.env en local, Render en staging o',
            'producción) y reinicia la API. La clave anterior deja de servir.',
            '',
          ].join('\n'),
        );
        break;
      }
      case 'quick-worker': {
        // Trabajador aprobado para pruebas manuales (sin subir carnet ni selfie). El estado
        // pasa igual por WorkerStatusService (SUBMIT + APPROVE, ADR-0013).
        const userId = await userIdFor(values.phone);
        const slugs = (values.categories ?? 'plomeria').split(',').map((c) => c.trim());
        const categories = await prisma.category.findMany({ where: { slug: { in: slugs } } });
        if (categories.length !== slugs.length) {
          throw new Error(`Categorías inexistentes en: ${slugs.join(', ')}`);
        }
        const transport = (values.transport ?? 'moto') as
          'a_pie' | 'bicicleta' | 'moto' | 'auto' | 'transporte_publico';
        await status.apply(userId, { type: 'SUBMIT' }, null, async (tx) => {
          await tx.workerCategory.deleteMany({ where: { workerId: userId } });
          await tx.workerProfile.update({
            where: { userId },
            data: {
              transport,
              maxRadiusKm: Number(values.radius ?? 10),
              birthDate: new Date('1995-01-01'),
              categories: { create: categories.map((c) => ({ categoryId: c.id })) },
            },
          });
        });
        const { profile } = await status.apply(userId, { type: 'APPROVE' }, null);
        logger.log(
          `Trabajador ${values.phone ?? ''} ${profile.status} en ${slugs.join(', ')} (${transport}, ${profile.maxRadiusKm ?? 0} km)`,
        );
        break;
      }
      case 'resolve-dispute': {
        // Igual que POST /admin/jobs/:id/resolve (ADR-0029), con actor admin sin cuenta.
        if (!values.job || (values.decision !== 'confirm' && values.decision !== 'cancel')) {
          throw new Error('Usa --job <uuid> --decision confirm|cancel --reason "nota"');
        }
        const { to } = await app
          .get(JobStatusService)
          .apply(
            values.job,
            values.decision === 'confirm' ? 'RESOLVE_CONFIRM' : 'RESOLVE_CANCEL',
            { role: 'admin', id: null },
            { note: values.reason ?? 'Resuelto con dev-tools' },
          );
        logger.log(`Trabajo ${values.job} ahora ${to}`);
        break;
      }
      case 'billing-run': {
        // Cron de cobros (ADR-0036) con reloj simulado: cierra, vence y programa avisos como
        // si fuera esa hora. Los avisos y bloqueos los hace el worker (debe estar corriendo).
        const at = values.at ? new Date(values.at) : new Date();
        if (Number.isNaN(at.getTime()))
          throw new Error('Usa --at con una fecha ISO, p. ej. 2026-10-19T04:05:00Z');
        const result = await app.get(BillingCatchUpService).run(at);
        logger.log(`Cobros al ${at.toISOString()}: ${JSON.stringify(result)}`);
        break;
      }
      case 'ops-drill': {
        const kind = rest[0] as DrillKind | undefined;
        if (!kind || !['outbox', 'otp', 'push', 'clear'].includes(kind)) {
          throw new Error('Usa ops-drill outbox|otp|push|clear');
        }
        logger.log(await app.get(OpsDrill).run(kind));
        break;
      }
      case 'retention': {
        // Corre la retención a mano (ADR-0050). --dry-run solo cuenta.
        const dryRun = values['dry-run'] ?? false;
        const report = await app.get(RetentionService).run({ dryRun });
        logger.log(`Retención${dryRun ? ' (prueba)' : ''}: ${JSON.stringify(report)}`);
        break;
      }
      case 'loadtest-seed': {
        // Usuarios de la prueba de carga con sus tokens (ADR-0053). Nunca en producción.
        const seeded = await app
          .get(LoadtestSeeder)
          .seed(Number(values.workers ?? 200), Number(values.employers ?? 40), status);
        const out = values.out ?? 'loadtest-usuarios.json';
        writeFileSync(out, JSON.stringify(seeded, null, 2));
        logger.log(
          `Prueba de carga: ${String(seeded.workers.length)} trabajadores y ${String(seeded.employers.length)} empleadores en ${out} (contiene tokens: no compartir)`,
        );
        break;
      }
      case 'db-stats': {
        // Conexiones a Postgres por estado cada 5 s (CSV), durante la prueba de carga.
        const times = Number(values.times ?? 12);
        console.log('hora,estado,conexiones');
        for (let i = 0; i < times; i++) {
          const now = new Date().toISOString();
          for (const row of await app.get(LoadtestSeeder).dbStats()) {
            console.log(`${now},${row.state},${String(row.n)}`);
          }
          if (i < times - 1) await new Promise((r) => setTimeout(r, 5000));
        }
        break;
      }
      case 'resolve-report': {
        // Igual que POST /admin/reports/:id/resolve (ADR-0033): --approve = válido.
        if (!values.report || (!values.approve && !values.reject)) {
          throw new Error('Usa --report <uuid> y --approve --reason "nota" o --reject "motivo"');
        }
        const valid = values.approve === true;
        const { outcome } = await app
          .get(ReportsService)
          .resolve(
            null,
            values.report,
            valid,
            (valid ? values.reason : values.reject) ?? 'Resuelto con dev-tools',
          );
        logger.log(`Reporte ${valid ? 'válido' : 'descartado'}; resultado: ${outcome}`);
        break;
      }
      default:
        throw new Error(
          'Comandos: review-worker, worker-event, create-category, admin-totp, quick-worker, resolve-dispute, resolve-report, billing-run (ver src/scripts/dev-tools.ts)',
        );
    }
  } finally {
    await app.close();
  }
}

main().catch((error: unknown) => {
  logger.error(error instanceof Error ? error.message : String(error));
  process.exit(1);
});
