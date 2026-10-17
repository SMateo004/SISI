import 'package:sisi_mobile/core/http/api_exception.dart';
import 'package:sisi_mobile/features/chat/data/chat_repository.dart';
import 'package:sisi_mobile/features/chat/domain/chat_models.dart';
import 'package:sisi_mobile/features/jobs/data/jobs_repository.dart';
import 'package:sisi_mobile/features/jobs/domain/job_models.dart';
import 'package:sisi_mobile/features/notifications/data/notifications_repository.dart';
import 'package:sisi_mobile/features/reports/data/reports_repository.dart';
import 'package:sisi_mobile/features/reviews/data/reviews_repository.dart';

/// Trabajo de prueba (plomería, Bs 150) visto por una de las partes.
Job testJob({
  String id = 'job-1',
  JobStatus status = JobStatus.asignado,
  String myRole = 'worker',
  Set<JobAction>? actions,
  DateTime? workerFinishedAt,
  DateTime? disputedAt,
  String? commissionBs,
  String? netBs,
  JobCancellation? cancellation,
  JobReviews reviews = const JobReviews(),
}) => Job(
  id: id,
  requestId: 'r1',
  status: status,
  myRole: myRole,
  categorySlug: 'plomeria',
  categoryName: 'Plomería',
  description: 'Tengo una fuga debajo del lavaplatos de la cocina.',
  counterpartUserId: myRole == 'worker' ? 'employer-1' : 'worker-1',
  counterpartShortName: myRole == 'worker' ? 'Carla M.' : 'Ana R.',
  finalPriceBs: '150.00',
  commissionBs: commissionBs,
  netBs: netBs,
  timeline: JobTimeline(
    assignedAt: DateTime(2026, 10, 16, 10),
    workerFinishedAt: workerFinishedAt,
    disputedAt: disputedAt,
  ),
  cancellation: cancellation,
  reviews: reviews,
  allowedActions: actions ?? _defaultActions(status, myRole, workerFinishedAt),
);

/// Las acciones que daría la API (misma regla que el backend, ADR-0029).
Set<JobAction> _defaultActions(
  JobStatus status,
  String role,
  DateTime? finished,
) => switch ((status, role)) {
  (JobStatus.asignado, 'worker') => {JobAction.startTrip, JobAction.cancel},
  (JobStatus.asignado, _) => {JobAction.cancel},
  (JobStatus.enCamino, 'worker') => {JobAction.startWork, JobAction.cancel},
  (JobStatus.enCamino, _) => {JobAction.cancel},
  (JobStatus.enCurso, 'worker') => finished == null ? {JobAction.finish} : {},
  (JobStatus.enCurso, _) =>
    finished == null
        ? {JobAction.confirm}
        : {JobAction.confirm, JobAction.dispute},
  _ => {},
};

/// Repositorio de trabajos en memoria: aplica las acciones como lo haría la API.
class FakeJobsRepository implements JobsRepository {
  FakeJobsRepository({List<Job>? jobs, this.tracked}) : jobs = jobs ?? [];

  List<Job> jobs;
  TrackedPoint? tracked;
  final actions = <(String, JobAction)>[];
  final cancelled = <(String, CancelReason, String?)>[];
  final disputes = <(String, String?)>[];

  Job _find(String jobId) => jobs.firstWhere(
    (j) => j.id == jobId,
    orElse: () => throw const ApiException(
      code: 'JOB_NOT_FOUND',
      message: 'El trabajo no existe.',
      statusCode: 404,
    ),
  );

  Job _replace(Job next) {
    jobs = [for (final j in jobs) j.id == next.id ? next : j];
    return next;
  }

  @override
  Future<Job> get(String jobId) async => _find(jobId);

  @override
  Future<JobPage> list({required String role, String? cursor}) async =>
      JobPage(items: jobs.where((j) => j.myRole == role).toList());

  @override
  Future<Job> act(String jobId, JobAction action) async {
    final job = _find(jobId);
    if (!job.can(action)) {
      throw const ApiException(
        code: 'JOB_TRANSITION_NOT_ALLOWED',
        message: 'Solo puedes marcar terminado un trabajo en curso.',
        statusCode: 409,
      );
    }
    actions.add((jobId, action));
    return _replace(switch (action) {
      JobAction.startTrip => testJob(
        id: jobId,
        myRole: job.myRole,
        status: JobStatus.enCamino,
      ),
      JobAction.startWork => testJob(
        id: jobId,
        myRole: job.myRole,
        status: JobStatus.enCurso,
      ),
      JobAction.finish => testJob(
        id: jobId,
        myRole: job.myRole,
        status: JobStatus.enCurso,
        workerFinishedAt: DateTime(2026, 10, 16, 12),
      ),
      JobAction.confirm => testJob(
        id: jobId,
        myRole: job.myRole,
        status: JobStatus.terminado,
        commissionBs: job.myRole == 'worker' ? '19.50' : null,
        netBs: job.myRole == 'worker' ? '130.50' : null,
        reviews: const JobReviews(canReview: true),
      ),
      _ => job,
    });
  }

