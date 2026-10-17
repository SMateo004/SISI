/// Modelos del trabajo (R6, ADR-0029). Montos como texto "150.00" (formato de la API).
library;

import '../../../core/maps/geo_point.dart';

enum JobStatus {
  asignado('Asignado'),
  enCamino('En camino'),
  enCurso('En curso'),
  terminado('Terminado'),
  cancelado('Cancelado');

  const JobStatus(this.label);

  final String label;

  static JobStatus parse(String value) => switch (value) {
    'en_camino' => JobStatus.enCamino,
    'en_curso' => JobStatus.enCurso,
    'terminado' => JobStatus.terminado,
    'cancelado' => JobStatus.cancelado,
    _ => JobStatus.asignado,
  };

  bool get isActive => this == asignado || this == enCamino || this == enCurso;
}

/// Acciones que la API permite en este momento (`allowedActions`).
enum JobAction {
  startTrip('START_TRIP'),
  startWork('START_WORK'),
  finish('FINISH'),
  confirm('CONFIRM'),
  dispute('DISPUTE'),
  cancel('CANCEL');

  const JobAction(this.api);

  final String api;

  static JobAction? parse(String value) {
    for (final a in values) {
      if (a.api == value) return a;
    }
    return null;
  }
}

/// Motivos de cancelación (lista cerrada de la API).
enum CancelReason {
  cambioDePlanes('cambio_de_planes', 'Cambio de planes'),
  noLlega('no_llega_o_no_responde', 'No llega o no responde'),
  precio('desacuerdo_de_precio', 'Desacuerdo con el precio'),
  emergencia('emergencia', 'Emergencia'),
  otro('otro', 'Otro motivo');

  const CancelReason(this.api, this.label);

  final String api;
  final String label;

  static CancelReason parse(String? value) =>
      values.firstWhere((r) => r.api == value, orElse: () => CancelReason.otro);
}

