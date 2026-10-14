import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'token_storage.dart';

enum SessionStatus { unknown, authenticated, unauthenticated }

/// Estado de la sesión. Los tokens viven en memoria y en [TokenStorage].
class SessionController extends Notifier<SessionStatus> {
  AuthTokens? _tokens;

  AuthTokens? get tokens => _tokens;

  @override
  SessionStatus build() {
    Future.microtask(_restore);
    return SessionStatus.unknown;
  }

  Future<void> _restore() async {
    _tokens = await ref.read(tokenStorageProvider).read();
    state = _tokens == null
        ? SessionStatus.unauthenticated
        : SessionStatus.authenticated;
  }

  Future<void> signIn(AuthTokens tokens) async {
    _tokens = tokens;
    await ref.read(tokenStorageProvider).write(tokens);
    state = SessionStatus.authenticated;
  }

  /// Guarda el par nuevo tras un refresh (rotación).
  Future<void> updateTokens(AuthTokens tokens) async {
    _tokens = tokens;
    await ref.read(tokenStorageProvider).write(tokens);
  }

  Future<void> signOut() async {
    _tokens = null;
    await ref.read(tokenStorageProvider).clear();
    state = SessionStatus.unauthenticated;
  }
}

final sessionProvider = NotifierProvider<SessionController, SessionStatus>(
  SessionController.new,
);
