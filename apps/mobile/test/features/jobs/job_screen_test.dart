import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_mobile/core/maps/geo_point.dart';
import 'package:sisi_mobile/core/realtime/realtime_client.dart';
import 'package:sisi_mobile/features/jobs/domain/job_models.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';

import '../../helpers/fake_jobs.dart';
import '../../helpers/fake_realtime.dart';
import '../../helpers/fakes.dart';

/// Abre el trabajo desde "Mis trabajos" en el inicio.
Future<void> _openJob(
  WidgetTester tester, {
  required Job job,
  FakeJobsRepository? jobs,
  FakeRealtimeClient? realtime,
  FakeReviewsRepository? reviews,
  FakeReportsRepository? reports,
  List<Uri>? openedUrls,
}) async {
  await pumpSisiApp(
    tester,
    storedTokens: testTokens,
    me: FakeMeRepository(
      user: testUser(
        mode: job.iAmWorker ? ActiveMode.worker : ActiveMode.employer,
      ),
    ),
    jobs: jobs ?? FakeJobsRepository(jobs: [job]),
    realtime: realtime,
    reviews: reviews,
    reports: reports,
    openedUrls: openedUrls,
  );
  await tester.ensureVisible(find.byKey(const Key('my-jobs')));
  await tester.tap(find.byKey(const Key('my-jobs')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(Key('job-${job.id}')));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

/// Vuelve arriba de la pantalla del trabajo (la lista se construye de a partes).
Future<void> _top(WidgetTester tester) async {
  await tester.fling(find.byType(ListView).first, const Offset(0, 3000), 3000);
  await tester.pumpAndSettle();
}

Future<String> _status(WidgetTester tester) async {
  await _top(tester);
  return ((tester.widget<Chip>(find.byKey(const Key('job-status'))).label)
          as Text)
      .data!;
}

void main() {
  group('Trabajador', () {
    testWidgets('avanza el trabajo: en camino → en curso → terminé', (
      tester,
    ) async {
      final jobs = FakeJobsRepository(jobs: [testJob()]);
      await _openJob(tester, job: testJob(), jobs: jobs);

      expect(await _status(tester), 'Asignado');
      // "Terminé" solo existe con el trabajo en curso.
      expect(find.byKey(const Key('action-finish')), findsNothing);
      expect(find.byKey(const Key('action-confirm')), findsNothing);

      await _tap(tester, 'action-on-the-way');
      expect(await _status(tester), 'En camino');
      expect(find.byKey(const Key('action-finish')), findsNothing);

      await _tap(tester, 'action-start');
      expect(await _status(tester), 'En curso');
      // En curso ya no se cancela.
      expect(find.byKey(const Key('action-cancel')), findsNothing);

      await _tap(tester, 'action-finish');
      await _top(tester);
      expect(find.byKey(const Key('job-finished')), findsOneWidget);
      expect(find.textContaining('Esperamos la confirmación'), findsOneWidget);
      expect(jobs.actions.map((a) => a.$2), [
        JobAction.startTrip,
        JobAction.startWork,
        JobAction.finish,
      ]);
    });

    testWidgets('contacto: llamar y WhatsApp con los enlaces de la API', (
      tester,
    ) async {
      final opened = <Uri>[];
      await _openJob(tester, job: testJob(), openedUrls: opened);
      await _tap(tester, 'contact-call');
      await _tap(tester, 'contact-whatsapp');
      expect(opened.map((u) => u.toString()), [
        'tel:+59171234567',
        'https://wa.me/59171234567',
      ]);
    });

    testWidgets('terminado: ve el precio, la comisión y lo que recibe (R8.3)', (
      tester,
    ) async {
      final job = testJob(
        status: JobStatus.terminado,
        commissionBs: '19.50',
        netBs: '130.50',
      );
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        me: FakeMeRepository(user: testUser(mode: ActiveMode.worker)),
        jobs: FakeJobsRepository(jobs: [job]),
      );
      await _tap(tester, 'my-jobs');
      expect(
        find.textContaining('Comisión Bs 19,50 · Recibes Bs 130,50'),
        findsOneWidget,
      );
      await _tap(tester, 'job-job-1');
      await tester.ensureVisible(find.byKey(const Key('job-money')));
      expect(find.text('− Bs 19,50'), findsOneWidget);
      expect(find.text('Bs 130,50'), findsOneWidget);
    });

    testWidgets('se actualiza con job:status del trabajo', (tester) async {
      final realtime = FakeRealtimeClient();
      final jobs = FakeJobsRepository(jobs: [testJob()]);
      await _openJob(tester, job: testJob(), jobs: jobs, realtime: realtime);
      jobs.jobs = [testJob(status: JobStatus.cancelado)];
      realtime.emit(RealtimeEvents.jobStatus, {
        'jobId': 'job-1',
        'status': 'cancelado',
        'action': 'CANCEL',
      });
      await tester.pumpAndSettle();
      expect(await _status(tester), 'Cancelado');
    });
  });

  group('Empleador', () {
    testWidgets('en camino: mapa en vivo con job:location', (tester) async {
      final realtime = FakeRealtimeClient();
      final job = testJob(myRole: 'employer', status: JobStatus.enCamino);
      final jobs = FakeJobsRepository(
        jobs: [job],
        tracked: TrackedPoint(
          position: const GeoPoint(-17.78, -63.18),
          at: DateTime(2026, 10, 16, 10, 5),
        ),
      );
      await _openJob(tester, job: job, jobs: jobs, realtime: realtime);

      expect(find.byKey(const Key('live-map')), findsOneWidget);
      expect(find.textContaining('-17.78000, -63.18000'), findsOneWidget);
      realtime.emit(RealtimeEvents.jobLocation, {
        'jobId': 'job-1',
        'latitude': -17.79,
        'longitude': -63.19,
        'at': '2026-10-16T14:06:00.000Z',
      });
      await tester.pumpAndSettle();
      expect(find.textContaining('-17.79000, -63.19000'), findsOneWidget);
      // De otro trabajo no mueve el mapa.
      realtime.emit(RealtimeEvents.jobLocation, {
        'jobId': 'otro',
        'latitude': -17.5,
        'longitude': -63.5,
        'at': '2026-10-16T14:07:00.000Z',
      });
      await tester.pumpAndSettle();
      expect(find.textContaining('-17.79000, -63.19000'), findsOneWidget);
    });

    testWidgets('confirma el término y califica', (tester) async {
      final reviews = FakeReviewsRepository();
      final job = testJob(
        myRole: 'employer',
        status: JobStatus.enCurso,
        workerFinishedAt: DateTime(2026, 10, 16, 12),
      );
      await _openJob(tester, job: job, reviews: reviews);
      await _top(tester);
      expect(find.byKey(const Key('job-finished')), findsOneWidget);
      expect(find.byKey(const Key('action-dispute')), findsOneWidget);

      await _tap(tester, 'action-confirm');
      await tester.tap(find.byKey(const Key('dialog-yes')));
      await tester.pumpAndSettle();
      expect(await _status(tester), 'Terminado');

      await _tap(tester, 'review-open');
      expect(find.byKey(const Key('review-send')), findsOneWidget);
      await tester.tap(find.byKey(const Key('star-4')));
      await tester.enterText(
        find.byKey(const Key('review-comment')),
        'Muy puntual.',
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('review-send')));
      await tester.pumpAndSettle();
      expect(reviews.submitted.single, ('job-1', 4, 'Muy puntual.'));
    });

    testWidgets('"Hubo un problema" queda en revisión', (tester) async {
      final jobs = FakeJobsRepository(
        jobs: [
          testJob(
            myRole: 'employer',
            status: JobStatus.enCurso,
            workerFinishedAt: DateTime(2026, 10, 16, 12),
          ),
        ],
      );
      await _openJob(tester, job: jobs.jobs.single, jobs: jobs);
      await _tap(tester, 'action-dispute');
      await tester.enterText(
        find.byKey(const Key('dispute-note')),
        'Quedó goteando.',
      );
      await tester.tap(find.byKey(const Key('dispute-send')));
      await tester.pumpAndSettle();
      expect(jobs.disputes.single, ('job-1', 'Quedó goteando.'));
      await _top(tester);
      expect(find.byKey(const Key('job-disputed')), findsOneWidget);
      expect(find.byKey(const Key('action-confirm')), findsNothing);
    });

    testWidgets('cancela con motivo y puede volver a publicar', (tester) async {
      final jobs = FakeJobsRepository(
        jobs: [testJob(myRole: 'employer', status: JobStatus.enCamino)],
      );
      await pumpSisiApp(
        tester,
        storedTokens: testTokens,
        jobs: jobs,
        requests: FakeRequestsRepository(mine: [testRequest()]),
      );
      await _tap(tester, 'my-jobs');
      await _tap(tester, 'job-job-1');

      await _tap(tester, 'action-cancel');
      // Sin motivo no se puede confirmar.
      final confirm = tester.widget<FilledButton>(
        find.byKey(const Key('cancel-confirm')),
      );
      expect(confirm.onPressed, isNull);
      await tester.tap(
        find.byKey(const Key('cancel-reason-no_llega_o_no_responde')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const Key('cancel-confirm')));
      await tester.pumpAndSettle();

      expect(jobs.cancelled.single.$2, CancelReason.noLlega);
      await _top(tester);
      expect(find.byKey(const Key('job-cancelled')), findsOneWidget);
      expect(find.textContaining('No llega o no responde'), findsOneWidget);

      await _tap(tester, 'job-republish');
      // Precarga de la Fase 3: abre el formulario con los datos de la solicitud.
      expect(find.text('Pedir un servicio'), findsOneWidget);
      await tester.tap(find.byKey(const Key('request-next')));
      await tester.pumpAndSettle();
      final field = tester.widget<TextField>(
        find.byKey(const Key('description-field')),
      );
      expect(field.controller?.text, startsWith('Tengo una fuga'));
    });

    testWidgets('reporta un problema con el trabajo', (tester) async {
      final reports = FakeReportsRepository();
      await _openJob(
        tester,
        job: testJob(myRole: 'employer'),
        reports: reports,
      );
      await tester.tap(find.byKey(const Key('job-menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reportar a Ana R.'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('report-reason-acoso')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('report-send')));
      await tester.pumpAndSettle();
      expect(reports.created.single.$2, 'worker-1');
      expect(find.textContaining('Revisaremos tu reporte'), findsOneWidget);
    });
  });

  testWidgets('el trabajo activo aparece en el inicio al ser elegido', (
    tester,
  ) async {
    final realtime = FakeRealtimeClient();
    final jobs = FakeJobsRepository();
    await pumpSisiApp(
      tester,
      storedTokens: testTokens,
      me: FakeMeRepository(user: testUser(mode: ActiveMode.worker)),
      jobs: jobs,
      realtime: realtime,
    );
    expect(find.byKey(const Key('active-job')), findsNothing);
    jobs.jobs = [testJob()];
    realtime.emit(RealtimeEvents.requestAssigned, {
      'requestId': 'r1',
      'jobId': 'job-1',
    });
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('active-job')), findsOneWidget);
  });
}
