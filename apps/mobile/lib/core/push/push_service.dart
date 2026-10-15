import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';

/// Un aviso push recibido (ADR-0027). `route` es la pantalla a abrir.
class PushMessage {
  const PushMessage({this.title, this.body, this.data = const {}});

  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  String? get route => data['route'] as String?;
}

/// Plataforma para la API (`POST /me/devices`).
String? pushPlatform() {
  if (kIsWeb) return 'web';
  if (defaultTargetPlatform == TargetPlatform.android) return 'android';
  // iOS queda pendiente hasta tener la cuenta de Apple (APNs).
  return null;
}

/// Push del dispositivo. Sin configuración de Firebase (local, tests) no hace nada.
abstract class PushService {
  /// Pide permiso y devuelve el token, o null si no hay push.
  Future<String?> start();

  /// Token nuevo (FCM los rota).
  Stream<String> get tokenRefresh;

  /// Aviso tocado por el usuario (app en segundo plano o cerrada).
  Stream<PushMessage> get opened;

  /// Aviso recibido con la app abierta (no se muestra solo).
  Stream<PushMessage> get foreground;

  /// El aviso con el que se abrió la app desde cerrada, si hubo.
  Future<PushMessage?> initialMessage();

  Future<String?> currentToken();
}

class NoPushService implements PushService {
  @override
  Future<String?> start() async => null;

  @override
  Stream<String> get tokenRefresh => const Stream.empty();

  @override
  Stream<PushMessage> get opened => const Stream.empty();

  @override
  Stream<PushMessage> get foreground => const Stream.empty();

  @override
  Future<PushMessage?> initialMessage() async => null;

  @override
  Future<String?> currentToken() async => null;
}

/// FCM en Android y web, configurado por `--dart-define` (ADR-0027).
class FirebasePushService implements PushService {
  bool _ready = false;

  PushMessage _toMessage(RemoteMessage m) => PushMessage(
    title: m.notification?.title,
    body: m.notification?.body,
    data: m.data,
  );

  Future<FirebaseMessaging?> _messaging() async {
    if (!Env.pushConfigured || pushPlatform() == null) return null;
    if (!_ready) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: Env.firebaseApiKey,
          appId: Env.firebaseAppId,
          messagingSenderId: Env.firebaseSenderId,
          projectId: Env.firebaseProjectId,
        ),
      );
      _ready = true;
    }
    return FirebaseMessaging.instance;
  }

  @override
  Future<String?> start() async {
    final messaging = await _messaging();
    if (messaging == null) return null;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return null;
    return currentToken();
  }

  @override
  Future<String?> currentToken() async {
    final messaging = await _messaging();
    if (messaging == null) return null;
    return messaging.getToken(
      vapidKey: kIsWeb && Env.firebaseVapidKey.isNotEmpty
          ? Env.firebaseVapidKey
          : null,
    );
  }

  @override
  Stream<String> get tokenRefresh => Env.pushConfigured
      ? FirebaseMessaging.instance.onTokenRefresh
      : const Stream.empty();

  @override
  Stream<PushMessage> get opened => Env.pushConfigured
      ? FirebaseMessaging.onMessageOpenedApp.map(_toMessage)
      : const Stream.empty();

  @override
  Stream<PushMessage> get foreground => Env.pushConfigured
      ? FirebaseMessaging.onMessage.map(_toMessage)
      : const Stream.empty();

  @override
  Future<PushMessage?> initialMessage() async {
    final messaging = await _messaging();
    if (messaging == null) return null;
    final m = await messaging.getInitialMessage();
    return m == null ? null : _toMessage(m);
  }
}
