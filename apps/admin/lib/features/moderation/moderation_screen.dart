import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/http/api_error.dart';
import '../../core/realtime/counters.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';
import '../../core/widgets/server_table.dart';

const _tabs = [
  ('retenidas', 'Solicitudes retenidas'),
  ('chat', 'Chat retenido'),
  ('reportes', 'Reportes'),
  ('disputas', 'Disputas'),
  ('terminos', 'Términos'),
];

/// Moderación (R3.3, R9.2, R9.3): retenidas, chat, reportes, disputas y términos.
class ModerationScreen extends ConsumerWidget {
  const ModerationScreen({super.key, required this.tab});

  final String tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = switch (tab) {
      'chat' => const _HeldMessages(),
      'reportes' => const _Reports(),
      'disputas' => const _Disputes(),
      'terminos' => const _Terms(),
      _ => const _HeldRequests(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader('Moderación'),
        SectionTabs(
          tabs: _tabs,
          current: tab,
          onSelect: (t) => context.go('/moderacion/$t'),
        ),
        const SizedBox(height: 8),
        Expanded(child: body),
      ],
    );
  }
}

/// Términos que coincidieron, en una línea ("marihuan* (drogas)").
String matchedTerms(Object matches) {
  final raw = matches is Map ? matches['matches'] : matches;
  if (raw is! List || raw.isEmpty) return jsonEncode(matches);
  return raw
      .whereType<Map<dynamic, dynamic>>()
      .map((m) => '${m['term']} (${m['category']})')
      .join(', ');
}

class _HeldRequests extends ConsumerStatefulWidget {
  const _HeldRequests();

  @override
  ConsumerState<_HeldRequests> createState() => _HeldRequestsState();
}

class _HeldRequestsState extends ConsumerState<_HeldRequests> {
  int _reload = 0;

