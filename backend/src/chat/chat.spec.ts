import { chatPreview, chatWindow } from './chat.rules';

const DAY = 24 * 3600_000;
const NOW = Date.parse('2026-10-16T12:00:00Z');

describe('ventana del chat (ADR-0031)', () => {
  it.each(['asignado', 'en_camino', 'en_curso'])(
    'abierto mientras el trabajo está %s',
    (status) => {
      expect(chatWindow({ status, completedAt: null, cancelledAt: null }, NOW, DAY)).toEqual({
        open: true,
        closesAt: null,
      });
    },
  );

  it('terminado: abierto 24 h más y después solo lectura', () => {
    const completedAt = new Date(NOW - DAY + 1000);
    const job = { status: 'terminado', completedAt, cancelledAt: null };
    expect(chatWindow(job, NOW, DAY)).toEqual({
      open: true,
      closesAt: new Date(completedAt.getTime() + DAY),
    });
    expect(chatWindow(job, NOW + 1000, DAY).open).toBe(false);
  });

  it('cancelado: cuenta desde la cancelación', () => {
    const cancelledAt = new Date(NOW - DAY - 1);
    expect(chatWindow({ status: 'cancelado', completedAt: null, cancelledAt }, NOW, DAY).open).toBe(
      false,
    );
  });
});

describe('vista previa del aviso', () => {
  it('una línea y como mucho 80 caracteres', () => {
    expect(chatPreview('  Hola,\n llego   en 5  ')).toBe('Hola, llego en 5');
    const long = 'a'.repeat(200);
    expect(chatPreview(long)).toHaveLength(80);
    expect(chatPreview(long).endsWith('…')).toBe(true);
  });
});
