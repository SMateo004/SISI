import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';

import '../http/api_client.dart';
import '../http/api_error.dart';
import 'auth_gateway.dart';

/// Estado de la sesión del panel (ADR-0040). El token de acceso vive solo en memoria; al
/// recargar la página se recupera con el refresh de la cookie httpOnly.
sealed class SessionState {
  const SessionState();
}

/// Recuperando la sesión al abrir el panel.
class SessionRestoring extends SessionState {
  const SessionRestoring();
}

class SignedOut extends SessionState {
  const SignedOut([this.message]);

  /// Por qué terminó (sesión vencida, cuenta sin acceso…), si corresponde.
  final String? message;
}

class SignedIn extends SessionState {
  const SignedIn(this.session, this.accessExpiresAt);

  final AdminSessionDto session;
  final DateTime accessExpiresAt;

  UserDto get user => session.user;
}

/// Login, refresh y logout por HTTP (los tests lo reemplazan por uno falso).
final authGatewayProvider = Provider<AuthGateway>(
  (ref) => DioAuthGateway(ref.watch(publicDioProvider)),
);

final sessionProvider = NotifierProvider<SessionController, SessionState>(
  SessionController.new,
);

class SessionController extends Notifier<SessionState> {
  Future<String?>? _refreshing;

  AuthGateway get _gateway => ref.read(authGatewayProvider);

  @override
  SessionState build() {
    unawaited(Future.microtask(restore));
    return const SessionRestoring();
  }

  /// Al abrir el panel: si la cookie sigue vigente, entra sin pedir el código.
  Future<void> restore() async {
    try {
      _signIn(await _gateway.refresh());
    } catch (_) {
      state = const SignedOut();
    }
  }

  /// Usuario del panel y código de 6 dígitos de la app autenticadora (ADR-0055).
  Future<void> login(String username, String code) async {
    _signIn(await _gateway.login(username, code));
  }

  Future<void> logout() async {
    try {
      await _gateway.logout();
    } finally {
      state = const SignedOut();
    }
  }

  /// Token de acceso vigente. Lo renueva si venció (o si [forceRefresh]); una sola
  /// renovación a la vez. null = la sesión terminó.
  Future<String?> accessToken({bool forceRefresh = false}) async {
    final current = state;
    if (current is! SignedIn) return null;
    final fresh = DateTime.now().isBefore(
      current.accessExpiresAt.subtract(const Duration(seconds: 20)),
    );
    if (fresh && !forceRefresh) return current.session.accessToken;
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<String?> _refresh() async {
    try {
      final session = await _gateway.refresh();
      _signIn(session);
      return session.accessToken;
    } catch (error) {
      final api = ApiError.from(error);
      state = SignedOut(
        api.status == 401
            ? 'Tu sesión del panel terminó. Vuelve a ingresar.'
            : api.message,
      );
      return null;
    }
  }

  void _signIn(AdminSessionDto session) {
    state = SignedIn(
      session,
      DateTime.now().add(Duration(seconds: session.expiresIn.toInt())),
    );
  }
}
