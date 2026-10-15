import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../application/incoming_requests.dart';
import 'availability_card.dart';
import 'incoming_request_card.dart';

/// Inicio en modo trabajador: "Disponible" y las solicitudes que le llegaron.
class WorkerHomePanel extends ConsumerWidget {
  const WorkerHomePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final incoming = ref.watch(incomingRequestsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AvailabilityCard(),
        const SizedBox(height: 16),
        Text('Solicitudes cerca de ti', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        switch (incoming) {
          AsyncData(:final value) when value.isEmpty => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Todavía no te llegó ninguna. Cuando un cliente cerca de ti pida un servicio de tus categorías, aparecerá aquí.',
              key: Key('incoming-empty'),
              textAlign: TextAlign.center,
            ),
          ),
          AsyncData(:final value) => Column(
            children: [for (final r in value) IncomingRequestCard(request: r)],
          ),
          AsyncError(:final error) => ListTile(
            title: Text(ApiException.from(error).message),
            trailing: TextButton(
              onPressed: () => ref.invalidate(incomingRequestsProvider),
              child: const Text('Reintentar'),
            ),
          ),
          _ => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }
}
