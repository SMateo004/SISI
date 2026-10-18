import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/realtime/counters.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';
import 'moderation_screen.dart' show disputedJobsProvider;

final jobDetailProvider = FutureProvider.autoDispose
    .family<AdminJobDetailDto, String>((ref, id) async {
      final res = await ref
          .watch(adminApiProvider)
          .adminJobsControllerDetail(id: id);
      return res.data!;
    });

/// Revisión de un trabajo en disputa: línea de tiempo, chat completo (incluido lo retenido)
/// y ofertas con su historial (ADR-0042). Se resuelve confirmando (con comisión) o
/// cancelando (sin comisión).
class DisputeScreen extends ConsumerWidget {
  const DisputeScreen({super.key, required this.jobId});

  final String jobId;

  Future<void> _resolve(
    BuildContext context,
    WidgetRef ref, {
    required bool confirm,
  }) async {
    final ok = await confirmAction<bool>(
      context,
      title: confirm ? 'Confirmar el trabajo' : 'Cancelar el trabajo',
      message: confirm
          ? 'Queda terminado y se genera la comisión.'
          : 'Queda cancelado y no se cobra comisión.',
      confirmLabel: confirm ? 'Confirmar' : 'Cancelar trabajo',
      destructive: !confirm,
      noteLabel: 'Nota de la resolución',
      onConfirm: (input) async {
        await ref
            .read(adminApiProvider)
            .adminJobsControllerResolve(
              id: jobId,
              resolveDisputeDto: ResolveDisputeDto(
                decision: confirm
                    ? ResolveDisputeDtoDecisionEnum.confirm
                    : ResolveDisputeDtoDecisionEnum.cancel,
                note: input.note,
              ),
            );
        return true;
      },
    );
    if (ok == true && context.mounted) {
      showDone(context, confirm ? 'Trabajo confirmado.' : 'Trabajo cancelado.');
      ref.invalidate(jobDetailProvider(jobId));
      ref.invalidate(disputedJobsProvider);
      ref.read(countersProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(jobDetailProvider(jobId));
    final open =
        value.value?.status == 'en_curso' && value.value?.disputedAt != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          'Trabajo',
          subtitle: value.value == null
              ? null
              : '${value.value!.category.name} · ${value.value!.status.replaceAll('_', ' ')}',
          actions: [
            TextButton.icon(
              onPressed: () => context.go('/moderacion/disputas'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Disputas'),
            ),
            if (open) ...[
              OutlinedButton(
                key: const Key('dispute-cancel'),
                onPressed: () => _resolve(context, ref, confirm: false),
                child: const Text('Cancelar sin comisión'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                key: const Key('dispute-confirm'),
                onPressed: () => _resolve(context, ref, confirm: true),
                child: const Text('Confirmar con comisión'),
              ),
            ],
          ],
        ),
        Expanded(
          child: AsyncBody(
            value: value,
            onRetry: () => ref.invalidate(jobDetailProvider(jobId)),
            data: (j) => ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                InfoRow('Pedido', j.description),
                InfoRow('Dirección', j.address),
                InfoRow('Precio propuesto', formatBs(j.proposedPriceBs)),
                InfoRow('Precio final', formatBs(j.finalPriceBs)),
                InfoRow(
                  'Comisión',
                  '${j.commissionPct.replaceAll('.', ',')} %${j.commissionBs == null ? '' : ' · ${formatBs(j.commissionBs!)}'}',
                ),
                InfoRow(
                  'Trabajador',
                  '${j.worker.name ?? 'Sin nombre'} · ${j.worker.phone}',
                ),
                InfoRow(
                  'Empleador',
                  '${j.employer.name ?? 'Sin nombre'} · ${j.employer.phone}',
                ),
                if (j.disputedAt != null)
                  InfoRow(
                    'Problema reportado',
                    '${formatDateTime(j.disputedAt!)}: ${j.disputeNote ?? 'sin nota'}',
                  ),
                const SizedBox(height: 16),
                Text(
                  'Línea de tiempo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final e in j.timeline)
                  ListTile(
                    key: Key('timeline-${e.action}'),
                    dense: true,
                    leading: const Icon(Icons.circle, size: 10),
                    title: Text(
                      '${e.action} · ${e.fromStatus} → ${e.toStatus}',
                    ),
                    subtitle: Text(
                      '${formatDateTime(e.at)} · ${e.actorRole.value}${e.note == null ? '' : ' · ${e.note}'}',
                    ),
                  ),
                const SizedBox(height: 16),
                Text('Chat', style: Theme.of(context).textTheme.titleMedium),
                if (j.chat.isEmpty) const Text('Sin mensajes.'),
                for (final m in j.chat)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      m.from.value == 'worker'
                          ? Icons.engineering
                          : Icons.person,
                    ),
                    title: Text(m.body),
                    subtitle: Text(formatDateTime(m.at)),
                    trailing: m.status.value == 'entregado'
                        ? null
                        : StatusChip(m.status.value, tone: ChipTone.warn),
                  ),
                const SizedBox(height: 16),
                Text('Ofertas', style: Theme.of(context).textTheme.titleMedium),
                for (final o in j.offers)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(o.worker.name ?? o.worker.phone),
                              const SizedBox(width: 8),
                              StatusChip(
                                o.status,
                                tone: o.chosen ? ChipTone.ok : ChipTone.neutral,
                              ),
                              if (o.chosen) const Text('  elegida'),
                            ],
                          ),
                          for (final h in o.history)
                            Text(
                              '${formatDateTime(h.at)} · ${h.kind.value} · ${formatBs(h.amountBs)} · llega en ${h.etaMin} min',
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
