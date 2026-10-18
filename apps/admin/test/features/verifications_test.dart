import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_api/sisi_api.dart';

import '../helpers/fakes.dart';
import '../helpers/fixtures.dart';

void main() {
  group('verificaciones', () {
    FakeApi api0() => FakeApi()
      ..on(
        #verificationsControllerQueue,
        (_) async => ok(
          VerificationPageDto(items: [verificationRow()], nextCursor: null),
        ),
      )
      ..on(
        #verificationsControllerDetail,
        (_) async => ok(verificationDetail()),
      );

    testWidgets(
      'la cola abre el detalle con edad, requisitos extra y documentos',
      (tester) async {
        await pumpAdmin(tester, api: api0(), location: '/verificaciones');
        expect(find.text('Rosa Quispe'), findsOneWidget);
        await tester.tap(find.text('Rosa Quispe'));
        await tester.pumpAndSettle();
        expect(find.text('15/01/2000 (26 años)'), findsOneWidget);
        expect(find.textContaining('certificado electricista'), findsOneWidget);
        expect(find.byKey(const Key('doc-ci_front')), findsOneWidget);
      },
    );

    testWidgets('aprobar pide una nota y llama a la API', (tester) async {
      final api = api0()
        ..on(
          #verificationsControllerApprove,
          (_) async => ok(verificationResult('aprobado')),
        );
      await pumpAdmin(tester, api: api, location: '/verificaciones/w1');
      await tester.tap(find.byKey(const Key('verification-approve')));
      await tester.pumpAndSettle();
      await confirmWithReason(tester, 'Documentos claros');
      final call = api.callsTo(#verificationsControllerApprove).single;
      expect(call[#userId], 'w1');
      expect(
        (call[#approveVerificationDto] as ApproveVerificationDto).note,
        'Documentos claros',
      );
      expect(find.text('Trabajador aprobado.'), findsOneWidget);
    });

    testWidgets('rechazar exige un motivo de la lista y una nota', (
      tester,
    ) async {
      final api = api0()
        ..on(
          #verificationsControllerReject,
          (_) async => ok(verificationResult('rechazado')),
        );
      await pumpAdmin(tester, api: api, location: '/verificaciones/w1');
      await tester.tap(find.byKey(const Key('verification-reject')));
      await tester.pumpAndSettle();
      await confirmWithReason(
        tester,
        'La foto del reverso está movida',
        reasonLabel: 'Documento ilegible',
      );
      final dto =
          api
                  .callsTo(#verificationsControllerReject)
                  .single[#rejectVerificationDto]
              as RejectVerificationDto;
      expect(dto.reason.value, 'documento_ilegible');
      expect(dto.note, 'La foto del reverso está movida');
    });

    testWidgets('autorrevisión: el error de la API se muestra en el diálogo', (
      tester,
    ) async {
      final api = api0()
        ..on<Never>(
          #verificationsControllerApprove,
          (_) => Future.error(
            apiError(
              403,
              'SELF_REVIEW_FORBIDDEN',
              'No puedes revisar tu propia solicitud de trabajador.',
            ),
          ),
        );
      await pumpAdmin(tester, api: api, location: '/verificaciones/w1');
      await tester.tap(find.byKey(const Key('verification-approve')));
      await tester.pumpAndSettle();
      await confirmWithReason(tester, 'Documentos claros');
      expect(
        find.text('No puedes revisar tu propia solicitud de trabajador.'),
        findsOneWidget,
      );
    });
  });
}
