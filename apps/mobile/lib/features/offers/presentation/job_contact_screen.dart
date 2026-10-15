import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../../../shared/money.dart';
import '../data/offers_repository.dart';

/// Contacto revelado tras la elección (R5.4, R9.4). Lo ven solo las dos partes.
class JobContactScreen extends ConsumerWidget {
  const JobContactScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(jobContactProvider(jobId));
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Trabajo asignado')),
      body: switch (contact) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Icon(
              Icons.handshake_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              value.role == 'worker'
                  ? 'Elegiste a tu trabajador'
                  : '¡Te eligieron para este trabajo!',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Precio acordado: ${formatBs(value.finalPriceBs)} (incluye el traslado).',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: Text(value.name ?? 'Sin nombre'),
                    subtitle: Text(
                      value.role == 'worker' ? 'Trabajador' : 'Cliente',
                    ),
                  ),
                  ListTile(
                    key: const Key('contact-phone'),
                    leading: const Icon(Icons.phone_outlined),
                    title: Text(value.phone),
                    trailing: IconButton(
                      tooltip: 'Copiar número',
                      icon: const Icon(Icons.copy),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: value.phone),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Número copiado.')),
                          );
                        }
                      },
                    ),
                  ),
                  if (value.address != null)
                    ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(value.address!),
                      subtitle: const Text('Dirección del trabajo'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Coordinen la llegada por teléfono. El seguimiento del trabajo llega pronto a la app.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
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
}
