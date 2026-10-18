import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_gate/app_gate.dart';
import '../../core/links/url_opener.dart';

/// Actualización obligatoria (ADR-0054): la API ya no atiende esta versión.
class UpdateScreen extends ConsumerWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gate = ref.watch(appGateProvider);
    final store = gate.storeUrl;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.system_update,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Actualiza la app',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Hay una versión nueva con cambios importantes. Actualízala para seguir usándola.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (store != null)
                FilledButton.icon(
                  key: const Key('update-store'),
                  onPressed: () =>
                      ref.read(urlOpenerProvider)(Uri.parse(store)),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Actualizar'),
                ),
              if (gate.support != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      ref.read(urlOpenerProvider)(gate.support!.url),
                  child: const Text('Ayuda por WhatsApp'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
