import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';

/// Un aviso de la bandeja (ADR-0027). `route` es la pantalla que abre.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.route,
    required this.createdAt,
    this.readAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final readAt = json['readAt'];
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      route: json['route'] as String? ?? '/',
      readAt: readAt is String ? DateTime.parse(readAt).toLocal() : null,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }

  final String id;
  final String title;
  final String body;
  final String route;
  final DateTime? readAt;
  final DateTime createdAt;

  bool get unread => readAt == null;
}

class NotificationPage {
  const NotificationPage({required this.items, this.nextCursor});

  final List<AppNotification> items;
  final String? nextCursor;
}

class NotificationsRepository {
  NotificationsRepository(this._api);

  final Dio _api;

  Future<NotificationPage> list({String? cursor}) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/me/notifications',
      queryParameters: {'cursor': ?cursor},
    );
    final data = res.data!;
    return NotificationPage(
      items: (data['items'] as List)
          .cast<Map<String, dynamic>>()
          .map(AppNotification.fromJson)
          .toList(),
      nextCursor: data['nextCursor'] as String?,
    );
  });

  Future<int> unreadCount() => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/me/notifications/unread-count',
    );
    return res.data!['count'] as int;
  });

  Future<void> markRead(String id) => _guard(() async {
    await _api.post<void>('/me/notifications/$id/read');
  });

  Future<void> readAll() => _guard(() async {
    await _api.post<Map<String, dynamic>>('/me/notifications/read-all');
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => NotificationsRepository(ref.watch(dioProvider)),
);
