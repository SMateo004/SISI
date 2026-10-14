import 'package:flutter/material.dart';

import '../domain/service_request.dart';

class RequestStatusChip extends StatelessWidget {
  const RequestStatusChip({super.key, required this.status});

  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground) = switch (status) {
      RequestStatus.buscando || RequestStatus.conOfertas => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      RequestStatus.asignada => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      RequestStatus.retenida || RequestStatus.borrador => (
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      _ => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    };
    return Chip(
      label: Text(status.label, style: TextStyle(color: foreground)),
      backgroundColor: background,
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }
}
