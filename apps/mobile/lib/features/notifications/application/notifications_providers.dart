import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/realtime/realtime_providers.dart';
import '../data/notifications_repository.dart';

/// Contador del ícono de avisos. Cualquier aviso en tiempo real puede venir con uno
/// nuevo en la bandeja, así que se vuelve a pedir (y al reconectar).
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  ref.watch(realtimeResyncProvider);
  ref.listen(realtimeEventsProvider, (_, next) {
    if (next.value != null) ref.invalidateSelf();
  });
  return ref.watch(notificationsRepositoryProvider).unreadCount();
}, retry: (retryCount, error) => null);

/// Bandeja de avisos con paginación.
class NotificationsController extends AsyncNotifier<NotificationPage> {
  NotificationsRepository get _repo =>
      ref.read(notificationsRepositoryProvider);

  @override
  Future<NotificationPage> build() =>
      ref.watch(notificationsRepositoryProvider).list();

  Future<void> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (current == null || cursor == null) return;
    final page = await _repo.list(cursor: cursor);
    state = AsyncData(
      NotificationPage(
        items: [...current.items, ...page.items],
        nextCursor: page.nextCursor,
      ),
    );
  }

  Future<void> markRead(String id) async {
    await _repo.markRead(id);
    _update((n) => n.id == id);
    ref.invalidate(unreadCountProvider);
  }

  Future<void> readAll() async {
    await _repo.readAll();
    _update((_) => true);
    ref.invalidate(unreadCountProvider);
  }

  void _update(bool Function(AppNotification) which) {
    final current = state.value;
    if (current == null) return;
    final now = DateTime.now();
    state = AsyncData(
      NotificationPage(
        items: [
          for (final n in current.items)
            which(n) && n.unread
                ? AppNotification(
                    id: n.id,
                    title: n.title,
                    body: n.body,
                    route: n.route,
                    createdAt: n.createdAt,
                    readAt: now,
                  )
                : n,
        ],
        nextCursor: current.nextCursor,
      ),
    );
  }
}

final notificationsProvider =
    AsyncNotifierProvider.autoDispose<
      NotificationsController,
      NotificationPage
    >(NotificationsController.new);
