import { assertNotSelf } from './self-review';

describe('assertNotSelf', () => {
  it('rechaza si la cuenta del admin está entre las afectadas', () => {
    expect(() => {
      assertNotSelf('a', ['b', 'a']);
    }).toThrow(expect.objectContaining({ code: 'SELF_REVIEW_FORBIDDEN' }) as Error);
  });

  it('usa el mensaje propio de la acción', () => {
    expect(() => {
      assertNotSelf('a', ['a'], 'No puedes pagar tu deuda.');
    }).toThrow('No puedes pagar tu deuda.');
  });

  it('deja pasar si no es parte, si no hay admin (sistema o dev-tools) y con nulos', () => {
    expect(() => {
      assertNotSelf('a', ['b', null, undefined]);
    }).not.toThrow();
    expect(() => {
      assertNotSelf(null, ['a']);
    }).not.toThrow();
  });
});
