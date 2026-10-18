import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  group('usuarios', () {
    testWidgets('la ficha muestra el estado y suspender pide motivo', (
      tester,
    ) async {
      final api = FakeApi()
        ..on(#adminUsersControllerProfile, (_) async => ok(userProfile()))
        ..on(
          #adminUsersControllerSuspend,
          (_) async => ok(
            WorkerStatusResultDto(
              userId: 'w1',
              status: 'suspendido_moderacion',
              modeForcedToEmployer: true,
            ),
          ),
        );
      await pumpAdmin(tester, api: api, location: '/usuarios/w1');
      expect(find.text('Juan Pérez'), findsOneWidget);
      expect(find.text('★ 4,50 (12)'), findsOneWidget);
      expect(
        find.text('1 pendientes · 2 válidos · 0 descartados'),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('user-suspend')));
      await tester.pumpAndSettle();
      await confirmWithReason(tester, 'Tres reportes de acoso verificados');
      final dto =
          api.callsTo(#adminUsersControllerSuspend).single[#reasonDto]
              as ReasonDto;
      expect(dto.reason, 'Tres reportes de acoso verificados');
    });
  });

  group('catálogo y configuración', () {
    testWidgets(
      'cambiar la comisión avisa que solo afecta a lo que se asigne desde ahora',
      (tester) async {
        final api = FakeApi()
          ..on(#adminCategoriesControllerList, (_) async => ok([category()]))
          ..on(#adminCitiesControllerList, (_) async => ok(<AdminCityDto>[]))
          ..on(
            #adminCategoriesControllerUpdate,
            (_) async => ok(
              category(
                pct: '10.00',
                notice:
                    'La nueva comisión solo se aplica a los trabajos asignados desde ahora.',
              ),
            ),
          );
        await pumpAdmin(tester, api: api, location: '/catalogo/categorias');
        await tester.tap(find.byKey(const Key('category-plomeria')));
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('category-pct')), '10');
        await tester.pump();
        await tester.tap(find.byKey(const Key('category-next')));
        await tester.pumpAndSettle();
        expect(
          find.textContaining(
            'solo se aplica a los trabajos asignados desde ahora',
          ),
          findsOneWidget,
        );
        await confirmWithReason(tester, 'Promoción de lanzamiento');
        final dto =
            api
                    .callsTo(#adminCategoriesControllerUpdate)
                    .single[#updateCategoryDto]
                as UpdateCategoryDto;
        expect(dto.commissionPct, '10.00');
        expect(dto.reason, 'Promoción de lanzamiento');
        expect(
          find.text(
            'La nueva comisión solo se aplica a los trabajos asignados desde ahora.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'un parámetro se escribe en minutos y un valor fuera de rango muestra el error',
      (tester) async {
        final api = FakeApi()
          ..on(#adminSettingsControllerList, (_) async => ok([setting()]))
          ..on<Never>(
            #adminSettingsControllerSet,
            (_) => Future.error(
              apiError(
                400,
                'SETTING_OUT_OF_RANGE',
                'Fuera de rango: entre 15000 y 600000 (ms).',
              ),
            ),
          );
        await pumpAdmin(
          tester,
          api: api,
          location: '/configuracion/parametros',
        );
        expect(find.text('45 s'), findsOneWidget);
        await tester.tap(find.byTooltip('Cambiar'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byKey(const Key('setting-value')), '0,1');
        await tester.tap(find.byKey(const Key('setting-next')));
        await tester.pumpAndSettle();
        await confirmWithReason(tester, 'Prueba de rango');
        final dto =
            api.callsTo(#adminSettingsControllerSet).single[#setSettingDto]
                as SetSettingDto;
        expect(dto.value, '6000');
        expect(
          find.text('Fuera de rango: entre 15000 y 600000 (ms).'),
          findsOneWidget,
        );
      },
    );
  });
}
