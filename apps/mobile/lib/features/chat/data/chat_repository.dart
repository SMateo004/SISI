import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';
import '../domain/chat_models.dart';

/// Chat del trabajo (ADR-0031).
class ChatRepository {
  ChatRepository(this._api);

  final Dio _api;

  Future<ChatPage> list(String jobId, {String? cursor}) => _guard(() async {
    final res = await _api.get<Map<String, dynamic>>(
      '/jobs/$jobId/messages',
      queryParameters: {'cursor': ?cursor},
    );
    return ChatPage.fromJson(res.data!);
  });

  Future<SentMessage> send(String jobId, String body) => _guard(() async {
    final res = await _api.post<Map<String, dynamic>>(
      '/jobs/$jobId/messages',
      data: {'body': body},
    );
    return SentMessage.fromJson(res.data!);
  });

  Future<void> markRead(String jobId, String upToId) => _guard(() async {
    await _api.post<Map<String, dynamic>>(
      '/jobs/$jobId/messages/read',
      data: {'upToId': upToId},
    );
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(dioProvider)),
);
