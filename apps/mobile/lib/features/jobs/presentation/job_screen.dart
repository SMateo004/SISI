import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/maps/tracking_map_view.dart';
import '../../../core/router/routes.dart';
import '../../../shared/categories/category.dart';
import '../../../shared/dates.dart';
import '../../../shared/money.dart';
import '../../matching/data/availability_repository.dart';
import '../../matching/data/location_service.dart';
import '../../reports/data/reports_repository.dart';
import '../../reports/presentation/report_sheet.dart';
import '../../requests/data/requests_repository.dart';
import '../../requests/domain/service_request.dart';
import '../../reviews/data/reviews_repository.dart';
import '../../reviews/presentation/review_sheet.dart';
import '../application/job_providers.dart';
import '../data/jobs_repository.dart';
import '../domain/job_models.dart';
import 'cancel_job_dialog.dart';
import 'job_contact_card.dart';

/// Trabajo activo para las dos partes (R6): estado, línea de tiempo, acciones según el
/// rol, mapa en vivo mientras el trabajador va en camino, contacto, chat, cancelación,
/// calificación y reporte.
class JobScreen extends ConsumerStatefulWidget {
  const JobScreen({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends ConsumerState<JobScreen> {
  bool _busy = false;
  Timer? _trip;

  @override
  void initState() {
    super.initState();
    ref.listenManual(jobProvider(widget.jobId), (_, next) {
      final value = next.value;
      if (value != null) _syncTrip(value);
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _trip?.cancel();
    super.dispose();
  }

  /// El trabajador en camino envía su ubicación mientras la pantalla está abierta
  /// (primer plano, ADR-0024). Se corta al empezar o cancelar.
  void _syncTrip(Job job) {
    final every = ref.read(tripLocationIntervalProvider);
    final sending = job.iAmWorker && job.status == JobStatus.enCamino;
    if (!sending || every == null) {
      _trip?.cancel();
      _trip = null;
      return;
    }
    if (_trip != null) return;
    unawaited(_sendLocation());
    _trip = Timer.periodic(every, (_) => _sendLocation());
  }

  Future<void> _sendLocation() async {
    try {
      final at = await ref.read(locationServiceProvider).current();
      await ref.read(availabilityRepositoryProvider).sendLocation(at);
    } on Object {
      // Sin ubicación esta vez: se reintenta en el próximo envío.
    }
  }

  Future<void> _run(Future<Job> Function() call, {String? done}) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await call();
      ref.invalidate(jobProvider(widget.jobId));
      if (done != null) messenger.showSnackBar(SnackBar(content: Text(done)));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      ref.invalidate(jobProvider(widget.jobId));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _act(JobAction action, String done) => _run(
    () => ref.read(jobsRepositoryProvider).act(widget.jobId, action),
    done: done,
  );

  Future<void> _confirm(Job job) async {
    final ok = await _ask(
      '¿Confirmas que terminó el trabajo?',
      'Se cerrará el trabajo con ${job.counterpartShortName} por ${formatBs(job.finalPriceBs)}.',
      'Confirmar',
    );
    if (ok) await _act(JobAction.confirm, 'Confirmaste el trabajo. ¡Gracias!');
  }

  Future<void> _dispute() async {
    final note = await _askNote();
    if (note == null) return;
    await _run(
      () => ref
          .read(jobsRepositoryProvider)
          .dispute(widget.jobId, note: note.isEmpty ? null : note),
      done: 'Lo revisará el equipo de SISI y te avisaremos.',
    );
  }

  Future<void> _cancel() async {
    final input = await showCancelJobDialog(context);
    if (input == null) return;
    await _run(
      () => ref
          .read(jobsRepositoryProvider)
          .cancel(widget.jobId, input.reason, note: input.note),
      done: 'Cancelaste el trabajo.',
    );
  }

  Future<void> _review(Job job) async {
    final input = await showReviewSheet(
      context,
      counterpartName: job.counterpartShortName,
    );
    if (input == null) return;
    await _run(() async {
      await ref
          .read(reviewsRepositoryProvider)
          .submit(widget.jobId, input.stars, comment: input.comment);
      return job;
    }, done: '¡Gracias por calificar!');
  }

  Future<void> _republish(Job job) async {
    try {
      final request = await ref
          .read(requestsRepositoryProvider)
          .get(job.requestId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      await context.push(Routes.newRequest, extra: RepublishSeed.from(request));
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<bool> _ask(String title, String body, String yes) async =>
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Volver'),
            ),
            FilledButton(
              key: const Key('dialog-yes'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(yes),
            ),
          ],
        ),
      ) ??
      false;

  Future<String?> _askNote() => showDialog<String>(
    context: context,
    builder: (_) => const _DisputeDialog(),
  );

  @override
  Widget build(BuildContext context) {
    final job = ref.watch(jobProvider(widget.jobId));
    final value = job.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajo'),
        actions: [
          if (value != null)
            PopupMenuButton<ReportTarget>(
              key: const Key('job-menu'),
              tooltip: 'Más opciones',
              onSelected: (target) => showReportSheet(
                context,
                target: target,
                targetId: target == ReportTarget.job
                    ? value.id
                    : value.counterpartUserId,
              ),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: ReportTarget.job,
                  child: Text('Reportar un problema'),
                ),
                PopupMenuItem(
                  value: ReportTarget.user,
                  child: Text('Reportar a ${value.counterpartShortName}'),
                ),
              ],
            ),
        ],
      ),
      body: switch (job) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(jobProvider(widget.jobId));
            await ref.read(jobProvider(widget.jobId).future);
          },
          child: _body(value),
        ),
        AsyncError(:final error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              ApiException.from(error).message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _body(Job job) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Icon(
              categoryIcon(job.categorySlug),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(job.categoryName, style: theme.textTheme.titleLarge),
            ),
            Chip(key: const Key('job-status'), label: Text(job.status.label)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${job.iAmWorker ? 'Cliente' : 'Trabajador'}: ${job.counterpartShortName} · ${formatBs(job.finalPriceBs)}',
        ),
        const SizedBox(height: 4),
        Text(
          job.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        ..._notices(job, theme),
        if (!job.iAmWorker && job.status == JobStatus.enCamino) ...[
          _LiveMap(jobId: job.id),
          const SizedBox(height: 12),
        ],
        ..._actions(job),
        const SizedBox(height: 12),
        _Timeline(job: job),
        const SizedBox(height: 12),
        if (job.iAmWorker && job.commissionBs != null) ...[
          _Money(job: job),
          const SizedBox(height: 12),
        ],
        ..._reviews(job, theme),
        JobContactCard(jobId: job.id),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          key: const Key('open-chat'),
          onPressed: () => context.push(Routes.jobChat(job.id)),
          icon: const Icon(Icons.forum_outlined),
          label: const Text('Chat del trabajo'),
        ),
      ],
    );
  }

  List<Widget> _notices(Job job, ThemeData theme) {
    Widget banner(
      String text, {
      Key? key,
      IconData icon = Icons.info_outline,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        key: key,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
    final cancellation = job.cancellation;
    return [
      if (job.disputed && job.status == JobStatus.enCurso)
        banner(
          'Se reportó un problema. El equipo de SISI lo está revisando.',
          key: const Key('job-disputed'),
          icon: Icons.support_agent,
        )
      else if (job.workerFinished && job.status == JobStatus.enCurso)
        banner(
          job.iAmWorker
              ? 'Marcaste el trabajo como terminado. Esperamos la confirmación del cliente${_autoText(job)}.'
              : '${job.counterpartShortName} marcó el trabajo como terminado. Confírmalo o avísanos si hubo un problema${_autoText(job)}.',
          key: const Key('job-finished'),
          icon: Icons.task_alt,
        ),
      if (job.status == JobStatus.terminado)
        banner(
          job.autoConfirmed
              ? 'El trabajo se confirmó solo porque no hubo respuesta a tiempo.'
              : 'Trabajo terminado.',
          icon: Icons.verified_outlined,
        ),
      if (cancellation != null)
        banner(
          [
            switch (cancellation.by) {
              'admin' => 'El equipo de SISI canceló el trabajo.',
              _ when (cancellation.by == 'worker') == job.iAmWorker =>
                'Cancelaste el trabajo.',
              'worker' => 'El trabajador canceló el trabajo.',
              _ => 'El cliente canceló el trabajo.',
            },
            if (cancellation.by != 'admin')
              'Motivo: ${cancellation.reason.label}.',
            if (cancellation.note != null) '"${cancellation.note}"',
            if (cancellation.noteHeld)
              'Tu nota no se mostró porque no cumple las normas.',
          ].join(' '),
          key: const Key('job-cancelled'),
          icon: Icons.cancel_outlined,
        ),
    ];
  }

  String _autoText(Job job) {
    final at = job.autoConfirmAt;
    return at == null ? '' : ' (se confirma solo el ${formatDateTime(at)})';
  }

  List<Widget> _actions(Job job) {
    final buttons = <Widget>[
      if (job.can(JobAction.startTrip))
        FilledButton.icon(
          key: const Key('action-on-the-way'),
          onPressed: _busy
              ? null
              : () => _act(
                  JobAction.startTrip,
                  'Avisamos al cliente que vas en camino.',
                ),
          icon: const Icon(Icons.directions_run),
          label: const Text('Voy en camino'),
        ),
      if (job.can(JobAction.startWork))
        FilledButton.icon(
          key: const Key('action-start'),
          onPressed: _busy
              ? null
              : () => _act(JobAction.startWork, 'Empezaste el trabajo.'),
          icon: const Icon(Icons.build_outlined),
          label: const Text('Empecé el trabajo'),
        ),
      if (job.can(JobAction.finish))
        FilledButton.icon(
          key: const Key('action-finish'),
          onPressed: _busy
              ? null
              : () => _act(
                  JobAction.finish,
                  'Le pedimos al cliente que confirme.',
                ),
          icon: const Icon(Icons.task_alt),
          label: const Text('Terminé el trabajo'),
        ),
      if (job.can(JobAction.confirm))
        FilledButton.icon(
          key: const Key('action-confirm'),
          onPressed: _busy ? null : () => _confirm(job),
          icon: const Icon(Icons.verified_outlined),
          label: const Text('Confirmar que terminó'),
        ),
      if (job.can(JobAction.dispute))
        OutlinedButton.icon(
          key: const Key('action-dispute'),
          onPressed: _busy ? null : _dispute,
          icon: const Icon(Icons.report_problem_outlined),
          label: const Text('Hubo un problema'),
        ),
      if (job.can(JobAction.cancel))
        TextButton.icon(
          key: const Key('action-cancel'),
          onPressed: _busy ? null : _cancel,
          icon: const Icon(Icons.close),
          label: const Text('Cancelar trabajo'),
        ),
      if (!job.iAmWorker && job.status == JobStatus.cancelado)
        OutlinedButton.icon(
          key: const Key('job-republish'),
          onPressed: () => _republish(job),
          icon: const Icon(Icons.refresh),
          label: const Text('Volver a publicar'),
        ),
    ];
    return [
      for (final b in buttons)
        Padding(padding: const EdgeInsets.only(bottom: 8), child: b),
    ];
  }

  List<Widget> _reviews(Job job, ThemeData theme) {
    final reviews = job.reviews;
    if (job.status != JobStatus.terminado) return const [];
    return [
      Card(
        key: const Key('job-reviews'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Calificaciones', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              if (reviews.mine case final mine?) ...[
                Row(
                  children: [
                    const Text('Tu calificación: '),
                    StarsView(stars: mine.stars),
                  ],
                ),
                if (!mine.published)
                  Text(
                    '${job.counterpartShortName} la verá cuando también califique o venza el plazo.',
                    style: theme.textTheme.bodySmall,
                  ),
                if (mine.commentHeld)
                  Text(
                    'Tu comentario no se publicará porque no cumple las normas; las estrellas sí cuentan.',
                    style: theme.textTheme.bodySmall,
                  ),
              ] else if (reviews.canReview) ...[
                Text(
                  'Califica a ${job.counterpartShortName}${reviews.deadline == null ? '' : ' hasta el ${formatDate(reviews.deadline!)}'}.',
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  key: const Key('review-open'),
                  onPressed: _busy ? null : () => _review(job),
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Calificar'),
                ),
              ] else
                const Text('Pasó el plazo para calificar.'),
              if (reviews.theirs case final theirs?) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    Text('${job.counterpartShortName} te calificó: '),
                    StarsView(stars: theirs.stars),
                  ],
                ),
                if (theirs.comment != null) Text('"${theirs.comment}"'),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
    ];
  }
}

