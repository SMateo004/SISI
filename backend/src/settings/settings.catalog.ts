import type { Env } from '../config/env.schema';
import { parseRings } from '../matching/matching.config';

/**
 * Parámetros de negocio editables desde el panel (ADR-0043). La variable de entorno es el
 * valor por defecto (y la que usan los e2e, en milisegundos); el panel guarda un valor
 * propio en app_settings. Los rangos son de producción: el panel no acepta valores de prueba.
 */
export type SettingKind = 'int' | 'decimal' | 'rings';

export interface SettingDef {
  key: keyof Env;
  group: 'matching' | 'ofertas' | 'trabajos' | 'cobros';
  label: string;
  help: string;
  kind: SettingKind;
  /** Unidad del valor guardado; el panel la muestra (y convierte ms a minutos u horas). */
  unit: 'ms' | 'días' | 'hora' | 'Bs' | 'ofertas' | 'veces' | 'anillos';
  min?: number;
  max?: number;
  /** El entorno lo guarda como texto (montos en Bs con 2 decimales). */
  money?: boolean;
}

const MIN = 60_000;
const HOUR = 60 * MIN;
const DAY = 24 * HOUR;

export const SETTINGS: readonly SettingDef[] = [
  {
    key: 'MATCHING_RINGS',
    group: 'matching',
    label: 'Anillos de búsqueda',
    help: 'km:máximo de trabajadores por anillo, de adentro hacia afuera (R4.2). Ej.: 2:5,5:10,10:10.',
    kind: 'rings',
    unit: 'anillos',
  },
  {
    key: 'MATCHING_RING_WAIT_MS',
    group: 'matching',
    label: 'Espera por anillo',
    help: 'Cuánto se espera en cada anillo antes de ampliar (R4.3).',
    kind: 'int',
    unit: 'ms',
    min: 15_000,
    max: 10 * MIN,
  },
  {
    key: 'MATCHING_ENOUGH_OFFERS',
    group: 'matching',
    label: 'Ofertas suficientes',
    help: 'Con esta cantidad de ofertas activas no se amplía el anillo.',
    kind: 'int',
    unit: 'ofertas',
    min: 1,
    max: 10,
  },
  {
    key: 'MATCHING_OFFERS_GRACE_MS',
    group: 'matching',
    label: 'Plazo para elegir una oferta',
    help: 'Con ofertas sin elegir después del último anillo, la solicitud expira pasado este tiempo.',
    kind: 'int',
    unit: 'ms',
    min: 2 * MIN,
    max: 2 * HOUR,
  },
  {
    key: 'MATCHING_MIN_SEARCH_MS',
    group: 'matching',
    label: 'Tiempo mínimo de búsqueda',
    help: 'Aunque los anillos estén vacíos, se sigue buscando al menos este tiempo desde la publicación.',
    kind: 'int',
    unit: 'ms',
    min: 0,
    max: 30 * MIN,
  },
  {
    key: 'OFFER_COUNTER_MAX_FACTOR',
    group: 'ofertas',
    label: 'Contraoferta máxima',
    help: 'Una contraoferta puede ser a lo sumo estas veces el precio propuesto.',
    kind: 'decimal',
    unit: 'veces',
    min: 1,
    max: 10,
  },
  {
    key: 'JOB_AUTOCONFIRM_MS',
    group: 'trabajos',
    label: 'Autoconfirmación',
    help: 'Si el empleador no confirma ni reporta un problema, el trabajo se confirma solo pasado este tiempo.',
    kind: 'int',
    unit: 'ms',
    min: HOUR,
    max: 7 * DAY,
  },
  {
    key: 'JOB_CHAT_OPEN_AFTER_MS',
    group: 'trabajos',
    label: 'Chat abierto después del trabajo',
    help: 'Después de terminado o cancelado, el chat queda abierto este tiempo (luego, solo lectura).',
    kind: 'int',
    unit: 'ms',
    min: HOUR,
    max: 7 * DAY,
  },
  {
    key: 'JOB_CONTACT_VISIBLE_AFTER_MS',
    group: 'trabajos',
    label: 'Contacto visible después del trabajo',
    help: 'Después de terminado o cancelado, el teléfono de la contraparte se ve este tiempo.',
    kind: 'int',
    unit: 'ms',
    min: HOUR,
    max: 7 * DAY,
  },
  {
    key: 'REVIEW_WINDOW_MS',
    group: 'trabajos',
    label: 'Plazo para calificar',
    help: 'Las calificaciones se publican cuando califican los dos o al vencer este plazo.',
    kind: 'int',
    unit: 'ms',
    min: DAY,
    max: 30 * DAY,
  },
  {
    key: 'BILLING_DEBT_CAP_BS',
    group: 'cobros',
    label: 'Tope de deuda',
    help: 'Con un saldo mayor, el trabajador deja de recibir solicitudes nuevas (R7.5).',
    kind: 'decimal',
    unit: 'Bs',
    min: 0,
    max: 5000,
    money: true,
  },
  {
    key: 'BILLING_DUE_AFTER_DAYS',
    group: 'cobros',
    label: 'Días para pagar después del corte',
    help: 'Solo afecta a los periodos que se crean desde el cambio (la fecha límite se fija al crear el periodo).',
    kind: 'int',
    unit: 'días',
    min: 1,
    max: 14,
  },
  {
    key: 'BILLING_REMINDER_HOUR',
    group: 'cobros',
    label: 'Hora de los recordatorios',
    help: 'Hora local de los avisos de víspera y del día del vencimiento (R7.6).',
    kind: 'int',
    unit: 'hora',
    min: 6,
    max: 21,
  },
];

export type SettingKey = (typeof SETTINGS)[number]['key'];

export const settingDef = (key: string): SettingDef | undefined =>
  SETTINGS.find((s) => s.key === key);

/**
 * Valida un valor nuevo según su definición. Devuelve el valor normalizado (número o texto
 * de anillos) o un mensaje de error en español.
 */
export function validateSetting(
  def: SettingDef,
  raw: unknown,
): { ok: true; value: number | string } | { ok: false; message: string } {
  if (def.kind === 'rings') {
    if (typeof raw !== 'string')
      return { ok: false, message: 'Escribe los anillos como km:límite.' };
    try {
      const rings = parseRings(raw);
      if (rings.length > 6) return { ok: false, message: 'Hasta 6 anillos.' };
      if (rings.some((r) => r.maxKm > 30 || r.limit > 50)) {
        return { ok: false, message: 'Cada anillo llega hasta 30 km y 50 trabajadores.' };
      }
      return {
        ok: true,
        value: rings.map((r) => `${String(r.maxKm)}:${String(r.limit)}`).join(','),
      };
    } catch (error) {
      return { ok: false, message: (error as Error).message };
    }
  }
  const value = typeof raw === 'string' ? Number(raw) : raw;
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return { ok: false, message: 'El valor debe ser un número.' };
  }
  if (def.kind === 'int' && !Number.isInteger(value)) {
    return { ok: false, message: 'El valor debe ser un número entero.' };
  }
  if (def.kind === 'decimal' && Math.round(value * 100) !== value * 100) {
    return { ok: false, message: 'Hasta 2 decimales.' };
  }
  if ((def.min !== undefined && value < def.min) || (def.max !== undefined && value > def.max)) {
    return {
      ok: false,
      message: `Fuera de rango: entre ${String(def.min)} y ${String(def.max)} (${def.unit}).`,
    };
  }
  return { ok: true, value: def.money ? value.toFixed(2) : value };
}
