import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../permissions/permission_primer.dart';
import 'push_service.dart';

/// ¿Esta app puede recibir push? (Firebase configurado y plataforma con push.)
final pushAvailableProvider = Provider<bool>(
  (ref) => Env.pushConfigured && pushPlatform() != null,
);

/// Respuesta a la explicación de los avisos (ADR-0051). Solo con "Activar" se pide el
/// permiso del sistema y se registra el dispositivo.
class NotificationsPrimer extends AsyncNotifier<PrimerAnswer> {
  @override
  Future<PrimerAnswer> build() =>
      ref.read(primerStoreProvider).read(PrimedPermission.notifications);

  Future<void> answer(PrimerAnswer answer) async {
    await ref
        .read(primerStoreProvider)
        .write(PrimedPermission.notifications, answer);
    state = AsyncData(answer);
  }
}

final notificationsPrimerProvider =
    AsyncNotifierProvider<NotificationsPrimer, PrimerAnswer>(
      NotificationsPrimer.new,
    );

/// Tarjeta del inicio: explica para qué son los avisos antes de pedir el permiso.
class NotificationsPrimerCard extends ConsumerWidget {
  const NotificationsPrimerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answer = ref.watch(notificationsPrimerProvider).value;
    if (!ref.watch(pushAvailableProvider) || answer != PrimerAnswer.unknown) {
      return const SizedBox.shrink();
    }
    final notifier = ref.read(notificationsPrimerProvider.notifier);
    return Card(
      key: const Key('notifications-primer'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active_outlined),
                const SizedBox(width: 8),
                Text(
                  'Activa los avisos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Te avisamos cuando llega una solicitud o una oferta, cuando cambia tu trabajo, '
              'cuando te escriben y cuando vence tu comisión. Nada de publicidad.',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const Key('notifications-primer-later'),
                  onPressed: () => notifier.answer(PrimerAnswer.declined),
                  child: const Text('Ahora no'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('notifications-primer-enable'),
                  onPressed: () => notifier.answer(PrimerAnswer.accepted),
                  child: const Text('Activar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