  Future<void> _decide(AdminHeldRequestDto r, {required bool release}) async {
    final api = ref.read(adminApiProvider);
    final ok = await confirmAction<bool>(
      context,
      title: release ? 'Liberar solicitud' : 'Rechazar solicitud',
      message: release
          ? 'Pasa a "buscando" y entra al matching. Coincidió con: ${matchedTerms(r.matches)}.'
          : 'Queda cancelada por moderación y se le avisa al empleador.',
      confirmLabel: release ? 'Liberar' : 'Rechazar',
      destructive: !release,
      onConfirm: (input) async {
        final body = ModerationDecisionDto(reason: input.note);
        release
            ? await api.adminRequestsControllerRelease(
                id: r.id,
                moderationDecisionDto: body,
              )
            : await api.adminRequestsControllerReject(
                id: r.id,
                moderationDecisionDto: body,
              );
        return true;
      },
    );
    if (ok == true && mounted) {
      showDone(
        context,
        release ? 'Solicitud liberada.' : 'Solicitud rechazada.',
      );
      setState(() => _reload++);
      ref.read(countersProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) => ServerTable<AdminHeldRequestDto>(
    key: const Key('held-requests'),
    reloadKey: _reload,
    empty: 'No hay solicitudes retenidas.',
    load: (cursor) async {
      final res = await ref
          .read(adminApiProvider)
          .adminRequestsControllerList(cursor: cursor);
      return PageResult(res.data!.items, res.data!.nextCursor);
    },
    columns: [
      ServerColumn('Creada', (r) => Text(formatIso(r.createdAt))),
      ServerColumn('Categoría', (r) => Text(r.category.name)),
      ServerColumn(
        'Descripción',
        (r) => SizedBox(
          width: 360,
          child: Text(
            r.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      ServerColumn('Coincidió con', (r) => Text(matchedTerms(r.matches))),
      ServerColumn('Precio', (r) => Text(formatBs(r.proposedPriceBs))),
      ServerColumn(
        '',
        (r) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              key: Key('release-${r.id}'),
              onPressed: () => _decide(r, release: true),
              child: const Text('Liberar'),
            ),
            TextButton(
              key: Key('reject-${r.id}'),
              onPressed: () => _decide(r, release: false),
              child: const Text('Rechazar'),
            ),
          ],
        ),
      ),
    ],
  );
}

class _HeldMessages extends ConsumerStatefulWidget {
  const _HeldMessages();

  @override
  ConsumerState<_HeldMessages> createState() => _HeldMessagesState();
}

class _HeldMessagesState extends ConsumerState<_HeldMessages> {
  int _reload = 0;

  Future<void> _decide(AdminHeldMessageDto m, {required bool release}) async {
    final api = ref.read(adminApiProvider);
    final ok = await confirmAction<bool>(
      context,
      title: release ? 'Liberar mensaje' : 'Descartar mensaje',
      message: release
          ? 'Se entrega al destinatario con su hora original.'
          : 'No se entrega nunca. Quien lo envió lo sigue viendo como "no enviado".',
      confirmLabel: release ? 'Liberar' : 'Descartar',
      destructive: !release,
      onConfirm: (input) async {
        final body = ModerationDecisionDto(reason: input.note);
        release
            ? await api.adminChatControllerRelease(
                messageId: m.id,
                moderationDecisionDto: body,
              )
            : await api.adminChatControllerDiscard(
                messageId: m.id,
                moderationDecisionDto: body,
              );
        return true;
      },
    );
    if (ok == true && mounted) {
      showDone(context, release ? 'Mensaje entregado.' : 'Mensaje descartado.');
      setState(() => _reload++);
      ref.read(countersProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) => ServerTable<AdminHeldMessageDto>(
    key: const Key('held-messages'),
    reloadKey: _reload,
    empty: 'No hay mensajes retenidos.',
    load: (cursor) async {
      final res = await ref
          .read(adminApiProvider)
          .adminChatControllerHeld(cursor: cursor);
      return PageResult(res.data!.items, res.data!.nextCursor);
    },
    columns: [
      ServerColumn('Enviado', (m) => Text(formatDateTime(m.createdAt))),
      ServerColumn('Mensaje', (m) => SizedBox(width: 360, child: Text(m.body))),
      ServerColumn('Coincidió con', (m) => Text(matchedTerms(m.matches))),
      ServerColumn(
        'Trabajo',
        (m) => TextButton(
          onPressed: () => context.go('/moderacion/disputas/${m.jobId}'),
          child: const Text('Ver trabajo'),
        ),
      ),
      ServerColumn(
        '',
        (m) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              key: Key('release-msg-${m.id}'),
              onPressed: () => _decide(m, release: true),
              child: const Text('Liberar'),
            ),
            TextButton(
              key: Key('discard-msg-${m.id}'),
              onPressed: () => _decide(m, release: false),
              child: const Text('Descartar'),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Reports extends ConsumerStatefulWidget {
  const _Reports();

  @override
  ConsumerState<_Reports> createState() => _ReportsState();
}

class _ReportsState extends ConsumerState<_Reports> {
  String _status = 'pendiente';
  int _reload = 0;

  Future<void> _resolve(AdminReportDto r, {required bool valid}) async {
    final result = await confirmAction<ResolveReportResultDto>(
      context,
      title: valid ? 'Marcar como válido' : 'Descartar reporte',
      message: valid
          ? 'Cuenta para la suspensión: con 3 válidos de personas distintas, el trabajador queda suspendido; si es solo empleador, queda marcado para revisión. Hoy tiene ${r.reportedUser.validReporters}.'
          : 'No cuenta para la suspensión.',
      confirmLabel: valid ? 'Válido' : 'Descartar',
      destructive: valid,
      noteLabel: 'Resolución',
      onConfirm: (input) async {
        final res = await ref
            .read(adminApiProvider)
            .adminReportsControllerResolve(
              id: r.id,
              resolveReportDto: ResolveReportDto(
                valid: valid,
                resolution: input.note,
              ),
            );
        return res.data!;
      },
    );
    if (result != null && mounted) {
      final outcome = switch (result.outcome.value) {
        'suspend' => ' El trabajador quedó suspendido.',
        'flag' => ' El empleador quedó marcado para revisión.',
        _ => '',
      };
      showDone(context, 'Reporte resuelto.$outcome');
      setState(() => _reload++);
      ref.read(countersProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            DropdownButton<String>(
              key: const Key('reports-status'),
              value: _status,
              items: const [
                DropdownMenuItem(value: 'pendiente', child: Text('Pendientes')),
                DropdownMenuItem(value: 'valido', child: Text('Válidos')),
                DropdownMenuItem(
                  value: 'descartado',
                  child: Text('Descartados'),
                ),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'pendiente'),
            ),
          ],
        ),
      ),
      Expanded(
        child: ServerTable<AdminReportDto>(
          key: const Key('reports-table'),
          reloadKey: (_status, _reload),
          empty: 'No hay reportes.',
          load: (cursor) async {
            final res = await ref
                .read(adminApiProvider)
                .adminReportsControllerList(status: _status, cursor: cursor);
            return PageResult(res.data!.items, res.data!.nextCursor);
          },
          columns: [
            ServerColumn('Fecha', (r) => Text(formatDateTime(r.createdAt))),
            ServerColumn(
              'Motivo',
              (r) => Text(r.reason.value.replaceAll('_', ' ')),
            ),
            ServerColumn(
              'Qué',
              (r) => SizedBox(width: 280, child: Text(r.targetSummary)),
            ),
            ServerColumn(
              'Reportó',
              (r) => Text(r.reporterName ?? r.reporterPhone),
            ),
            ServerColumn(
              'Reportado',
              (r) => TextButton(
                onPressed: () => context.go('/usuarios/${r.reportedUser.id}'),
                child: Text(
                  '${r.reportedUser.name ?? r.reportedUser.phone} · ${r.reportedUser.validReporters} válidos',
                ),
              ),
            ),
            ServerColumn(
              'Nota',
              (r) => Text(
                r.noteHeld ? '(retenida) ${r.note ?? ''}' : r.note ?? '—',
              ),
            ),
            ServerColumn(
              '',
              (r) => r.status.value != 'pendiente'
                  ? Text(r.resolution ?? '')
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          key: Key('report-valid-${r.id}'),
                          onPressed: () => _resolve(r, valid: true),
                          child: const Text('Válido'),
                        ),
                        TextButton(
                          key: Key('report-dismiss-${r.id}'),
                          onPressed: () => _resolve(r, valid: false),
                          child: const Text('Descartar'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    ],
  );
}

final disputedJobsProvider =
    FutureProvider.autoDispose<List<AdminDisputedJobDto>>((ref) async {
      final res = await ref
          .watch(adminApiProvider)
          .adminJobsControllerDisputed();
      return res.data!;
    });

class _Disputes extends ConsumerWidget {
  const _Disputes();

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncBody(
    value: ref.watch(disputedJobsProvider),
    onRetry: () => ref.invalidate(disputedJobsProvider),
    data: (jobs) => jobs.isEmpty
        ? const Center(child: Text('No hay disputas abiertas.'))
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              for (final j in jobs)
                Card(
                  child: ListTile(
                    key: Key('dispute-${j.id}'),
                    title: Text(
                      '${j.category.name} · ${formatBs(j.finalPriceBs)}',
                    ),
                    subtitle: Text(
                      'Reportado el ${formatDateTime(j.disputedAt)}: ${j.disputeNote ?? 'sin nota'}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/moderacion/disputas/${j.id}'),
                  ),
                ),
            ],
          ),
  );
}

final termsProvider = FutureProvider.autoDispose<List<ModerationTermDto>>((
  ref,
) async {
  final res = await ref
      .watch(adminApiProvider)
      .moderationTermsControllerList(incluirInactivos: true);
  return res.data!;
});

const _termCategories = [
  'sexual',
  'drogas',
  'armas',
  'ilegal',
  'inmoral',
  'venta_productos',
];

class _Terms extends ConsumerStatefulWidget {
  const _Terms();

  @override
  ConsumerState<_Terms> createState() => _TermsState();
}

class _TermsState extends ConsumerState<_Terms> {
  final _probe = TextEditingController();
  ModerationTestResultDto? _result;
  String? _probeError;

  @override
  void dispose() {
    _probe.dispose();
    super.dispose();
  }

  Future<void> _test() async {
    try {
      final res = await ref
          .read(adminApiProvider)
          .moderationTermsControllerTest(
            testModerationDto: TestModerationDto(text: _probe.text),
          );
      setState(() {
        _result = res.data;
        _probeError = null;
      });
    } catch (error) {
      setState(() => _probeError = ApiError.from(error).message);
    }
  }

  Future<void> _toggle(ModerationTermDto t) async {
    final ok = await confirmAction<bool>(
      context,
      title: t.active ? 'Desactivar término' : 'Reactivar término',
      message:
          '"${t.term}" (${t.category.value}). Se aplica en segundos a solicitudes y chat.',
      confirmLabel: t.active ? 'Desactivar' : 'Reactivar',
      destructive: t.active,
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .moderationTermsControllerUpdate(
              id: t.id,
              updateModerationTermDto: UpdateModerationTermDto(
                active: !t.active,
                reason: input.note,
              ),
            );
        return true;
      },
    );
    if (ok == true) ref.invalidate(termsProvider);
  }

  Future<void> _create() async {
    final term = TextEditingController();
    var kind = 'word';
    var category = 'drogas';
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Nuevo término'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('term-text'),
                  controller: term,
                  decoration: const InputDecoration(
                    labelText: 'Palabra, frase (con * de prefijo) o regex',
                  ),
                ),
                DropdownButtonFormField<String>(
                  initialValue: kind,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(
                      value: 'word',
                      child: Text('Palabra o frase'),
                    ),
                    DropdownMenuItem(value: 'regex', child: Text('Regex')),
                  ],
                  onChanged: (v) => setLocal(() => kind = v ?? 'word'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Categoría (R9.1)',
                  ),
                  items: [
                    for (final c in _termCategories)
                      DropdownMenuItem(
                        value: c,
                        child: Text(c.replaceAll('_', ' ')),
                      ),
                  ],
                  onChanged: (v) => setLocal(() => category = v ?? 'drogas'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !mounted) return;
    final created = await confirmAction<bool>(
      context,
      title: 'Agregar término',
      message: '"${term.text.trim()}" ($category). Se valida antes de guardar.',
      confirmLabel: 'Agregar',
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .moderationTermsControllerCreate(
              createModerationTermDto: CreateModerationTermDto(
                term: term.text.trim(),
                kind: CreateModerationTermDtoKindEnum.values.firstWhere(
                  (e) => e.value == kind,
                ),
                category: CreateModerationTermDtoCategoryEnum.values.firstWhere(
                  (e) => e.value == category,
                ),
                reason: input.note,
              ),
            );
        return true;
      },
    );
    term.dispose();
    if (created == true) ref.invalidate(termsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final terms = ref.watch(termsProvider);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Probador',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Text(
                  'Pega un texto y mira qué términos coinciden. No guarda nada.',
                ),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('probe-text'),
                  controller: _probe,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    key: const Key('probe-run'),
                    onPressed: _test,
                    child: const Text('Probar'),
                  ),
                ),
                if (_probeError != null) Text(_probeError!),
                if (_result != null)
                  Text(
                    _result!.held
                        ? 'Quedaría retenido: ${_result!.matches.map((m) => '${m.term} (${m.category.value})').join(', ')}${_result!.timedOut ? ' (un regex no terminó a tiempo)' : ''}'
                        : 'No coincide con ningún término.',
                    key: const Key('probe-result'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('Términos', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            FilledButton.icon(
              key: const Key('term-new'),
              onPressed: _create,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo término'),
            ),
          ],
        ),
        AsyncBody(
          value: terms,
          data: (list) => Column(
            children: [
              for (final t in list)
                ListTile(
                  dense: true,
                  title: Text(
                    t.term,
                    style: TextStyle(
                      decoration: t.active ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  subtitle: Text(
                    '${t.kind.value} · ${t.category.value.replaceAll('_', ' ')}${t.note == null ? '' : ' · ${t.note}'}',
                  ),
                  trailing: Switch(
                    value: t.active,
                    onChanged: (_) => _toggle(t),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
