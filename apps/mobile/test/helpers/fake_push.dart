import 'dart:async';

import 'package:sisi_mobile/core/push/push_controller.dart';
import 'package:sisi_mobile/core/push/push_service.dart';

class FakePushService implements PushService {
  FakePushService({this.token});

  final String? token;
  final _refresh = StreamController<String>.broadcast();
  final _opened = StreamController<PushMessage>.broadcast();
  final _foreground = StreamController<PushMessage>.broadcast();
  PushMessage? initial;

  @override
  Future<String?> start() async => token;

  @override
  Future<String?> currentToken() async => token;

  @override
  Stream<String> get tokenRefresh => _refresh.stream;

  @override
  Stream<PushMessage> get opened => _opened.stream;

  @override
  Stream<PushMessage> get foreground => _foreground.stream;

  @override
  Future<PushMessage?> initialMessage() async => initial;

  void tap(String route) => _opened.add(PushMessage(data: {'route': route}));

  void receive(String title, String body, String route) => _foreground.add(
    PushMessage(title: title, body: body, data: {'route': route}),
  );

  void rotate(String newToken) => _refresh.add(newToken);
}

class FakeDevicesApi implements DevicesApi {
  final registered = <(String, String)>[];
  final unregistered = <String>[];

  @override
  Future<void> register(String token, String platform) async =>
      registered.add((token, platform));

  @override
  Future<void> unregister(String token) async => unregistered.add(token);
}
