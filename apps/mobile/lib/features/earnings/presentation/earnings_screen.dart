import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/links/url_opener.dart';
import '../../../core/router/routes.dart';
import '../../../shared/dates.dart';
import '../../../shared/money.dart';
import '../application/earnings_providers.dart';
import '../domain/earnings_models.dart';
import 'earnings_banners.dart';

/// "Mis ganancias" (R8): periodo actual, saldo, fecha límite, tope e historiales.
class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(earningsSummaryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mis ganancias')),
      body: switch (summary) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref
              ..invalidate(earningsSummaryProvider)
              ..invalidate(billingPeriodsProvider)
              ..invalidate(myPaymentsProvider);
            await ref.read(earningsSummaryProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              EarningsBanners(summary: value),
              _CurrentPeriodCard(summary: value),
              const SizedBox(height: 8),
              _BalanceCard(summary: value),
              const SizedBox(height: 16),
              const _Section('Semanas'),
              const _PeriodsList(),
              const SizedBox(height: 16),
              const _Section('Pagos'),
              const _PaymentsList(),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  key: const Key('jobs-history'),
                  leading: const Icon(Icons.history),
                  title: const Text('Trabajos con monto y comisión'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.jobs(asWorker: true)),
                ),
              ),
            ],
          ),
        ),
        AsyncError(:final error) => Center(
          child: Text(ApiException.from(error).message),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _CurrentPeriodCard extends StatelessWidget {
  const _CurrentPeriodCard({required this.summary});

  final EarningsSummary summary;

  @override
  Widget build(BuildContext context) {
    final p = summary.currentPeriod;
    final theme = Theme.of(context);
    return Card(
      key: const Key('current-period'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esta semana (${formatDate(p.startAt)} al ${formatDate(p.endAt.subtract(const Duration(days: 1)))})',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            _Row('Ganado (bruto)', formatBs(p.grossBs)),
            _Row('Comisión SISI', '− ${formatBs(p.commissionBs)}'),
            const Divider(),
            _Row('Neto', formatBs(p.netBs), strong: true),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.summary});

  final EarningsSummary summary;

  @override
  Widget build(BuildContext context) {
    final cap = summary.debtCap;
    return Card(
      key: const Key('balance'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Row(
              'Saldo pendiente',
              formatBalance(summary.balanceBs),
              strong: true,
            ),
            if (summary.nextDueAt != null)
              _Row('Fecha límite', formatDueLabel(summary.nextDueAt!)),
            _Row(
              'Tope de deuda',
              cap.reached
                  ? 'Alcanzado (${formatBs(cap.capBs)})'
                  : formatBs(cap.capBs),
            ),
            if (summary.owes) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                key: const Key('go-pay'),
                onPressed: () => context.push(Routes.pay),
                icon: const Icon(Icons.qr_code_2),
                label: const Text('Pagar comisión'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final style = strong ? Theme.of(context).textTheme.titleMedium : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 8),
          // En pantallas angostas el valor (p. ej. la fecha límite) baja de línea.
          Flexible(
            child: Text(value, style: style, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}

class _PeriodsList extends ConsumerWidget {
  const _PeriodsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(billingPeriodsProvider).value ?? const [];
    if (periods.isEmpty) {
      return const Text('Todavía no tienes semanas con trabajos.');
    }
    return Card(
      child: Column(
        children: [
          for (final p in periods)
            ListTile(
              key: Key('period-${p.id}'),
              dense: true,
              title: Text('${formatDate(p.startAt)} · ${p.status.label}'),
              subtitle: Text(
                'Comisión ${formatBs(p.commissionBs)} · Neto ${formatBs(p.netBs)} · ${p.paymentReference}',
              ),
              trailing: Text(formatBalance(p.balanceBs)),
            ),
        ],
      ),
    );
  }
}

class _PaymentsList extends ConsumerWidget {
  const _PaymentsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(myPaymentsProvider).value ?? const [];
    if (payments.isEmpty) return const Text('Todavía no registramos pagos.');
    return Card(
      child: Column(
        children: [
          for (final p in payments)
            ListTile(
              key: Key('payment-${p.id}'),
              dense: true,
              leading: const Icon(Icons.check_circle_outline),
              title: Text('${formatBs(p.amountBs)} · ${formatDate(p.paidAt)}'),
              subtitle: Text('Registrado · ${p.periodReferences.join(', ')}'),
              trailing: p.receiptUrl == null
                  ? null
                  : IconButton(
                      key: Key('receipt-${p.id}'),
                      tooltip: 'Ver comprobante',
                      icon: const Icon(Icons.receipt_long),
                      onPressed: () =>
                          ref.read(urlOpenerProvider)(Uri.parse(p.receiptUrl!)),
                    ),
            ),
        ],
      ),
    );
  }
}
