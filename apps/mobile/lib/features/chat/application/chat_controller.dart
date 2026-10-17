import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/realtime/realtime_client.dart';
import '../../../core/realtime/realtime_providers.dart';
import '../data/chat_repository.dart';
import '../domain/chat_models.dart';

class ChatState {
  const ChatState({
    required this.messages,
    required this.open,
    this.nextCursor,
    this.closesAt,
  });

  /// Del más reciente al más antiguo.
  final List<ChatMessage> messages;
  final bool open;
  final String? nextCursor;
  final DateTime? closesAt;

  ChatState copyWith({List<ChatMessage>? messages, String? nextCursor}) =>
      ChatState(
        messages: messages ?? this.messages,
        open: open,
        nextCursor: nextCursor ?? this.nextCursor,
        closesAt: closesAt,
      );
}

/// Chat de un trabajo: historial paginado y mensajes en vivo (`chat:message`). Con cada
/// aviso o reconexión vuelve a pedir la primera página y la junta con lo ya cargado.
class ChatController extends AsyncNotifier<ChatState> {
  ChatController(this.jobId);

  final String jobId;

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  @override
  Future<ChatState> build() async {
    ref.watch(realtimeResyncProvider);
    ref.listen(realtimeEventsProvider, (_, next) {
      final event = next.value;
      if (event?.name == RealtimeEvents.chatMessage && event?.jobId == jobId) {
        _refreshNewest();
      }
    });
    final page = await ref.watch(chatRepositoryProvider).list(jobId);
    _markRead(page.items);
    return _fromPage(page, older: const []);
  }

  Future<void> loadMore() async {
    final current = state.value;
    final cursor = current?.nextCursor;
    if (current == null || cursor == null) return;
    final page = await _repo.list(jobId, cursor: cursor);
    state = AsyncData(
      current.copyWith(
        messages: _merge(current.messages, page.items),
        nextCursor: page.nextCursor,
      ),
    );
  }

  /// Envía un mensaje. Devuelve el aviso si quedó retenido (null si se entregó).
  Future<String?> send(String body) async {
    final sent = await _repo.send(jobId, body);
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(messages: _merge([sent.message], current.messages)),
      );
    }
    return sent.notice;
  }

  Future<void> _refreshNewest() async {
    final page = await _repo.list(jobId);
    final current = state.value;
    _markRead(page.items);
    state = AsyncData(
      current == null
          ? _fromPage(page, older: const [])
          : _fromPage(page, older: current.messages),
    );
  }

  ChatState _fromPage(ChatPage page, {required List<ChatMessage> older}) =>
      ChatState(
        messages: _merge(page.items, older),
        open: page.open,
        nextCursor: older.isEmpty ? page.nextCursor : state.value?.nextCursor,
        closesAt: page.closesAt,
      );

  /// Marca como leído hasta el último mensaje recibido.
  void _markRead(List<ChatMessage> newestFirst) {
    for (final m in newestFirst) {
      if (!m.mine) {
        if (m.readAt == null) _repo.markRead(jobId, m.id).ignore();
        return;
      }
    }
  }

  static List<ChatMessage> _merge(List<ChatMessage> a, List<ChatMessage> b) {
    final byId = <String, ChatMessage>{for (final m in b) m.id: m};
    for (final m in a) {
      byId[m.id] = m;
    }
    return byId.values.toList()
      ..sort((x, y) => y.createdAt.compareTo(x.createdAt));
  }
}

final chatControllerProvider = AsyncNotifierProvider.autoDispose
    .family<ChatController, ChatState, String>(ChatController.new);
