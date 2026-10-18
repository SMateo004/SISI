import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';

final dashboardProvider = FutureProvider.autoDispose
    .family<DashboardDto, String>((ref, range) async {
      final res = await ref
          .watch(adminApiProvider)
          .dashboardControllerGet(range: range);
      return res.data!;
    });

final pilotMetricsProvider = FutureProvider.autoDispose<PilotMetricsDto>((
  ref,
) async {
  final res = await ref.watch(adminApiProvider).dashboardControllerPilot();
  return res.data!;
});

/// Dashboard del día y de la semana (hora local de la ciudad) y métricas del piloto.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _range = 'day';

  @override
  Widget build(BuildContext context) {
    final pilot = _range == 'pilot';
    final value = ref.watch(dashboardProvider(pilot ? 'week' : _range));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          'Dashboard',
          subtitle: value.value?.cityName,
          actions: [
            SegmentedButton<String>(
              key: const Key('dashboard-range'),
              segments: const [
                ButtonSegment(value: 'day', label: Text('Hoy')),
                ButtonSegment(value: 'week', label: Text('Esta semana')),
                ButtonSegment(value: 'pilot', label: Text('Piloto')),
              ],
              selected: {_range},
              onSelectionChanged: (s) => setState(() => _range = s.first),
            ),
            IconButton(
              tooltip: 'Actualizar',
              icon: const Icon(Icons.refresh),
              onPressed: () => pilot
                  ? ref.invalidate(pilotMetricsProvider)
                  : ref.invalidate(dashboardProvider(_range)),
            ),
          ],
        ),
        Expanded(
          child: pilot
              ? AsyncBody(
                  value: ref.watch(pilotMetricsProvider),
                  onRetry: () => ref.invalidate(pilotMetricsProvider),
                  data: (m) => _PilotBody(m),
                )
              : AsyncBody(
                  value: value,
                  onRetry: () => ref.invalidate(dashboardProvider(_range)),
                  data: (d) => _DashboardBody(d),
                ),
        ),
      ],
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody(this.d);

  final DashboardDto d;

  String _pct(num? v) =>
      v == null ? '—' : '${v.toString().replaceAll('.', ',')} %';

  String _first(num? seconds) {
    if (seconds == null) return '—';
    return seconds < 60
        ? '${seconds.round()} s'
        : '${(seconds / 60).toStringAsFixed(1).replaceAll('.', ',')} min';
  }

  @override
  Widget build(BuildContext context) {
    final q = d.queues;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
        Text('Del ${formatDateTime(d.from)} al ${formatDateTime(d.to)}'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Metric(
              'Solicitudes publicadas',
              '${d.requestsCreated}',
              key: const Key('m-requests'),
            ),
            _Metric('Tasa de asignación', _pct(d.assignmentRatePct)),
            _Metric('Tasa de expiración', _pct(d.expirationRatePct)),
            _Metric('Tiempo a la primera oferta', _first(d.avgFirstOfferSec)),
            _Metric(
              'Trabajos terminados',
              '${d.jobsCompleted}',
              key: const Key('m-completed'),
            ),
            _Metric(
              'Comisión generada',
              formatBs(d.commissionGeneratedBs),
              key: const Key('m-commission'),
            ),
            _Metric('Comisión cobrada', formatBs(d.commissionCollectedBs)),
            _Metric(
              'Deuda vencida',
              '${formatBs(d.overdueDebtBs)} · ${d.overdueWorkers} trabajadores',
            ),
            _Metric('Disponibles ahora', '${d.workersAvailableNow}'),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Cancelaciones por motivo',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (d.cancellationsByReason.isEmpty)
          const Text('Sin cancelaciones.')
        else
          for (final c in d.cancellationsByReason)
            InfoRow(c.reason.replaceAll('_', ' '), '${c.count}'),
        const SizedBox(height: 24),
        Text('Pendientes', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Queue('Verificaciones', q.verifications, '/verificaciones'),
            _Queue(
              'Solicitudes retenidas',
              q.heldRequests,
              '/moderacion/retenidas',
            ),
            _Queue('Mensajes retenidos', q.heldMessages, '/moderacion/chat'),
            _Queue('Reportes', q.reports, '/moderacion/reportes'),
            _Queue('Disputas', q.disputes, '/moderacion/disputas'),
            _Queue('Comprobantes', q.submissions, '/cobros/comprobantes'),
          ],
        ),
      ],
    );
  }
}

String _pct(num? v) =>
    v == null ? '—' : '${v.toString().replaceAll('.', ',')} %';

/// Piloto (ADR-0052): embudo, tasas y retención semanal desde el inicio del piloto.
class _PilotBody extends StatelessWidget {
  const _PilotBody(this.m);

  final PilotMetricsDto m;

  @override
  Widget build(BuildContext context) {
    final f = m.funnel;
    final theme = Theme.of(context);
    String share(num part) =>
        f.created == 0 ? '' : ' (${(part * 100 / f.created).round()} %)';
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
        Text(
          m.startedAt == null
              ? 'Últimas 8 semanas (configura "Inicio del piloto" en Parámetros)'
              : 'Desde el inicio del piloto: ${m.startedAt}',
        ),
        const SizedBox(height: 12),
        Text('Embudo', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Metric(
              'Solicitudes creadas',
              '${f.created}',
              key: const Key('p-created'),
            ),
            _Metric(
              'Con primera oferta',
              '${f.withOffer}${share(f.withOffer)}',
            ),
            _Metric('Asignadas', '${f.assigned}${share(f.assigned)}'),
            _Metric('Terminadas', '${f.completed}${share(f.completed)}'),
            _Metric(
              'Comisión cobrada',
              '${f.commissionCollected}${share(f.commissionCollected)}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _Metric(
              'Tiempo a la primera oferta',
              m.avgFirstOfferSec == null
                  ? '—'
                  : '${(m.avgFirstOfferSec! / 60).toStringAsFixed(1).replaceAll('.', ',')} min',
            ),
            _Metric('Tasa de expiración', _pct(m.expirationRatePct)),
            _Metric(
              'Tasa de cobro',
              _pct(m.collectionRatePct),
              key: const Key('p-collection'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Retención semanal', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        DataTable(
          key: const Key('p-weekly'),
          columns: const [
            DataColumn(label: Text('Semana')),
            DataColumn(label: Text('Trabajadores'), numeric: true),
            DataColumn(label: Text('Vuelven'), numeric: true),
            DataColumn(label: Text('Empleadores'), numeric: true),
            DataColumn(label: Text('Vuelven'), numeric: true),
          ],
          rows: [
            for (final w in m.weekly)
              DataRow(
                cells: [
                  DataCell(Text(w.weekStart)),
                  DataCell(Text('${w.activeWorkers}')),
                  DataCell(Text(_pct(w.workerRetentionPct))),
                  DataCell(Text('${w.activeEmployers}')),
                  DataCell(Text(_pct(w.employerRetentionPct))),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 230,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(value, style: theme.textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _Queue extends StatelessWidget {
  const _Queue(this.label, this.count, this.path);

  final String label;
  final num count;
  final String path;

  @override
  Widget build(BuildContext context) => ActionChip(
    avatar: CircleAvatar(child: Text('$count')),
    label: Text(label),
    onPressed: () => context.go(path),
  );
}
