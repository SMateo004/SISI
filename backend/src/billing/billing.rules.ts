import { randomInt } from 'node:crypto';
import { Prisma } from '../generated/prisma/client';
import { addDays, fromLocal, isoWeek, toLocal } from './zoned-time';

type Decimal = Prisma.Decimal;
const ZERO = new Prisma.Decimal(0);

export interface BillingCalendar {
  timeZone: string;
  /** Días después del fin del periodo hasta el vencimiento (exclusivo). 3 → jueves 00:00. */
  dueAfterDays: number;
  /** Hora local de los recordatorios (víspera y día del vencimiento). */
  reminderHour: number;
}

export interface PeriodWindow {
  startAt: Date;
  endAt: Date;
  dueAt: Date;
}

/**
 * Semana de cobro de un instante (R7.2, ADR-0035): [lunes 00:00, lunes siguiente 00:00) en
 * la hora local. Vence `dueAfterDays` después del fin, a las 00:00 locales (exclusivo): con
 * 3 días, "miércoles 23:59".
 */
export function periodWindow(instant: Date, cal: BillingCalendar): PeriodWindow {
  const local = toLocal(instant, cal.timeZone);
  const monday = addDays(local, 1 - local.weekday);
  const nextMonday = addDays(monday, 7);
  return {
    startAt: fromLocal(monday, cal.timeZone),
    endAt: fromLocal(nextMonday, cal.timeZone),
    dueAt: fromLocal(addDays(nextMonday, cal.dueAfterDays), cal.timeZone),
  };
}

/**
 * Recordatorios (R7.6, interpretación aprobada): víspera y día del vencimiento, a la hora
 * local configurada. El "día del vencimiento" es el último día antes de `dueAt`.
 */
export function reminderTimes(dueAt: Date, cal: BillingCalendar): { vispera: Date; dia: Date } {
  const dueLocal = toLocal(dueAt, cal.timeZone);
  const dueDay = addDays(dueLocal, -1);
  return {
    vispera: fromLocal({ ...addDays(dueDay, -1), hour: cal.reminderHour }, cal.timeZone),
    dia: fromLocal({ ...dueDay, hour: cal.reminderHour }, cal.timeZone),
  };
}

const WEEKDAY_NAMES = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];

/**
 * Fecha límite como la lee una persona: el último minuto antes de `dueAt` en hora local.
 * Ej.: "miércoles 21/10 a las 23:59".
 */
export function dueLabel(dueAt: Date, timeZone: string): string {
  const l = toLocal(new Date(dueAt.getTime() - 60_000), timeZone);
  const two = (n: number) => String(n).padStart(2, '0');
  return `${WEEKDAY_NAMES[l.weekday - 1] ?? ''} ${two(l.day)}/${two(l.month)} a las ${two(l.hour)}:${two(l.minute)}`;
}

/** Sin 0/O, 1/I/L, para dictar y escribir sin errores. */
const CODE_ALPHABET = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';

/** Código del trabajador para la referencia: 6 caracteres sin ambigüedad. */
export function newBillingCode(random: (max: number) => number = randomInt): string {
  let code = '';
  for (let i = 0; i < 6; i++) code += CODE_ALPHABET.charAt(random(CODE_ALPHABET.length));
  return code;
}

/**
 * Referencia de pago para la glosa (ADR-0035): SISI-<AASS>-<código>, con el año y la
 * semana ISO de la fecha local de inicio. Ej.: SISI-2643-K7M2QX. Única por trabajador y semana.
 */
export function paymentReference(startAt: Date, timeZone: string, billingCode: string): string {
  const { year, week } = isoWeek(toLocal(startAt, timeZone));
  return `SISI-${String(year % 100).padStart(2, '0')}${String(week).padStart(2, '0')}-${billingCode}`;
}

export type PeriodStatus = 'abierto' | 'cerrado_pendiente' | 'pagado' | 'vencido';

/**
 * Estado de un periodo según su saldo y la hora (R7.8). Abierto mientras no termina; al
 * terminar, pagado si no debe nada; si debe, pendiente hasta el vencimiento y luego vencido.
 * Sirve para cerrar, para recalcular después de un pago o ajuste, y para vencer.
 */
export function periodStatus(input: {
  endAt: Date;
  dueAt: Date;
  balance: Decimal;
  now: Date;
}): PeriodStatus {
  if (input.now < input.endAt) return 'abierto';
  if (input.balance.lte(ZERO)) return 'pagado';
  return input.now >= input.dueAt ? 'vencido' : 'cerrado_pendiente';
}

export interface OpenBalance {
  periodId: string;
  balance: Decimal;
}

/**
 * Reparte un pago (ADR-0037): primero los periodos más antiguos con saldo, en orden; lo que
 * sobra (pago anticipado del periodo abierto o pago de más) va al periodo `restPeriodId`.
 * Devuelve montos positivos por periodo (el movimiento lleva el signo negativo).
 */
export function allocatePayment(
  amount: Decimal,
  oldestFirst: OpenBalance[],
  restPeriodId: string,
): { periodId: string; amount: Decimal }[] {
  const out: { periodId: string; amount: Decimal }[] = [];
  let left = amount;
  for (const p of oldestFirst) {
    if (left.lte(ZERO)) break;
    if (p.periodId === restPeriodId || p.balance.lte(ZERO)) continue;
    const part = Prisma.Decimal.min(left, p.balance);
    out.push({ periodId: p.periodId, amount: part });
    left = left.sub(part);
  }
  if (left.gt(ZERO)) out.push({ periodId: restPeriodId, amount: left });
  return out;
}

/** Suma de movimientos con signo: saldo (positivo = debe). */
export function sumLedger(amounts: Decimal[]): Decimal {
  return amounts.reduce((acc, a) => acc.add(a), ZERO);
}

/**
 * Cuánto pagar para volver a recibir solicitudes (ajuste aprobado): lo necesario para que el
 * saldo total quede en el tope o por debajo. 0 si no está sobre el tope.
 */
export function amountToUnlockCap(totalBalance: Decimal, cap: Decimal): Decimal {
  return totalBalance.gt(cap) ? totalBalance.sub(cap) : ZERO;
}

/** Cruce del tope (R7.5): avisar al subir una vez; limpiar la marca al bajar. */
export function capTransition(
  totalBalance: Decimal,
  cap: Decimal,
  alreadyReached: boolean,
): 'notify' | 'clear' | 'none' {
  const over = totalBalance.gt(cap);
  if (over && !alreadyReached) return 'notify';
  if (!over && alreadyReached) return 'clear';
  return 'none';
}