class JobTimeline {
  const JobTimeline({
    required this.assignedAt,
    this.onTheWayAt,
    this.startedAt,
    this.workerFinishedAt,
    this.disputedAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory JobTimeline.fromJson(Map<String, dynamic> json) {
    DateTime? at(String key) {
      final v = json[key];
      return v is String ? DateTime.parse(v).toLocal() : null;
    }

    return JobTimeline(
      assignedAt: at('assignedAt') ?? DateTime.now(),
      onTheWayAt: at('onTheWayAt'),
      startedAt: at('startedAt'),
      workerFinishedAt: at('workerFinishedAt'),
      disputedAt: at('disputedAt'),
      completedAt: at('completedAt'),
      cancelledAt: at('cancelledAt'),
    );
  }

  final DateTime assignedAt;
  final DateTime? onTheWayAt;
  final DateTime? startedAt;
  final DateTime? workerFinishedAt;
  final DateTime? disputedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
}

class JobCancellation {
  const JobCancellation({
    required this.by,
    required this.reason,
    this.note,
    this.noteHeld = false,
  });

  factory JobCancellation.fromJson(Map<String, dynamic> json) =>
      JobCancellation(
        by: json['by'] as String,
        reason: CancelReason.parse(json['reason'] as String?),
        note: json['note'] as String?,
        noteHeld: json['noteHeld'] as bool? ?? false,
      );

  /// worker, employer o admin.
  final String by;
  final CancelReason reason;
  final String? note;
  final bool noteHeld;
}

class MyReview {
  const MyReview({
    required this.stars,
    this.comment,
    this.commentHeld = false,
    this.published = false,
  });

  factory MyReview.fromJson(Map<String, dynamic> json) => MyReview(
    stars: json['stars'] as int,
    comment: json['comment'] as String?,
    commentHeld: json['commentHeld'] as bool? ?? false,
    published: json['published'] as bool? ?? false,
  );

  final int stars;
  final String? comment;
  final bool commentHeld;
  final bool published;
}

class ReceivedReview {
  const ReceivedReview({required this.stars, this.comment});

  factory ReceivedReview.fromJson(Map<String, dynamic> json) => ReceivedReview(
    stars: json['stars'] as int,
    comment: json['comment'] as String?,
  );

  final int stars;
  final String? comment;
}

/// Calificaciones del trabajo (ADR-0032): la de la contraparte, solo cuando se publica.
class JobReviews {
  const JobReviews({
    this.canReview = false,
    this.deadline,
    this.mine,
    this.theirs,
  });

  factory JobReviews.fromJson(Map<String, dynamic> json) {
    final mine = json['mine'];
    final theirs = json['theirs'];
    final deadline = json['deadline'];
    return JobReviews(
      canReview: json['canReview'] as bool? ?? false,
      deadline: deadline is String ? DateTime.parse(deadline).toLocal() : null,
      mine: mine is Map
          ? MyReview.fromJson(mine.cast<String, dynamic>())
          : null,
      theirs: theirs is Map
          ? ReceivedReview.fromJson(theirs.cast<String, dynamic>())
          : null,
    );
  }

  final bool canReview;
  final DateTime? deadline;
  final MyReview? mine;
  final ReceivedReview? theirs;
}

class Job {
  const Job({
    required this.id,
    required this.requestId,
    required this.status,
    required this.myRole,
    required this.categorySlug,
    required this.categoryName,
    required this.description,
    required this.counterpartUserId,
    required this.counterpartShortName,
    required this.finalPriceBs,
    required this.timeline,
    this.commissionBs,
    this.netBs,
    this.autoConfirmed = false,
    this.autoConfirmAt,
    this.cancellation,
    this.reviews = const JobReviews(),
    this.allowedActions = const {},
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    final category = (json['category'] as Map).cast<String, dynamic>();
    final counterpart = (json['counterpart'] as Map).cast<String, dynamic>();
    final cancellation = json['cancellation'];
    final reviews = json['reviews'];
    final autoConfirmAt = json['autoConfirmAt'];
    return Job(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      status: JobStatus.parse(json['status'] as String),
      myRole: json['myRole'] as String,
      categorySlug: category['slug'] as String,
      categoryName: category['name'] as String,
      description: json['description'] as String,
      counterpartUserId: counterpart['userId'] as String,
      counterpartShortName: counterpart['shortName'] as String,
      finalPriceBs: json['finalPriceBs'] as String,
      commissionBs: json['commissionBs'] as String?,
      netBs: json['netBs'] as String?,
      timeline: JobTimeline.fromJson(
        (json['timeline'] as Map).cast<String, dynamic>(),
      ),
      autoConfirmed: json['autoConfirmed'] as bool? ?? false,
      autoConfirmAt: autoConfirmAt is String
          ? DateTime.parse(autoConfirmAt).toLocal()
          : null,
      cancellation: cancellation is Map
          ? JobCancellation.fromJson(cancellation.cast<String, dynamic>())
          : null,
      reviews: reviews is Map
          ? JobReviews.fromJson(reviews.cast<String, dynamic>())
          : const JobReviews(),
      allowedActions: {
        for (final a in (json['allowedActions'] as List? ?? const []))
          ?JobAction.parse(a as String),
      },
    );
  }

  final String id;
  final String requestId;
  final JobStatus status;

  /// worker o employer: mi rol en este trabajo.
  final String myRole;
  final String categorySlug;
  final String categoryName;
  final String description;
  final String counterpartUserId;
  final String counterpartShortName;
  final String finalPriceBs;

  /// Solo para el trabajador y con el trabajo terminado (R8.3).
  final String? commissionBs;
  final String? netBs;
  final JobTimeline timeline;
  final bool autoConfirmed;
  final DateTime? autoConfirmAt;
  final JobCancellation? cancellation;
  final JobReviews reviews;
  final Set<JobAction> allowedActions;

  bool get iAmWorker => myRole == 'worker';
  bool get disputed => timeline.disputedAt != null;
  bool get workerFinished => timeline.workerFinishedAt != null;
  bool can(JobAction action) => allowedActions.contains(action);
}

class JobPage {
  const JobPage({required this.items, this.nextCursor});

  final List<Job> items;
  final String? nextCursor;
}

/// Último punto del trabajador en camino.
class TrackedPoint {
  const TrackedPoint({required this.position, required this.at});

  factory TrackedPoint.fromJson(Map<String, dynamic> json) => TrackedPoint(
    position: GeoPoint(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    ),
    at: DateTime.parse(json['at'] as String).toLocal(),
  );

  final GeoPoint position;
  final DateTime at;
}
