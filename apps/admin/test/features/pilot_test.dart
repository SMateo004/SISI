import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

final _now = DateTime.utc(2026, 11, 2, 14);

PilotOverviewDto _overview({bool closed = true}) => PilotOverviewDto(
  cityId: 'c1',
  cityName: 'Santa Cruz de la Sierra',
  closed: closed,
  allowlist: [
    PilotPhoneDto(
      id: 'p1',
      phone: '+59170000011',
      note: 'Grupo 1',
      createdAt: _now,
    ),
  ],
  interestCount: 1,
);

/// Fase 7: piloto cerrado, zona de la ciudad, métricas del piloto y parámetros de texto.
void main() {
  group('piloto (ADR-0052)', () {
    testWidgets(
      'pegar números los habilita con motivo y muestra el resultado',
      (tester) async {
        final api = FakeApi()
          ..on(#adminPilotControllerOverview, (_) async => ok(_overview()))
          ..on(
            #adminPilotControllerInterest,
            (_) async => ok([
              PilotInterestRowDto(
                id: 'i1',
                phone: '+59171111111',
                role: PilotInterestRowDtoRoleEnum.worker,
                categoryName: 'Plomería',
                zone: 'Plan 3000',
                createdAt: _now,
              ),
            ]),
          )
          ..on(
            #adminPilotControllerAdd,
            (_) async => ok(
              AddPilotPhonesResultDto(
                added: ['+59170000022'],
                alreadyListed: [],
                invalid: ['123'],
              ),
            ),
          );
        await pumpAdmin(tester, api: api, location: '/configuracion/piloto');

        expect(
          find.textContaining('Piloto cerrado en Santa Cruz'),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('pilot-phone-+59170000011')),
          findsOneWidget,
        );
        expect(find.textContaining('Plan 3000'), findsOneWidget);

        await tester.enterText(
          find.byKey(const Key('pilot-phones')),
          '70000022\n123',
        );
        await tester.tap(find.byKey(const Key('pilot-add')));
        await tester.pumpAndSettle();
        await confirmWithReason(tester, 'Primer grupo del piloto');

        final dto =
            api.callsTo(#adminPilotControllerAdd).single[#addPilotPhonesDto]
                as AddPilotPhonesDto;
        expect(dto.phones, ['70000022', '123']);
        expect(dto.reason, 'Primer grupo del piloto');
        expect(find.textContaining('Inválidos: 123'), findsOneWidget);
      },
    );

    testWidgets('quitar un número pide motivo', (tester) async {
      final api = FakeApi()
        ..on(#adminPilotControllerOverview, (_) async => ok(_overview()))
        ..on(
          #adminPilotControllerInterest,
          (_) async => ok(<PilotInterestRowDto>[]),
        )
        ..on(#adminPilotControllerRemove, (_) async => ok<void>(null));
      await pumpAdmin(tester, api: api, location: '/configuracion/piloto');
      await tester.tap(find.byTooltip('Quitar'));
      await tester.pumpAndSettle();
      await confirmWithReason(tester, 'Pidió salir del piloto');
      expect(api.callsTo(#adminPilotControllerRemove).single[#id], 'p1');
    });
  });

  group('zona de la ciudad (ADR-0052)', () {
    testWidgets(
      'pegar un polígono muestra la vista previa, prueba un punto y guarda con motivo',
      (tester) async {
        const geojson =
            '{"type":"Polygon","coordinates":[[[-63.192,-17.774],[-63.172,-17.774],[-63.172,-17.793],[-63.192,-17.793],[-63.192,-17.774]]]}';
        final api = FakeApi()
          ..on(#adminCategoriesControllerList, (_) async => ok([category()]))
          ..on(
            #adminCitiesControllerList,
            (_) async => ok([
              AdminCityDto(
                id: 'c1',
                slug: 'santa-cruz',
                name: 'Santa Cruz de la Sierra',
                timezone: 'America/La_Paz',
                active: true,
              ),
            ]),
          )
          ..on(
            #adminCityAreaControllerGet,
            (_) async => ok(
              CityAreaDto(
                cityId: 'c1',
                centerLat: -17.7834,
                centerLng: -63.1821,
                radiusKm: 15,
                geojson: null,
              ),
            ),
          )
          ..on(
            #adminCityAreaControllerTest,
            (_) async => ok(
              TestPointResultDto(
                inside: true,
                by: TestPointResultDtoByEnum.polygon,
              ),
            ),
          )
          ..on(
            #adminCityAreaControllerSet,
            (_) async => ok(
              CityAreaDto(
                cityId: 'c1',
                centerLat: -17.7834,
                centerLng: -63.1821,
                radiusKm: 15,
                geojson: geojson,
              ),
            ),
          );
        await pumpAdmin(tester, api: api, location: '/catalogo/ciudades');
        await tester.tap(find.byKey(const Key('city-area-santa-cruz')));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('area-geojson')), geojson);
        await tester.pumpAndSettle();
        expect(find.byType(CustomPaint), findsWidgets);
        await tester.tap(find.byKey(const Key('area-test')));
        await tester.pumpAndSettle();
        expect(find.text('Dentro de la zona (polígono).'), findsOneWidget);

        await tester.tap(find.byKey(const Key('area-save')));
        await tester.pumpAndSettle();
        await confirmWithReason(tester, 'Zona acordada con operaciones');
        final dto =
            api.callsTo(#adminCityAreaControllerSet).single[#setCityAreaDto]
                as SetCityAreaDto;
        expect(dto.geojson, geojson);
        expect(dto.reason, 'Zona acordada con operaciones');
      },
    );
  });

  group('dashboard del piloto', () {
    testWidgets('muestra el embudo, la tasa de cobro y la retención semanal', (
      tester,
    ) async {
      final api = FakeApi()
        ..on(#dashboardControllerGet, (_) async => ok(dashboard()))
        ..on(
          #dashboardControllerPilot,
          (_) async => ok(
            PilotMetricsDto(
              cityId: 'c1',
              cityName: 'Santa Cruz de la Sierra',
              startedAt: '2026-11-02',
              from: _now,
              to: _now,
              funnel: PilotFunnelDto(
                created: 20,
                withOffer: 16,
                assigned: 12,
                completed: 10,
                commissionCollected: 6,
              ),
              avgFirstOfferSec: 90,
              expirationRatePct: 15,
              collectionRatePct: 62.5,
              weekly: [
                PilotWeekDto(
                  weekStart: '2026-11-02',
                  activeWorkers: 8,
                  activeEmployers: 12,
                  workerRetentionPct: null,
                  employerRetentionPct: null,
                ),
                PilotWeekDto(
                  weekStart: '2026-11-09',
                  activeWorkers: 9,
                  activeEmployers: 10,
                  workerRetentionPct: 75,
                  employerRetentionPct: 50,
                ),
              ],
            ),
          ),
        );
      await pumpAdmin(tester, api: api, location: '/');
      await tester.tap(find.text('Piloto'));
      await tester.pumpAndSettle();

      expect(
        find.text('Desde el inicio del piloto: 2026-11-02'),
        findsOneWidget,
      );
      expect(find.text('16 (80 %)'), findsOneWidget);
      expect(find.text('62,5 %'), findsOneWidget);
      expect(find.text('75 %'), findsOneWidget);
    });
  });

  group('parámetros de texto', () {
    testWidgets(
      'el WhatsApp de soporte se escribe tal cual (sin convertir unidades)',
      (tester) async {
        final support = SettingDto(
          key: 'SUPPORT_WHATSAPP',
          group: SettingDtoGroupEnum.values.firstWhere((e) => e.value == 'app'),
          label: 'WhatsApp de soporte',
          help: 'Número de WhatsApp Business.',
          kind: SettingDtoKindEnum.values.firstWhere((e) => e.value == 'text'),
          unit: SettingDtoUnitEnum.values.firstWhere((e) => e.value == 'texto'),
          min: null,
          max: null,
          value: '',
          defaultValue: '',
          overridden: false,
          updatedAt: null,
        );
        final api = FakeApi()
          ..on(#adminSettingsControllerList, (_) async => ok([support]))
          ..on(#adminSettingsControllerSet, (_) async => ok(support));
        await pumpAdmin(
          tester,
          api: api,
          location: '/configuracion/parametros',
        );
        expect(find.text('App y piloto'), findsOneWidget);
        expect(find.text('(vacío)'), findsOneWidget);
        await tester.tap(find.byTooltip('Cambiar'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const Key('setting-value')),
          '+59170000001',
        );
        await tester.tap(find.byKey(const Key('setting-next')));
        await tester.pumpAndSettle();
        await confirmWithReason(tester, 'Número de soporte del piloto');
        final dto =
            api.callsTo(#adminSettingsControllerSet).single[#setSettingDto]
                as SetSettingDto;
        expect(dto.value, '+59170000001');
      },
    );
  });
}
