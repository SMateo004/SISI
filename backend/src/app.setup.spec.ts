import { assertProductionCors } from './app.setup';

describe('assertProductionCors (ADR-0047)', () => {
  it('acepta orígenes https exactos', () => {
    expect(() => {
      assertProductionCors(['https://app.vercel.app', 'https://admin.vercel.app']);
    }).not.toThrow();
  });

  it('rechaza una lista vacía, http, comodines y rutas', () => {
    expect(() => {
      assertProductionCors([]);
    }).toThrow(/obligatorio/);
    expect(() => {
      assertProductionCors(['http://app.vercel.app']);
    }).toThrow(/http:/);
    expect(() => {
      assertProductionCors(['https://*.vercel.app']);
    }).toThrow(/\*/);
    expect(() => {
      assertProductionCors(['https://app.vercel.app/api']);
    }).toThrow(/api/);
  });
});
