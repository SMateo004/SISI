import { decimal } from '../categories/effective-category';
import { assertValidCoordinates, distanceKm, isInsideServiceArea, type LatLng } from './location';
import { priceWarnings } from './price-warning';
import {
  allowedRequestTransitions,
  canApplyRequest,
  nextRequestStatus,
  REQUEST_EVENTS,
  REQUEST_STATUSES,
  type RequestEvent,
  type RequestStatus,
  RequestTransitionError,
} from './request-status.machine';

const EXPECTED: [RequestStatus, RequestEvent, RequestStatus][] = [
  ['borrador', 'PUBLISH_CLEAN', 'buscando'],
  ['borrador', 'PUBLISH_HELD', 'retenida'],
  ['retenida', 'RELEASE', 'buscando'],
  ['retenida', 'REJECT', 'cancelada'],
  ['borrador', 'CANCEL', 'cancelada'],
  ['retenida', 'CANCEL', 'cancelada'],
  ['buscando', 'CANCEL', 'cancelada'],
  ['con_ofertas', 'CANCEL', 'cancelada'],
  ['buscando', 'RECEIVE_OFFER', 'con_ofertas'],
  ['con_ofertas', 'ASSIGN', 'asignada'],
  ['buscando', 'EXPIRE', 'expirada'],
  ['con_ofertas', 'EXPIRE', 'expirada'],
  // Fase 4: si se retira la única oferta, vuelve a buscar.
  ['con_ofertas', 'LAST_OFFER_WITHDRAWN', 'buscando'],
];

describe('máquina de estados de la solicitud (R3.4)', () => {
  it('usa exactamente los 7 estados de R3.4', () => {
    expect(REQUEST_STATUSES).toEqual([
      'borrador',
      'retenida',
      'buscando',
      'con_ofertas',
      'asignada',
      'cancelada',
      'expirada',
    ]);
  });

  it.each(EXPECTED)('%s --%s--> %s', (from, event, to) => {
    expect(nextRequestStatus(from, event)).toBe(to);
  });

  it('no hay transiciones fuera de las esperadas', () => {
    expect(
      allowedRequestTransitions()
        .map((t) => `${t.from}:${t.event}:${t.to}`)
        .sort(),
    ).toEqual(EXPECTED.map(([f, e, t]) => `${f}:${e}:${t}`).sort());
  });

  it('rechaza el resto con 409', () => {
    const allowed = new Set(EXPECTED.map(([f, e]) => `${f}:${e}`));
    for (const from of REQUEST_STATUSES) {
      for (const event of REQUEST_EVENTS) {
        if (allowed.has(`${from}:${event}`)) continue;
        expect(canApplyRequest(from, event)).toBe(false);
        expect(() => nextRequestStatus(from, event)).toThrow(RequestTransitionError);
      }
    }
  });

  it('una asignada, cancelada o expirada ya no se puede cancelar (R3.4)', () => {
    for (const from of ['asignada', 'cancelada', 'expirada'] as const) {
      expect(() => nextRequestStatus(from, 'CANCEL')).toThrow(
        'Esta solicitud ya no se puede cancelar.',
      );
    }
  });

  it('no se publica dos veces', () => {
    expect(() => nextRequestStatus('buscando', 'PUBLISH_CLEAN')).toThrow(RequestTransitionError);
  });
});

describe('validación de ubicación', () => {
  const plaza: LatLng = { lat: -17.7834, lng: -63.1821 };
  const area = { center: plaza, radiusKm: 15, insidePolygon: null };

  it('calcula distancias razonables', () => {
    // Plaza 24 de Septiembre → aeropuerto Viru Viru ≈ 14 km.
    expect(distanceKm(plaza, { lat: -17.6448, lng: -63.1354 })).toBeGreaterThan(14);
    expect(distanceKm(plaza, { lat: -17.6448, lng: -63.1354 })).toBeLessThan(17);
    expect(distanceKm(plaza, plaza)).toBe(0);
  });

  it('acepta puntos dentro del radio y rechaza fuera', () => {
    expect(isInsideServiceArea({ lat: -17.79, lng: -63.17 }, area)).toBe(true);
    // Montero (~50 km al norte).
    expect(isInsideServiceArea({ lat: -17.3388, lng: -63.2505 }, area)).toBe(false);
    // La Paz.
    expect(isInsideServiceArea({ lat: -16.5, lng: -68.15 }, area)).toBe(false);
  });

  it('si hay polígono, manda el polígono aunque el punto esté en el radio', () => {
    expect(
      isInsideServiceArea({ lat: -17.79, lng: -63.17 }, { ...area, insidePolygon: false }),
    ).toBe(false);
    expect(
      isInsideServiceArea({ lat: -17.3388, lng: -63.2505 }, { ...area, insidePolygon: true }),
    ).toBe(true);
  });

  it('sin centro ni polígono la ciudad no acepta solicitudes', () => {
    expect(isInsideServiceArea(plaza, { center: null, radiusKm: null, insidePolygon: null })).toBe(
      false,
    );
  });

  it('rechaza coordenadas inválidas', () => {
    for (const bad of [
      { lat: 91, lng: 0 },
      { lat: 0, lng: -181 },
      { lat: Number.NaN, lng: -63 },
      { lat: 0, lng: 0 },
    ]) {
      expect(() => {
        assertValidCoordinates(bad);
      }).toThrow('La ubicación no es válida.');
    }
    expect(() => {
      assertValidCoordinates(plaza);
    }).not.toThrow();
  });
});

describe('advertencia de precio (R3.2)', () => {
  const category = { name: 'Plomería', priceMinBs: decimal('80.00') };

  it('advierte si el precio está por debajo del mínimo de referencia', () => {
    expect(priceWarnings(decimal('79.99'), category)).toEqual([
      {
        code: 'PRICE_BELOW_REFERENCE',
        message:
          'Tu precio está por debajo del mínimo de referencia para Plomería (Bs 80,00). Puedes publicar igual, pero podrías recibir menos ofertas.',
        referenceMinBs: '80.00',
      },
    ]);
  });

  it('no advierte en el mínimo exacto ni por encima', () => {
    expect(priceWarnings(decimal('80.00'), category)).toEqual([]);
    expect(priceWarnings(decimal('500'), category)).toEqual([]);
  });
});
