import { Prisma } from '../generated/prisma/client';
import { amountCell, CSV_BOM, csvLine, localCell, textCell } from './csv';

describe('CSV para el contador', () => {
  it('texto: comillas cuando hay coma, comilla o salto de línea', () => {
    expect(textCell('Rosa Quispe')).toBe('Rosa Quispe');
    expect(textCell('Quispe, Rosa')).toBe('"Quispe, Rosa"');
    expect(textCell('dijo "hola"')).toBe('"dijo ""hola"""');
    expect(textCell('línea 1\nlínea 2')).toBe('"línea 1\nlínea 2"');
    expect(textCell(null)).toBe('');
  });

  it('texto: neutraliza fórmulas (=, +, -, @) con un apóstrofo', () => {
    expect(textCell('=HYPERLINK("x")')).toBe(`"'=HYPERLINK(""x"")"`);
    expect(textCell('+591')).toBe("'+591");
    expect(textCell('-algo')).toBe("'-algo");
    expect(textCell('@sum')).toBe("'@sum");
  });

  it('montos con signo, punto decimal y 2 decimales (sin apóstrofo: es un número)', () => {
    expect(amountCell(new Prisma.Decimal('-19.5'))).toBe('-19.50');
    expect(amountCell(new Prisma.Decimal('1234.567'))).toBe('1234.57');
  });

  it('fecha y hora local de la ciudad', () => {
    expect(localCell(new Date('2026-10-19T04:05:00.000Z'), 'America/La_Paz')).toBe(
      '2026-10-19 00:05',
    );
  });

  it('líneas con CRLF y BOM UTF-8', () => {
    expect(csvLine(['a', 'b'])).toBe('a,b\r\n');
    expect(CSV_BOM).toBe('﻿');
  });
});
