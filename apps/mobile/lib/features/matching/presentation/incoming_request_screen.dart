import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../application/incoming_requests.dart';
import 'incoming_request_card.dart';

/// Detalle de una solicitud entrante (se abre también desde el push).
class IncomingRequestScreen extends ConsumerWidget {
  const IncomingRequestScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(incomingRequestProvider(requestId));
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitud cercana')),
      body: switch (request) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [IncomingRequestCard(request: value, expanded: true)],
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
