import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/push/push_controller.dart';
import '../../../core/router/routes.dart';
import '../../../shared/dates.dart';
import '../application/notifications_providers.dart';
import '../data/notifications_repository.dart';

/// Bandeja de avisos (ADR-0027): tocar uno lo marca como leído y abre su pantalla.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _open(
    BuildContext context,
    WidgetRef ref,
    AppNotification n,
  ) async {
    if (n.unread) {
      await ref
          .read(notificationsProvider.notifier)
          .markRead(n.id)
          .catchError((_) {});
    }
    if (context.mounted && isPushRoute(n.route)) await context.push(n.route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(notificationsProvider);
    final hasUnread = page.value?.items.any((n) => n.unread) ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos'),
        actions: [
          if (hasUnread)
            TextButton(
              key: const Key('read-all'),
              onPressed: () =>
                  ref.read(notificationsProvider.notifier).readAll(),
              child: const Text('Marcar todo como leído'),
            ),
        ],
      ),
      body: switch (page) {
        AsyncData(:final value) when value.items.isEmpty => const Center(
          child: Text('No tienes avisos.'),
        ),
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(notificationsProvider);
            await ref.read(notificationsProvider.future);
          },
          child: ListView.separated(
            itemCount: value.items.length + (value.nextCursor != null ? 1 : 0),
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) {
              if (i == value.items.length) {
                return TextButton(
                  onPressed: () =>
                      ref.read(notificationsProvider.notifier).loadMore(),
                  child: const Text('Ver más'),
                );
              }
              final n = value.items[i];
              return ListTile(
                key: Key('notification-${n.id}'),
                leading: Icon(
                  n.unread ? Icons.circle : Icons.circle_outlined,
                  size: 12,
                  color: n.unread
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                title: Text(
                  n.title,
                  style: n.unread
                      ? const TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
                subtitle: Text('${n.body}\n${formatDateTime(n.createdAt)}'),
                isThreeLine: true,
                onTap: () => _open(context, ref, n),
              );
            },
          ),
        ),
        AsyncError(:final error) => Center(
          child: Text(ApiException.from(error).message),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// Ícono de avisos con el contador de no leídos.
class NotificationsBell extends ConsumerWidget {
  const NotificationsBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(unreadCountProvider).value ?? 0;
    return IconButton(
      key: const Key('notifications-bell'),
      tooltip: 'Avisos',
      onPressed: () async {
        await context.push(Routes.notifications);
        ref.invalidate(unreadCountProvider);
      },
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(
          count > 99 ? '99+' : '$count',
          key: const Key('unread-count'),
        ),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}