  @override
  Future<Job> dispute(String jobId, {String? note}) async {
    disputes.add((jobId, note));
    final job = _find(jobId);
    return _replace(
      testJob(
        id: jobId,
        myRole: job.myRole,
        status: JobStatus.enCurso,
        workerFinishedAt: job.timeline.workerFinishedAt,
        disputedAt: DateTime(2026, 10, 16, 13),
        actions: const {},
      ),
    );
  }

  @override
  Future<Job> cancel(String jobId, CancelReason reason, {String? note}) async {
    cancelled.add((jobId, reason, note));
    final job = _find(jobId);
    return _replace(
      testJob(
        id: jobId,
        myRole: job.myRole,
        status: JobStatus.cancelado,
        cancellation: JobCancellation(
          by: job.myRole,
          reason: reason,
          note: note,
        ),
      ),
    );
  }

  @override
  Future<TrackedPoint?> location(String jobId) async => tracked;
}

ChatMessage testMessage({
  required String id,
  required String body,
  bool mine = false,
  bool held = false,
  DateTime? at,
}) => ChatMessage(
  id: id,
  senderId: mine ? 'u1' : 'other',
  mine: mine,
  body: body,
  held: held,
  createdAt: at ?? DateTime(2026, 10, 16, 10),
);

/// Chat en memoria. Un mensaje con "c.o.c.a" queda retenido, como con la moderación.
class FakeChatRepository implements ChatRepository {
  FakeChatRepository({List<ChatMessage>? messages, this.open = true})
    : messages = messages ?? [];

  /// Del más reciente al más antiguo.
  List<ChatMessage> messages;
  bool open;
  final read = <String>[];
  var _seq = 0;

  @override
  Future<ChatPage> list(String jobId, {String? cursor}) async =>
      ChatPage(items: List.of(messages), open: open);

  @override
  Future<SentMessage> send(String jobId, String body) async {
    if (!open) {
      throw const ApiException(
        code: 'CHAT_CLOSED',
        message: 'El chat de este trabajo ya se cerró.',
        statusCode: 409,
      );
    }
    final held = body.contains('c.o.c.a');
    final message = testMessage(
      id: 'sent-${_seq++}',
      body: body,
      mine: true,
      held: held,
      at: DateTime(2026, 10, 16, 11, _seq),
    );
    messages = [message, ...messages];
    return SentMessage(
      message: message,
      notice: held
          ? 'Tu mensaje no se envió porque no cumple las normas de uso de SISI.'
          : null,
    );
  }

  @override
  Future<void> markRead(String jobId, String upToId) async => read.add(upToId);
}

class FakeReviewsRepository implements ReviewsRepository {
  final submitted = <(String, int, String?)>[];

  @override
  Future<JobReviews> submit(String jobId, int stars, {String? comment}) async {
    submitted.add((jobId, stars, comment));
    return JobReviews(
      mine: MyReview(stars: stars, comment: comment),
    );
  }
}

class FakeReportsRepository implements ReportsRepository {
  final created = <(ReportTarget, String, ReportReason, String?)>[];

  @override
  Future<void> create(
    ReportTarget target,
    String targetId,
    ReportReason reason, {
    String? note,
  }) async => created.add((target, targetId, reason, note));
}

AppNotification testNotification({
  required String id,
  String title = 'Ana R. va en camino',
  String route = '/trabajos/job-1',
  bool read = false,
}) => AppNotification(
  id: id,
  title: title,
  body: 'Puedes seguir su ubicación en el mapa.',
  route: route,
  createdAt: DateTime(2026, 10, 16, 10),
  readAt: read ? DateTime(2026, 10, 16, 11) : null,
);

class FakeNotificationsRepository implements NotificationsRepository {
  FakeNotificationsRepository({List<AppNotification>? items})
    : items = items ?? [];

  List<AppNotification> items;
  final markedRead = <String>[];
  int readAllCalls = 0;

  AppNotification _read(AppNotification n) =>
      testNotification(id: n.id, title: n.title, route: n.route, read: true);

  @override
  Future<NotificationPage> list({String? cursor}) async =>
      NotificationPage(items: List.of(items));

  @override
  Future<int> unreadCount() async => items.where((n) => n.unread).length;

  @override
  Future<void> markRead(String id) async {
    markedRead.add(id);
    items = [for (final n in items) n.id == id ? _read(n) : n];
  }

  @override
  Future<void> readAll() async {
    readAllCalls++;
    items = [for (final n in items) _read(n)];
  }
}
