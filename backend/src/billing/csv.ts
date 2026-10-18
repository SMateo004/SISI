import { toLocal } from './zoned-time';

/** BOM UTF-8: Excel abre bien las tildes y la ñ. */
export const CSV_BOM = '﻿';

/**
 * Celda de texto RFC 4180: comillas si hace falta y, para que una planilla no ejecute nada,
 * un apóstrofo delante de =, +, -, @, tabulador o retorno al inicio (inyección de fórmulas).
 */
export function textCell(value: string | null | undefined): string {
  let text = value ?? '';
  if (/^[=+\-@\t\r]/.test(text)) text = `'${text}`;
  return /[",\r\n]/.test(text) ? `"${text.replace(/"/g, '""')}"` : text;
}

/** Monto con punto decimal y 2 decimales (sin separador de miles), tal cual del ledger. */
export const amountCell = (value: { toFixed(digits: number): string }): string => value.toFixed(2);

/** Fecha y hora local de la ciudad: "2026-10-19 00:05". */
export function localCell(instant: Date, timeZone: string): string {
  const l = toLocal(instant, timeZone);
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${String(l.year)}-${pad(l.month)}-${pad(l.day)} ${pad(l.hour)}:${pad(l.minute)}`;
}

export const csvLine = (cells: string[]): string => `${cells.join(',')}\r\n`;
