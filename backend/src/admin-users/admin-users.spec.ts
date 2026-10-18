import { searchFilter } from './admin-users.service';

describe('searchFilter', () => {
  it('vacío: sin filtro', () => {
    expect(searchFilter(undefined)).toEqual({});
    expect(searchFilter('   ')).toEqual({});
  });

  it('dígitos, con o sin +591 y separadores: por teléfono', () => {
    for (const q of ['70012345', '+59170012345', '591 700-12345', '7001']) {
      expect(searchFilter(q)).toEqual({
        phone: { contains: q === '7001' ? '7001' : '70012345' },
      });
    }
  });

  it('texto: por nombre sin distinguir mayúsculas', () => {
    expect(searchFilter(' Rosa Q ')).toEqual({
      name: { contains: 'Rosa Q', mode: 'insensitive' },
    });
  });
});
