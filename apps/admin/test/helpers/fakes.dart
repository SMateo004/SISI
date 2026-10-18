import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_admin/app.dart';
import 'package:sisi_admin/core/auth/auth_gateway.dart';
import 'package:sisi_admin/core/auth/session.dart';
import 'package:sisi_admin/core/http/api_client.dart';
import 'package:sisi_admin/core/realtime/counters.dart';
import 'package:sisi_admin/core/router/app_router.dart';
import 'package:sisi_api/sisi_api.dart';

/// Respuesta 200 con datos, como la devuelve el cliente generado.
Response<T> ok<T>(T data) =>
    Response<T>(data: data, statusCode: 200, requestOptions: RequestOptions());

/// Error de la API con ApiErrorBody (code y message en español).
DioException apiError(int status, String code, String message) {
  final options = RequestOptions();
  return DioException(
    requestOptions: options,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: {'statusCode': status, 'code': code, 'message': message},
    ),
    type: DioExceptionType.badResponse,
  );
}

UserDto adminUser({String role = 'admin'}) => UserDto(
  id: 'a1',
  phone: '+59170000001',
  name: 'Ana Admin',
  photoUrl: null,
  role: role == 'admin' ? UserDtoRoleEnum.admin : UserDtoRoleEnum.user,
  activeMode: UserDtoActiveModeEnum.employer,
  cityId: 'c1',
  createdAt: '2026-10-01T12:00:00.000Z',
);

AdminSessionDto adminSession() => AdminSessionDto(
  accessToken: 'token-admin',
  tokenType: AdminSessionDtoTokenTypeEnum.bearer,
  expiresIn: 600,
  sessionExpiresAt: DateTime.now().add(const Duration(hours: 8)),
  user: adminUser(),
);

/// Login falso: la sesión se recupera de la "cookie" si [signedIn].
class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({this.signedIn = true, this.verifyError});

  bool signedIn;
  DioException? verifyError;
  final requested = <String>[];
  int refreshes = 0;

  @override
  Future<int> requestOtp(String phone) async {
    requested.add(phone);
    return 60;
  }

  @override
  Future<AdminSessionDto> verify(String phone, String code) async {
    final error = verifyError;
    if (error != null) throw error;
    signedIn = true;
    return adminSession();
  }

  @override
  Future<AdminSessionDto> refresh() async {
    refreshes++;
    if (!signedIn) {
      throw apiError(401, 'SESSION_INVALID', 'Tu sesión del panel terminó.');
    }
    return adminSession();
  }

  @override
  Future<void> logout() async => signedIn = false;
}

class FakeCountersFeed implements CountersFeed {
  final controller = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get updates => controller.stream;

  @override
  void dispose() {}
}

CountersDto counters({
  int verifications = 0,
  int heldRequests = 0,
  int reports = 0,
  int submissions = 0,
}) => CountersDto(
  verifications: verifications,
  heldRequests: heldRequests,
  heldMessages: 0,
  reports: reports,
  disputes: 0,
  submissions: submissions,
);

/// Cliente generado falso: cada test registra lo que responde cada método (por nombre) y
/// puede revisar con qué se llamó. Lo no registrado falla con un mensaje claro. Los
/// contadores del menú siempre responden.
class FakeApi implements AdminApi {
  FakeApi() {
    on(#dashboardControllerCounters, (_) async => ok(countersValue));
  }

  CountersDto countersValue = counters();
  // Cada handler conserva su tipo (Future<Response<T>>), el que espera el método real.
  final _handlers = <Symbol, Function>{};
  final calls = <(Symbol, Map<Symbol, dynamic>)>[];

  void on<T>(
    Symbol method,
    Future<T> Function(Map<Symbol, dynamic> args) handler,
  ) {
    _handlers[method] = handler;
  }

  /// Argumentos de las llamadas a [method], en orden.
  List<Map<Symbol, dynamic>> callsTo(Symbol method) => [
    for (final (m, args) in calls)
      if (m == method) args,
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final handler = _handlers[invocation.memberName];
    calls.add((invocation.memberName, invocation.namedArguments));
    if (handler == null) {
      return Future<Never>.error(
        StateError('FakeApi: falta ${invocation.memberName}'),
      );
    }
    return Function.apply(handler, [invocation.namedArguments]);
  }
}

/// Monta el panel con el cliente, el login y el socket falsos, y navega a [location].
Future<ProviderContainer> pumpAdmin(
  WidgetTester tester, {
  required AdminApi api,
  FakeAuthGateway? gateway,
  FakeCountersFeed? feed,
  String location = '/',
  Size size = const Size(2200, 1200),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // El scope vive en el árbol: al desmontarse se cancelan los timers del menú.
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authGatewayProvider.overrideWithValue(gateway ?? FakeAuthGateway()),
        adminApiProvider.overrideWithValue(api),
        countersFeedProvider.overrideWithValue(feed ?? FakeCountersFeed()),
      ],
      child: const SisiAdminApp(),
    ),
  );
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(SisiAdminApp)),
  );
  if (location != '/') {
    container.read(appRouterProvider).go(location);
    await tester.pumpAndSettle();
  }
  return container;
}

/// Escribe el motivo y confirma en el diálogo de confirmación.
Future<void> confirmWithReason(
  WidgetTester tester,
  String reason, {
  String? reasonLabel,
}) async {
  if (reasonLabel != null) {
    await tester.tap(find.byKey(const Key('confirm-reason')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(reasonLabel).last);
    await tester.pumpAndSettle();
  }
  await tester.enterText(find.byKey(const Key('confirm-note')), reason);
  await tester.pump();
  await tester.tap(find.byKey(const Key('confirm-submit')));
  await tester.pumpAndSettle();
}
