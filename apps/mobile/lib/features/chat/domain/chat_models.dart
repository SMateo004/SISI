/// Mensajes del chat del trabajo (ADR-0031).
library;

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.mine,
    required this.body,
    required this.createdAt,
    this.held = false,
    this.readAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final readAt = json['readAt'];
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      mine: json['mine'] as bool? ?? false,
      body: json['body'] as String,
      held: json['status'] == 'retenido',
      readAt: readAt is String ? DateTime.parse(readAt).toLocal() : null,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  final String id;
  final String senderId;
  final bool mine;
  final String body;

  /// Retenido por moderación: no se entregó y solo lo veo yo.
  final bool held;
  final DateTime? readAt;
  final DateTime createdAt;
}

class ChatPage {
  const ChatPage({
    required this.items,
    required this.open,
    this.nextCursor,
    this.closesAt,
    this.unread = 0,
  });

  factory ChatPage.fromJson(Map<String, dynamic> json) {
    final closesAt = json['closesAt'];
    return ChatPage(
      items: (json['items'] as List)
          .cast<Map<String, dynamic>>()
          .map(ChatMessage.fromJson)
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      open: json['open'] as bool? ?? false,
      closesAt: closesAt is String ? DateTime.parse(closesAt).toLocal() : null,
      unread: json['unread'] as int? ?? 0,
    );
  }

  /// Del más reciente al más antiguo.
  final List<ChatMessage> items;
  final String? nextCursor;
  final bool open;
  final DateTime? closesAt;
  final int unread;
}

class SentMessage {
  const SentMessage({required this.message, this.notice});

  factory SentMessage.fromJson(Map<String, dynamic> json) => SentMessage(
    message: ChatMessage.fromJson(json),
    notice: json['notice'] as String?,
  );

  final ChatMessage message;

  /// Aviso neutral si el mensaje quedó retenido.
  final String? notice;
}
