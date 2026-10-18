import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http/api_error.dart';

/// Cuerpo de un FutureProvider: cargando, error con reintento o el contenido.
class AsyncBody<T> extends StatelessWidget {
  const AsyncBody({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => data(value),
    AsyncError(:final error) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(ApiError.from(error).message, key: const Key('async-error')),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ],
      ),
    ),
    _ => const Center(child: CircularProgressIndicator()),
  };
}

/// Título de una página del panel, con acciones a la derecha.
class PageHeader extends StatelessWidget {
  const PageHeader(
    this.title, {
    super.key,
    this.actions = const [],
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Etiqueta de estado (pendiente, vencido, aprobado…).
class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone = ChipTone.neutral});

  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      ChipTone.ok => (scheme.primaryContainer, scheme.onPrimaryContainer),
      ChipTone.warn => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      ChipTone.bad => (scheme.errorContainer, scheme.onErrorContainer),
      ChipTone.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: TextStyle(color: fg, fontSize: 12),
      ),
    );
  }
}

enum ChipTone { ok, warn, bad, neutral }

/// Fila etiqueta–valor de una ficha.
class InfoRow extends StatelessWidget {
  const InfoRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 200,
          child: Text(
            label,
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
        ),
        Expanded(child: SelectableText(value)),
      ],
    ),
  );
}

/// Mensaje corto después de una acción.
void showDone(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

/// Pestañas de una sección; cada una tiene su ruta (se puede compartir el enlace).
class SectionTabs extends StatelessWidget {
  const SectionTabs({
    super.key,
    required this.tabs,
    required this.current,
    required this.onSelect,
  });

  final List<(String, String)> tabs;
  final String current;
  final void Function(String tab) onSelect;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Wrap(
      spacing: 8,
      children: [
        for (final (id, label) in tabs)
          ChoiceChip(
            key: Key('tab-$id'),
            label: Text(label),
            selected: id == current,
            onSelected: (_) => onSelect(id),
          ),
      ],
    ),
  );
}
