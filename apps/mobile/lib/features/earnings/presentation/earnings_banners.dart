import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../shared/dates.dart';
import '../../../shared/money.dart';
import '../application/earnings_providers.dart';
import '../domain/earnings_models.dart';

/// Banners de cobro (R7.5 a R7.7): bloqueo por deuda, tope alcanzado y fecha límite
/// próxima, con acceso directo a pagar. El más grave primero; uno a la vez.
class EarningsBanners extends StatelessWidget {
  const EarningsBanners({super.key, required this.summary, this.now});

  final EarningsSummary summary;

  /// Para tests; por defecto, la hora actual.
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final due = summary.nextDueAt;
    final soon =
        due != null &&
        due.difference(now ?? DateTime.now()) <= const Duration(hours: 48);
    final (key, color, icon, text) = switch (summary) {
      EarningsSummary(blocked: true) => (
        'banner-blocked',
        theme.colorScheme.errorContainer,
        Icons.block,
        'Tu modo trabajador está bloqueado por deuda. Puedes seguir pidiendo servicios como empleador.',
      ),
      EarningsSummary(debtCap: DebtCapState(reached: true)) => (
        'banner-cap',
        theme.colorScheme.tertiaryContainer,
        Icons.warning_amber,
        'Paga para seguir recibiendo solicitudes. Tu comisión pendiente superó el tope de ${formatBs(summary.debtCap.capBs)}.',
      ),
      _ when soon && isPositiveAmount(summary.overdueOrPendingBs) => (
        'banner-due',
        theme.colorScheme.secondaryContainer,
        Icons.event,
        'Paga ${formatBs(summary.overdueOrPendingBs)} hasta el ${formatDueLabel(due)}.',
      ),
      _ => (null, null, null, null),
    };
    if (key == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        key: Key(key),
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Expanded(child: Text(text!)),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('banner-pay'),
                  onPressed: () => context.push(Routes.pay),
                  child: const Text('Pagar comisión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// En el inicio (los dos modos): banner de cobro si corresponde, y acceso a "Mis ganancias"
/// para quien tiene periodos de cobro.
class HomeEarningsBanner extends ConsumerWidget {
  const HomeEarningsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(accountEventsListenerProvider);
    final summary = ref.watch(earningsSummaryProvider).value;
    if (summary == null) return const SizedBox.shrink();
    return EarningsBanners(summary: summary);
  }
}
