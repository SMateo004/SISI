import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/http/api_client.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/confirm_action_dialog.dart';
import 'users_screen.dart';

final userProfileProvider = FutureProvider.autoDispose
    .family<UserProfileDto, String>((ref, id) async {
      final res = await ref
          .watch(adminApiProvider)
          .adminUsersControllerProfile(id: id);
      return res.data!;
    });

/// Ficha de un usuario: estado, modo, ciudad, calificaciones, cancelaciones, reportes,
/// trabajos, saldo y periodos. Suspender y reactivar (solo trabajadores) y quitar la marca.
class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key, required this.userId});

  final String userId;

  Future<void> _act(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String message,
    required String label,
    required bool destructive,
    required Future<void> Function(String reason) call,
  }) async {
    final ok = await confirmAction<bool>(
      context,
      title: title,
      message: message,
      confirmLabel: label,
      destructive: destructive,
      onConfirm: (input) async {
        await call(input.note);
        return true;
      },
    );
    if (ok == true && context.mounted) {
      showDone(context, 'Listo.');
      ref.invalidate(userProfileProvider(userId));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(userProfileProvider(userId));
    final api = ref.read(adminApiProvider);
    final p = value.value;
    final status = p?.worker?.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          p?.name ?? p?.phone ?? 'Usuario',
          subtitle: p == null ? null : '${p.phone} · ${p.cityName}',
          actions: [
            if (p?.worker != null)
              TextButton(
                onPressed: () => context.go('/cobros/trabajador/$userId'),
                child: const Text('Cobros'),
              ),
            if (p?.flagged == true)
              OutlinedButton(
                key: const Key('user-clear-flag'),
                onPressed: () => _act(
                  context,
                  ref,
                  title: 'Quitar la marca "revisar"',
                  message:
                      'La cuenta tiene 3 reportes válidos sin ser trabajador aprobado.',
                  label: 'Quitar marca',
                  destructive: false,
                  call: (r) => api.adminUsersControllerClearFlag(
                    id: userId,
                    reasonDto: ReasonDto(reason: r),
                  ),
                ),
                child: const Text('Quitar marca'),
              ),
            if (status == 'aprobado' || status == 'bloqueado_deuda')
              FilledButton(
                key: const Key('user-suspend'),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => _act(
                  context,
                  ref,
                  title: 'Suspender trabajador',
                  message:
                      'Pasa a suspendido, deja de recibir solicitudes y su cuenta queda en modo empleador.',
                  label: 'Suspender',
                  destructive: true,
                  call: (r) => api.adminUsersControllerSuspend(
                    id: userId,
                    reasonDto: ReasonDto(reason: r),
                  ),
                ),
                child: const Text('Suspender'),
              ),
            if (status == 'suspendido_moderacion')
              FilledButton(
                key: const Key('user-reactivate'),
                onPressed: () => _act(
                  context,
                  ref,
                  title: 'Levantar la suspensión',
                  message:
                      'Vuelve a aprobado, o a bloqueado por deuda si tiene un periodo vencido.',
                  label: 'Reactivar',
                  destructive: false,
                  call: (r) => api.adminUsersControllerReactivate(
                    id: userId,
                    reasonDto: ReasonDto(reason: r),
                  ),
                ),
                child: const Text('Reactivar'),
              ),
          ],
        ),
        Expanded(
          child: AsyncBody(
            value: value,
            onRetry: () => ref.invalidate(userProfileProvider(userId)),
            data: (p) => ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                InfoRow('Rol', p.role.value),
                InfoRow(
                  'Modo',
                  p.activeMode.value == 'worker' ? 'Trabajador' : 'Empleador',
                ),
                InfoRow('Alta', formatDateTime(p.createdAt)),
                InfoRow(
                  'Como empleador',
                  '★ ${p.employerRating.avg.replaceAll('.', ',')} (${p.employerRating.count})',
                ),
                InfoRow('Cancelaciones', '${p.cancellationsCount}'),
                if (p.flaggedAt != null)
                  InfoRow(
                    'Marcado para revisión',
                    formatDateTime(p.flaggedAt!),
                  ),
                InfoRow(
                  'Reportes recibidos',
                  '${p.reportCounts.pendiente} pendientes · ${p.reportCounts.valido} válidos · ${p.reportCounts.descartado} descartados',
                ),
                if (p.worker case final w?) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Trabajador',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      StatusChip(w.status, tone: workerTone(w.status)),
                    ],
                  ),
                  InfoRow('Desde', formatDateTime(w.statusChangedAt)),
                  InfoRow(
                    'Calificación',
                    '★ ${w.rating.avg.replaceAll('.', ',')} (${w.rating.count})',
                  ),
                  InfoRow('Categorías', w.categories.join(', ')),
                  InfoRow(
                    'Transporte',
                    '${w.transport ?? '—'} · ${w.maxRadiusKm ?? '—'} km',
                  ),
                  if (w.rejectionReason != null)
                    InfoRow('Último rechazo', w.rejectionReason!),
                  if (w.moderationResolution != null)
                    InfoRow(
                      'Resolución de moderación',
                      w.moderationResolution!,
                    ),
                  InfoRow('Saldo', formatBalance(w.balanceBs)),
                  for (final period in w.periods)
                    InfoRow(
                      period.paymentReference,
                      '${period.status.replaceAll('_', ' ')} · comisión ${formatBs(period.commissionBs)} · vence ${formatDateTime(period.dueAt)}',
                    ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Trabajos (${p.jobsCount})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final j in p.jobs)
                  ListTile(
                    dense: true,
                    title: Text(
                      '${j.categoryName} · ${formatBs(j.finalPriceBs)}',
                    ),
                    subtitle: Text(
                      '${j.as_.value == 'worker' ? 'Como trabajador' : 'Como empleador'} · ${j.status.replaceAll('_', ' ')} · ${formatDateTime(j.assignedAt)}',
                    ),
                    onTap: () => context.go('/moderacion/disputas/${j.id}'),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Reportes recibidos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                for (final r in p.reports)
                  ListTile(
                    dense: true,
                    title: Text(r.reason.replaceAll('_', ' ')),
                    subtitle: Text(
                      '${r.targetType} · ${r.status} · ${formatDateTime(r.createdAt)}',
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
