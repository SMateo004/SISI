import { parseArgs } from 'node:util';
import { Logger, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestFactory } from '@nestjs/core';
import { normalizePhone } from '../common/phone/phone';
import type { AppConfigService } from '../config/app-config';
import { AppConfigModule } from '../config/config.module';
import { WorkerAvailabilityModule } from '../locations/locations.module';
import { PrismaModule } from '../prisma/prisma.module';
import { PrismaService } from '../prisma/prisma.service';
import { RedisModule } from '../redis/redis.module';
import {
  DEBT_STATUS_PROVIDER,
  LoggingWorkerNotifier,
  NoBillingYetDebtProvider,
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
 *   npm run dev:tools -- make-admin --phone 70012345
 *   npm run dev:tools -- quick-worker --phone 70012345 --categories plomeria,limpieza --transport moto --radius 10
 */
@Module({
  // WorkerStatusService apaga la disponibilidad al bloquear o suspender (Redis, ADR-0024).
  imports: [AppConfigModule, PrismaModule, RedisModule, WorkerAvailabilityModule],
  providers: [
    WorkerStatusService,
    { provide: DEBT_STATUS_PROVIDER, useClass: NoBillingYetDebtProvider },
    { provide: WORKER_NOTIFIER, useClass: LoggingWorkerNotifier },
  ],
})
class DevToolsModule {}

const logger = new Logger('dev-tools');

async function main(): Promise<void> {
  const [command, ...rest] = process.argv.slice(2);
  const { values } = parseArgs({
    args: rest,
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
        logger.log(`Perfil de ${values.phone ?? ''} ahora en estado ${profile.status}`);
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
      case 'make-admin': {
        const userId = await userIdFor(values.phone);
        await prisma.user.update({ where: { id: userId }, data: { role: 'admin' } });
        logger.log(`La cuenta ${values.phone ?? ''} ahora es admin (vuelve a iniciar sesión)`);
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
      default:
        throw new Error(
          'Comandos: review-worker, worker-event, create-category, make-admin, quick-worker (ver src/scripts/dev-tools.ts)',
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
