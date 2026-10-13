import type { ConfigService } from '@nestjs/config';
import type { Env } from './env.schema';

/** ConfigService tipado con el esquema validado. Uso: config.get('PORT', { infer: true }). */
export type AppConfigService = ConfigService<Env, true>;
