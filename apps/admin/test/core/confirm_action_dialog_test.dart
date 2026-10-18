import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_admin/core/widgets/confirm_action_dialog.dart';

import '../helpers/fakes.dart';

Future<void> _open(
  WidgetTester tester,
  Future<String> Function(ConfirmInput input) onConfirm, {
  List<(String, String)>? reasons,
  void Function(String? result)? onResult,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              final result = await confirmAction<String>(
                context,
                title: 'Rechazar',
                message: 'Seguro?',
                confirmLabel: 'Rechazar',
                reasons: reasons,
                onConfirm: onConfirm,
              );
              onResult?.call(result);
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
}

FilledButton _submit(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(const Key('confirm-submit')));

void main() {
  testWidgets('el motivo es obligatorio (al menos 5 letras)', (tester) async {
    await _open(tester, (_) async => 'ok');
    expect(_submit(tester).onPressed, isNull);
    await tester.enterText(find.byKey(const Key('confirm-note')), 'abc');
    await tester.pump();
    expect(_submit(tester).onPressed, isNull);
    await tester.enterText(
      find.byKey(const Key('confirm-note')),
      'Motivo válido',
    );
    await tester.pump();
    expect(_submit(tester).onPressed, isNotNull);
  });

  testWidgets('con lista cerrada, también hay que elegir el motivo', (
    tester,
  ) async {
    ConfirmInput? received;
    await _open(
      tester,
      (input) async {
        received = input;
        return 'ok';
      },
      reasons: const [
        ('documento_ilegible', 'Documento ilegible'),
        ('otro', 'Otro'),
      ],
    );
    await tester.enterText(
      find.byKey(const Key('confirm-note')),
      'La foto está movida',
    );
    await tester.pump();
    expect(_submit(tester).onPressed, isNull);
    await confirmWithReason(
      tester,
      'La foto está movida',
      reasonLabel: 'Documento ilegible',
    );
    expect(received?.reasonCode, 'documento_ilegible');
    expect(received?.note, 'La foto está movida');
    expect(find.byKey(const Key('confirm-dialog')), findsNothing);
  });

  testWidgets(
    'un error de la API se muestra sin cerrar; el reintento usa los mismos datos',
    (tester) async {
      var attempts = 0;
      String? result;
      await _open(tester, (input) async {
        attempts++;
        if (attempts == 1) {
          throw apiError(
            403,
            'SELF_REVIEW_FORBIDDEN',
            'No puedes hacer esta acción sobre tu propia cuenta.',
          );
        }
        return 'listo:${input.note}';
      }, onResult: (r) => result = r);
      await confirmWithReason(tester, 'Primer intento');
      expect(find.byKey(const Key('confirm-error')), findsOneWidget);
      expect(
        find.text('No puedes hacer esta acción sobre tu propia cuenta.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('confirm-dialog')), findsOneWidget);

      await tester.tap(find.byKey(const Key('confirm-submit')));
      await tester.pumpAndSettle();
      expect(attempts, 2);
      expect(result, 'listo:Primer intento');
    },
  );

  testWidgets('mientras envía, el botón queda deshabilitado', (tester) async {
    await _open(
      tester,
      (_) => Future.delayed(const Duration(seconds: 1), () => 'ok'),
    );
    await tester.enterText(
      find.byKey(const Key('confirm-note')),
      'Motivo válido',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('confirm-submit')));
    await tester.pump();
    expect(_submit(tester).onPressed, isNull);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
