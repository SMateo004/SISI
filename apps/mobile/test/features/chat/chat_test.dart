import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/realtime/realtime_client.dart';
import 'package:sisi_mobile/features/reports/data/reports_repository.dart';

import '../../helpers/fake_jobs.dart';
import '../../helpers/fake_realtime.dart';
import '../../helpers/fakes.dart';

Future<void> _openChat(
  WidgetTester tester, {
  required FakeChatRepository chat,
  FakeRealtimeClient? realtime,
  FakeReportsRepository? reports,
}) async {
  await pumpSisiApp(
    tester,
    storedTokens: testTokens,
    jobs: FakeJobsRepository(jobs: [testJob(myRole: 'employer')]),
    chat: chat,
    realtime: realtime,
    reports: reports,
  );
  await tester.tap(find.byKey(const Key('active-job')));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.byKey(const Key('open-chat')));
  await tester.tap(find.byKey(const Key('open-chat')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('muestra la conversación, envía y marca como leído', (
    tester,
  ) async {
    final chat = FakeChatRepository(
      messages: [testMessage(id: 'm1', body: 'Hola, llego en 10 minutos.')],
    );
    await _openChat(tester, chat: chat);
    expect(find.text('Hola, llego en 10 minutos.'), findsOneWidget);
    expect(chat.read, ['m1']);

    await tester.enterText(find.byKey(const Key('chat-input')), 'Te espero.');
    await tester.tap(find.byKey(const Key('chat-send')));
    await tester.pumpAndSettle();
    expect(find.text('Te espero.'), findsOneWidget);
    expect(find.textContaining('no cumple las normas'), findsNothing);
  });

  testWidgets('un mensaje retenido no se envía y se avisa en forma neutral', (
    tester,
  ) async {
    final chat = FakeChatRepository();
    await _openChat(tester, chat: chat);
    await tester.enterText(
      find.byKey(const Key('chat-input')),
      'Te consigo c.o.c.a barata',
    );
    await tester.tap(find.byKey(const Key('chat-send')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Tu mensaje no se envió porque no cumple las normas de uso de SISI.',
      ),
      findsOneWidget,
    );
    expect(find.text('No enviado: no cumple las normas'), findsOneWidget);
  });

  testWidgets('llega un mensaje en vivo con chat:message', (tester) async {
    final realtime = FakeRealtimeClient();
    final chat = FakeChatRepository();
    await _openChat(tester, chat: chat, realtime: realtime);
    chat.messages = [testMessage(id: 'm2', body: '¿Tienes la llave de paso?')];
    realtime.emit(RealtimeEvents.chatMessage, {
      'jobId': 'job-1',
      'messageId': 'm2',
    });
    await tester.pumpAndSettle();
    expect(find.text('¿Tienes la llave de paso?'), findsOneWidget);
  });

  testWidgets('cerrado: solo lectura', (tester) async {
    final chat = FakeChatRepository(
      open: false,
      messages: [testMessage(id: 'm1', body: 'Gracias por todo.')],
    );
    await _openChat(tester, chat: chat);
    expect(find.text('Gracias por todo.'), findsOneWidget);
    expect(find.byKey(const Key('chat-input')), findsNothing);
    expect(find.byKey(const Key('chat-closed')), findsOneWidget);
  });

  testWidgets('mantener presionado un mensaje recibido permite reportarlo', (
    tester,
  ) async {
    final reports = FakeReportsRepository();
    final chat = FakeChatRepository(
      messages: [testMessage(id: 'm1', body: 'Págame por fuera.')],
    );
    await _openChat(tester, chat: chat, reports: reports);
    await tester.longPress(find.byKey(const Key('msg-m1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-reason-fraude')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('report-send')));
    await tester.pumpAndSettle();
    expect(reports.created.single, (
      ReportTarget.chatMessage,
      'm1',
      ReportReason.fraude,
      null,
    ));
  });
}
