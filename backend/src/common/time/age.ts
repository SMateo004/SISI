const ISO_DATE = /^(\d{4})-(\d{2})-(\d{2})$/;

interface YearMonthDay {
  year: number;
  month: number;
  day: number;
}

/** Interpreta 'AAAA-MM-DD' validando que sea una fecha real del calendario. */
export function parseIsoDate(value: string): YearMonthDay | null {
  const match = ISO_DATE.exec(value);
  if (!match) return null;
  const [year, month, day] = [Number(match[1]), Number(match[2]), Number(match[3])];
  const date = new Date(Date.UTC(year, month - 1, day));
  if (
    date.getUTCFullYear() !== year ||
    date.getUTCMonth() !== month - 1 ||
    date.getUTCDate() !== day
  ) {
    return null;
  }
  return { year, month, day };
}

/** Fecha calendario de `now` en la zona horaria dada (p. ej. America/La_Paz). */
export function calendarDateIn(now: Date, timeZone: string): YearMonthDay {
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(now);
  const get = (type: string): number => Number(parts.find((p) => p.type === type)?.value);
  return { year: get('year'), month: get('month'), day: get('day') };
}

/**
 * Edad cumplida en años a la fecha de `now` en `timeZone`.
 * Quien nació un 29 de febrero cumple años el 1 de marzo en años no bisiestos.
 */
export function ageOn(birth: YearMonthDay, now: Date, timeZone: string): number {
  const today = calendarDateIn(now, timeZone);
  const hadBirthday =
    today.month > birth.month || (today.month === birth.month && today.day >= birth.day);
  return today.year - birth.year - (hadBirthday ? 0 : 1);
}

/** Mayoría de edad (R1.3): 18 años cumplidos en la hora de Bolivia. */
export function isAdult(
  birthDate: string,
  now: Date,
  timeZone = 'America/La_Paz',
  minAge = 18,
): boolean {
  const birth = parseIsoDate(birthDate);
  if (!birth) return false;
  return ageOn(birth, now, timeZone) >= minAge;
}
