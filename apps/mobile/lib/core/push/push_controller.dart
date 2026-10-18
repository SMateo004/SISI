import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import '../http/api_client.dart';
import '../router/app_router.dart';
import '../permissions/permission_primer.dart';
import 'notifications_primer.dart';
import 'push_service.dart';

final pushServiceProvider = Provider<PushService>(
  (ref) => FirebasePushService(),
);

/// Alta y baja del token del dispositivo en la API (`/me/devices`).
class DevicesApi {
  DevicesApi(this._api);

  final Dio _api;

  Future<void> register(String token, String platform) => _api.post<void>(
    '/me/devices',
    data: {'token': token, 'platform': platform},
  );

  Future<void> unregister(String token) =>
      _api.delete<void>('/me/devices/${Uri.encodeComponent(token)}');
}

final devicesApiProvider = Provider<DevicesApi>(
  (ref) => DevicesApi(ref.watch(dioProvider)),
);

/// Para mostrar avisos push que llegan con la app abierta.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Pantallas que un push puede abrir (la ruta viene del backend; se valida igual).
bool isPushRoute(String? route) =>
    route != null &&
    (route.startsWith('/solicitudes/') ||
        route.startsWith('/trabajo/solicitudes/') ||
        route.startsWith('/trabajos/') ||
        route == '/ganancias' ||
        route.startsWith('/ganancias/') ||
        route == '/trabajador/estado');

/// Registra el token de push mientras hay sesión y abre la pantalla correcta al tocar
/// un aviso (ADR-0027).
class PushController {
  PushController(this._ref);

  final Ref _ref;
  final _subs = <StreamSubscription<dynamic>>[];
  String? _token;

  PushService get _push => _ref.read(pushServiceProvider);
  DevicesApi get _devices => _ref.read(devicesApiProvider);

  Future<void> start() async {
    final platform = pushPlatform();
    if (platform == null) return;
    try {
      final token = await _push.start();
      if (token != null) await _register(token, platform);
      _subs.add(_push.tokenRefresh.listen((t) => _register(t, platform)));
      _subs.add(_push.opened.listen(_open));
      _subs.add(_push.foreground.listen(_showInApp));
      final initial = await _push.initialMessage();
      if (initial != null) _open(initial);
    } catch (e) {
      // Sin push la app funciona igual (el socket y la bandeja cubren lo esencial).
      debugPrint('Push no disponible: $e');
    }
  }

  Future<void> _register(String token, String platform) async {
    _token = token;
    await _devices.register(token, platform);
  }

  /// Al cerrar sesión, antes de borrar los tokens: el dispositivo deja de recibir avisos.
  Future<void> unregister() async {
    final token = _token ?? await _push.currentToken().catchError((_) => null);
    if (token == null) return;
    try {
      await _devices.unregister(token);
    } catch (_) {
      // Si falla, el backend lo borrará cuando FCM lo declare inválido.
    }
    _token = null;
  }

  void _open(PushMessage message) {
    final route = message.route;
    if (isPushRoute(route)) _ref.read(appRouterProvider).push(route!);
  }

  void _showInApp(PushMessage message) {
    final route = message.route;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          [message.title, message.body].whereType<String>().join(' · '),
        ),
        action: isPushRoute(route)
            ? SnackBarAction(label: 'Ver', onPressed: () => _open(message))
            : null,
      ),
    );
  }

  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
  }
}

/// Activo mientras hay sesión y la persona aceptó la explicación de los avisos (ADR-0051):
/// recién entonces se pide el permiso del sistema.
final pushControllerProvider = Provider<PushController?>((ref) {
  if (ref.watch(sessionProvider) != SessionStatus.authenticated) return null;
  final primer = ref.watch(notificationsPrimerProvider).value;
  if (primer != PrimerAnswer.accepted) return null;
  final controller = PushController(ref);
  ref.onDispose(controller.dispose);
  controller.start();
  return controller;
});
