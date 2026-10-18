import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  group('moderación', () {
    testWidgets('una retenida muestra los términos y se libera con motivo', (
      tester,
    ) async {
      final api = FakeApi()
        ..on(
          #adminRequestsControllerList,
          (_) async =>
              ok(AdminRequestPageDto(items: [heldRequest()], nextCursor: null)),
        )
        ..on(
          #adminRequestsControllerRelease,
          (_) async => ok(requestDto('r1', RequestDtoStatusEnum.buscando)),
        );
      await pumpAdmin(tester, api: api, location: '/moderacion/retenidas');
      expect(find.text('marihuan* (drogas)'), findsOneWidget);
      await tester.tap(find.byKey(const Key('release-r1')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Coincidió con: marihuan* (drogas)'),
        findsOneWidget,
      );
      await confirmWithReason(tester, 'El resto del pedido es válido');
      final dto =
          api
                  .callsTo(#adminRequestsControllerRelease)
                  .single[#moderationDecisionDto]
              as ModerationDecisionDto;
      expect(dto.reason, 'El resto del pedido es válido');
      expect(find.text('Solicitud liberada.'), findsOneWidget);
    });

    testWidgets('un reporte válido que suspende lo avisa', (tester) async {
      final api = FakeApi()
        ..on(
          #adminReportsControllerList,
          (_) async =>
              ok(AdminReportPageDto(items: [report()], nextCursor: null)),
        )
        ..on(
          #adminReportsControllerResolve,
          (_) async => ok(
            ResolveReportResultDto(
              report: report(status: 'valido', validReporters: 3),
              outcome: ResolveReportResultDtoOutcomeEnum.values.firstWhere(
                (e) => e.value == 'suspend',
              ),
            ),
          ),
        );
      await pumpAdmin(tester, api: api, location: '/moderacion/reportes');
      expect(find.text('Perfil de Juan'), findsOneWidget);
      expect(find.text('Juan · 2 válidos'), findsOneWidget);
      await tester.tap(find.byKey(const Key('report-valid-rep1')));
      await tester.pumpAndSettle();
      await confirmWithReason(tester, 'Se verificó con el chat');
      final dto =
          api.callsTo(#adminReportsControllerResolve).single[#resolveReportDto]
              as ResolveReportDto;
      expect(dto.valid, isTrue);
      expect(
        find.text('Reporte resuelto. El trabajador quedó suspendido.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'la disputa muestra la línea de tiempo, el chat retenido y el historial de ofertas',
      (tester) async {
        final api = FakeApi()
          ..on(#adminJobsControllerDetail, (_) async => ok(jobDetail()))
          ..on(
            #adminJobsControllerDisputed,
            (_) async => ok(<AdminDisputedJobDto>[]),
          )
          ..on(
            #adminJobsControllerResolve,
            (_) async =>
                ok(AdminJobsControllerResolve200Response(status: 'terminado')),
          );
        await pumpAdmin(tester, api: api, location: '/moderacion/disputas/j1');
        expect(find.byKey(const Key('timeline-DISPUTE')), findsOneWidget);
        expect(find.text('Te consigo c.o.c.a.i.n.a'), findsOneWidget);
        expect(find.text('retenido'), findsOneWidget);
        expect(find.textContaining('creada · Bs 200,00'), findsOneWidget);
        expect(find.textContaining('reemplazada · Bs 170,00'), findsOneWidget);

        await tester.tap(find.byKey(const Key('dispute-confirm')));
        await tester.pumpAndSettle();
        await confirmWithReason(
          tester,
          'Las fotos muestran el trabajo terminado',
        );
        final dto =
            api.callsTo(#adminJobsControllerResolve).single[#resolveDisputeDto]
                as ResolveDisputeDto;
        expect(dto.decision, ResolveDisputeDtoDecisionEnum.confirm);
      },
    );
  });
}
