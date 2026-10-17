/**
 * Fechas de negocio en la zona horaria de la ciudad (ADR-0035). Sin dependencias: usa
 * Intl para conocer el offset real de la zona en cada instante, así que no asume UTC−4
 * ni la ausencia de horario de verano.
 */

export interface LocalDateTime {
  year: number;
  /** 1–12 */
  month: number;
  day: number;
  hour: number;
  minute: number;
  second: number;
  /** 1 = lunes … 7 = domingo (ISO). */
  weekday: number;
}

const WEEKDAYS: Record<string, number> = { Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 };
const formatters = new Map<string, Intl.DateTimeFormat>();

function formatter(timeZone: string): Intl.DateTimeFormat {
  let f = formatters.get(timeZone);
  if (!f) {
    f = new Intl.DateTimeFormat('en-US', {
      timeZone,
      hourCycle: 'h23',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      weekday: 'short',
    });
    formatters.set(timeZone, f);
  }
  return f;
}

/** Fecha y hora de pared de un instante en la zona dada. */
export function toLocal(instant: Date, timeZone: string): LocalDateTime {
  const parts = Object.fromEntries(
    formatter(timeZone)
      .formatToParts(instant)
      .map((p) => [p.type, p.value]),
  );
  return {
    year: Number(parts.year),
    month: Number(parts.month),
    day: Number(parts.day),
    hour: Number(parts.hour),
    minute: Number(parts.minute),
    second: Number(parts.second),
    weekday: WEEKDAYS[parts.weekday ?? ''] ?? 1,
  };
}

/** Offset de la zona (ms, local − UTC) en ese instante. */
function offsetMs(instant: Date, timeZone: string): number {
  const l = toLocal(instant, timeZone);
  const asUtc = Date.UTC(l.year, l.month - 1, l.day, l.hour, l.minute, l.second);
  return asUtc - Math.floor(instant.getTime() / 1000) * 1000;
}

/**
 * Instante UTC de una hora de pared local. Corrige el offset dos veces para los saltos de
 * horario de verano; una hora inexistente (salto hacia adelante) cae en la siguiente válida.
 */
export function fromLocal(
  local: { year: number; month: number; day: number; hour?: number; minute?: number },
  timeZone: string,
): Date {
  const wall = Date.UTC(local.year, local.month - 1, local.day, local.hour ?? 0, local.minute ?? 0);
  let guess = new Date(wall - offsetMs(new Date(wall), timeZone));
  guess = new Date(wall - offsetMs(guess, timeZone));
  return guess;
}

/** Suma días a una fecha de calendario (sin zona). */
export function addDays(
  date: { year: number; month: number; day: number },
  days: number,
): { year: number; month: number; day: number } {
  const d = new Date(Date.UTC(date.year, date.month - 1, date.day + days));
  return { year: d.getUTCFullYear(), month: d.getUTCMonth() + 1, day: d.getUTCDate() };
}

/** Semana ISO (año y número) de una fecha de calendario. */
export function isoWeek(date: { year: number; month: number; day: number }): {
  year: number;
  week: number;
} {
  const d = new Date(Date.UTC(date.year, date.month - 1, date.day));
  const weekday = d.getUTCDay() === 0 ? 7 : d.getUTCDay();
  d.setUTCDate(d.getUTCDate() + 4 - weekday);
  const yearStart = Date.UTC(d.getUTCFullYear(), 0, 1);
  const week = Math.ceil(((d.getTime() - yearStart) / 86_400_000 + 1) / 7);
  return { year: d.getUTCFullYear(), week };
}
