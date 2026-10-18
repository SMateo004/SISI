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

/// Dashboard del día y de la semana (hora local de la ciudad).
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _range = 'day';

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(dashboardProvider(_range));
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
              ],
              selected: {_range},
              onSelectionChanged: (s) => setState(() => _range = s.first),
            ),
            IconButton(
              tooltip: 'Actualizar',
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(dashboardProvider(_range)),
            ),
          ],
        ),
        Expanded(
          child: AsyncBody(
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