class _LiveMap extends ConsumerWidget {
  const _LiveMap({required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final point = ref.watch(trackingProvider(jobId)).value;
    return Card(
      key: const Key('live-map'),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 220,
        child: point == null
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Esperando la ubicación del trabajador…',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: TrackingMapView(position: point.position),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Chip(
                      label: Text('Actualizado ${formatTime(point.at)}'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final t = job.timeline;
    final steps = <(String, DateTime?)>[
      ('Asignado', t.assignedAt),
      ('En camino', t.onTheWayAt),
      ('En curso', t.startedAt),
      ('Terminado por el trabajador', t.workerFinishedAt),
      if (t.disputedAt != null) ('Problema reportado', t.disputedAt),
      if (job.status == JobStatus.cancelado)
        ('Cancelado', t.cancelledAt)
      else
        ('Confirmado', t.completedAt),
    ];
    return Card(
      key: const Key('job-timeline'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            for (final (label, at) in steps)
              ListTile(
                dense: true,
                leading: Icon(
                  at == null
                      ? Icons.radio_button_unchecked
                      : Icons.check_circle,
                  color: at == null
                      ? null
                      : Theme.of(context).colorScheme.primary,
                ),
                title: Text(label),
                trailing: at == null ? null : Text(formatDateTime(at)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Monto, comisión y neto para el trabajador (R8.3).
class _Money extends StatelessWidget {
  const _Money({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) => Card(
    key: const Key('job-money'),
    child: Column(
      children: [
        ListTile(
          dense: true,
          title: const Text('Precio del trabajo'),
          trailing: Text(formatBs(job.finalPriceBs)),
        ),
        ListTile(
          dense: true,
          title: const Text('Comisión SISI'),
          trailing: Text('− ${formatBs(job.commissionBs!)}'),
        ),
        ListTile(
          dense: true,
          title: const Text('Recibes'),
          trailing: Text(
            formatBs(job.netBs ?? job.finalPriceBs),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    ),
  );
}

/// "Hubo un problema": nota opcional para el equipo de SISI.
class _DisputeDialog extends StatefulWidget {
  const _DisputeDialog();

  @override
  State<_DisputeDialog> createState() => _DisputeDialogState();
}

class _DisputeDialogState extends State<_DisputeDialog> {
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('¿Qué pasó?'),
    content: TextField(
      key: const Key('dispute-note'),
      controller: _note,
      maxLength: 500,
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: 'Cuéntanos el problema (opcional)',
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Volver'),
      ),
      FilledButton(
        key: const Key('dispute-send'),
        onPressed: () => Navigator.of(context).pop(_note.text.trim()),
        child: const Text('Reportar problema'),
      ),
    ],
  );
}
