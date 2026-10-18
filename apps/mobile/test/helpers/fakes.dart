import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_mobile/app.dart';
import 'package:sisi_mobile/core/auth/token_storage.dart';
import 'package:sisi_mobile/core/files/picked_image.dart';
import 'package:sisi_mobile/core/http/api_exception.dart';
import 'package:sisi_mobile/features/auth/data/auth_repository.dart';
import 'package:sisi_mobile/features/mode_switch/domain/mode_denial.dart';
import 'package:sisi_mobile/features/profile/data/me_repository.dart';
import 'package:sisi_mobile/features/profile/domain/app_user.dart';
import 'package:sisi_mobile/core/maps/geo_point.dart';
import 'package:sisi_mobile/features/requests/data/requests_repository.dart';
import 'package:sisi_mobile/features/requests/domain/service_request.dart';
import 'package:sisi_mobile/features/worker_onboarding/data/worker_repository.dart';
import 'package:sisi_mobile/features/worker_onboarding/domain/worker_models.dart';
import 'package:sisi_mobile/core/push/push_controller.dart';
import 'package:sisi_mobile/core/realtime/realtime_providers.dart';
import 'package:sisi_mobile/features/matching/data/availability_repository.dart';
import 'package:sisi_mobile/features/matching/data/location_service.dart';
import 'package:sisi_mobile/features/offers/application/employer_live.dart';
import 'package:sisi_mobile/features/offers/data/offers_repository.dart';
import 'package:sisi_mobile/core/links/url_opener.dart';
import 'package:sisi_mobile/features/chat/data/chat_repository.dart';
import 'package:sisi_mobile/features/earnings/data/earnings_repository.dart';
import 'package:sisi_mobile/features/jobs/application/job_providers.dart';
import 'package:sisi_mobile/features/jobs/data/jobs_repository.dart';
import 'package:sisi_mobile/features/notifications/data/notifications_repository.dart';
import 'package:sisi_mobile/features/reports/data/reports_repository.dart';
import 'package:sisi_mobile/features/reviews/data/reviews_repository.dart';

import 'package:sisi_mobile/core/app_gate/client_app_repository.dart';
import 'package:sisi_mobile/core/permissions/permission_primer.dart';
import 'package:sisi_mobile/core/push/notifications_primer.dart';
import 'package:sisi_mobile/features/account_deletion/account_deletion.dart';
import 'package:sisi_mobile/features/pilot/coming_soon_screen.dart';

import 'fake_app.dart';
import 'fake_earnings.dart';
import 'fake_jobs.dart';
import 'fake_matching.dart';
import 'fake_push.dart';
import 'fake_realtime.dart';

const testTokens = AuthTokens(accessToken: 'access', refreshToken: 'refresh');

AppUser testUser({
  ActiveMode mode = ActiveMode.employer,
  String? name = 'María Pérez',
}) => AppUser(id: 'u1', phone: '+59170012345', name: name, activeMode: mode);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.validCode = '123456',
    this.resendInSec = 60,
    this.requestError,
  });

  final String validCode;
  final int resendInSec;
  final requested = <String>[];

  /// Si no es null, pedir el código falla con este error (p. ej. PILOT_NOT_ALLOWED).
  ApiException? requestError;

  @override
  Future<OtpRequested> requestOtp(String phone) async {
    requested.add(phone);
    if (requestError != null) throw requestError!;
    return OtpRequested(expiresInSec: 300, resendInSec: resendInSec);
  }

  @override
  Future<LoginResult> verifyOtp(String phone, String code) async {
    if (code != validCode) {
      throw const ApiException(
        code: 'OTP_INVALID',
        message: 'Código incorrecto o vencido.',
        statusCode: 400,
      );
    }
    return const LoginResult(tokens: testTokens, isNewUser: false);
  }

  @override
  Future<void> logout(String refreshToken) async {}
}

class FakeMeRepository implements MeRepository {
  FakeMeRepository({AppUser? user, this.denial}) : user = user ?? testUser();

  AppUser user;

  /// Si no es null, pasar a worker falla con esta denegación.
  ModeDeniedException? denial;

  @override
  Future<AppUser> getMe() async => user;

  @override
  Future<AppUser> switchMode(ActiveMode mode) async {
    if (mode == ActiveMode.worker && denial != null) throw denial!;
    return user = user.copyWith(activeMode: mode);
  }

  @override
  Future<AppUser> updateName(String name) async => user;

  @override
  Future<AppUser> uploadPhoto(PickedImage image) async => user;
}

class FakeWorkerRepository implements WorkerRepository {
  FakeWorkerRepository({WorkerProfile? profile, this.categories = const []})
    : profile = profile ?? WorkerProfile.empty;

  WorkerProfile profile;
  List<Category> categories;
  Map<String, Object>? submitted;

  @override
  Future<WorkerProfile> getProfile() async => profile;

  @override
  Future<List<Category>> listCategories() async => categories;

  @override
  Future<WorkerProfile> uploadDocument(
    DocumentType type,
    PickedImage image,
  ) async {
    final documents = [
      ...profile.documents.where((d) => d.type != type),
      DocumentStatus(type: type, reviewStatus: 'pendiente'),
    ];
    return profile = WorkerProfile(
      status: profile.status,
      documents: documents,
      missingDocuments: DocumentType.values
          .where((t) => !documents.any((d) => d.type == t))
          .toList(),
      editable: true,
    );
  }

  @override
  Future<WorkerProfile> submit({
    required String birthDate,
    required List<String> categoryIds,
    required TransportMode transport,
    required int maxRadiusKm,
  }) async {
    submitted = {
      'birthDate': birthDate,
      'categoryIds': categoryIds,
      'transport': transport,
      'maxRadiusKm': maxRadiusKm,
    };
    return profile = WorkerProfile(
      status: WorkerStatus.pendienteRevision,
      documents: profile.documents,
      missingDocuments: const [],
      editable: false,
    );
  }
}

class FakeImagePicker implements ImagePickerService {
  @override
  Future<PickedImage?> pick(
    ImageOrigin origin, {
    bool frontCamera = false,
  }) async => PickedImage(
    bytes: Uint8List(1024),
    contentType: 'image/jpeg',
    name: 'foto.jpg',
  );
}

const plomeria = Category(
  id: 'c-plomeria',
  slug: 'plomeria',
  name: 'Plomería',
  priceMinBs: '80.00',
  priceMaxBs: '300.00',
);
const electricidad = Category(
  id: 'c-electricidad',
  slug: 'electricidad',
  name: 'Electricidad',
  priceMinBs: '80.00',
  priceMaxBs: '300.00',
);

ServiceRequest testRequest({
  String id = 'r1',
  RequestStatus status = RequestStatus.buscando,
  String? statusMessage = 'Buscando trabajadores cerca de ti.',
  String price = '150.00',
  int? ring,
  String? jobId,
  DateTime? expiresAt,
}) => ServiceRequest(
  id: id,
  status: status,
  statusMessage: statusMessage,
  category: const RequestCategory(
    id: 'c-plomeria',
    slug: 'plomeria',
    name: 'Plomería',
  ),
  description: 'Tengo una fuga debajo del lavaplatos de la cocina.',
  location: santaCruzCenter,
  address: 'Calle Junín 150',
  proposedPriceBs: price,
  createdAt: DateTime(2026, 10, 15, 10),
  ring: ring,
  jobId: jobId,
  expiresAt: expiresAt,
);

class FakeRequestsRepository implements RequestsRepository {
  FakeRequestsRepository({
    this.categories = const [plomeria, electricidad],
    this.held = false,
    List<ServiceRequest>? mine,
  }) : mine = mine ?? [];

  List<Category> categories;
  bool held;
  List<ServiceRequest> mine;
  NewRequestInput? created;
  int uploadedPhotos = 0;
  final cancelled = <String>[];

  @override
  Future<List<Category>> listCategories() async => categories;

  @override
  Future<String?> reverseGeocode(GeoPoint point) async =>
      'Calle sugerida 123, Santa Cruz de la Sierra';

  @override
  Future<ServiceRequest> createDraft(NewRequestInput input) async {
    created = input;
    return testRequest(id: 'r-nueva', status: RequestStatus.borrador);
  }

  @override
  Future<void> uploadPhoto(String requestId, PickedImage image) async =>
      uploadedPhotos++;

  @override
  Future<PublishResult> publish(String requestId) async {
    final request = testRequest(
      id: requestId,
      status: held ? RequestStatus.retenida : RequestStatus.buscando,
      statusMessage: held
          ? 'Recibimos tu solicitud. La estamos revisando y te avisaremos cuando se publique.'
          : 'Buscando trabajadores cerca de ti.',
    );
    mine = [request, ...mine];
    return PublishResult(
      request: request,
      held: held,
      message: held
          ? 'Recibimos tu solicitud. La estamos revisando y te avisaremos cuando se publique.'
          : '¡Listo! Estamos buscando trabajadores cerca de ti.',
    );
  }

  @override
  Future<ServiceRequest> cancel(String requestId) async {
    cancelled.add(requestId);
    final updated = testRequest(
      id: requestId,
      status: RequestStatus.cancelada,
      statusMessage: 'Cancelaste esta solicitud.',
    );
    mine = [for (final r in mine) r.id == requestId ? updated : r];
    return updated;
  }

  @override
  Future<RequestPage> listMine({String? cursor}) async =>
      RequestPage(items: mine);

  @override
  Future<ServiceRequest> get(String requestId) async =>
      mine.firstWhere((r) => r.id == requestId);
}

/// Monta la app completa (router real) con repositorios falsos.
Future<void> pumpSisiApp(
  WidgetTester tester, {
  AuthTokens? storedTokens,
  FakeAuthRepository? auth,
  FakeMeRepository? me,
  FakeWorkerRepository? worker,
  FakeRequestsRepository? requests,
  FakeRealtimeClient? realtime,
  FakeOffersRepository? offers,
  FakeAvailabilityRepository? availability,
  FakeLocationService? location,
  FakePushService? push,
  FakeDevicesApi? devices,
  FakeJobsRepository? jobs,
  FakeChatRepository? chat,
  FakeReviewsRepository? reviews,
  FakeReportsRepository? reports,
  FakeNotificationsRepository? notifications,
  List<Uri>? openedUrls,
  FakeEarningsRepository? earnings,
  FakeClientAppRepository? clientApp,
  FakeAccountRepository? account,
  FakePilotRepository? pilot,
  PrimerStore? primers,
  bool pushAvailable = false,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.6;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        tokenStorageProvider.overrideWithValue(
          MemoryTokenStorage(storedTokens),
        ),
        authRepositoryProvider.overrideWithValue(auth ?? FakeAuthRepository()),
        meRepositoryProvider.overrideWithValue(me ?? FakeMeRepository()),
        workerRepositoryProvider.overrideWithValue(
          worker ?? FakeWorkerRepository(),
        ),
        imagePickerProvider.overrideWithValue(FakeImagePicker()),
        requestsRepositoryProvider.overrideWithValue(
          requests ?? FakeRequestsRepository(),
        ),
        realtimeClientFactoryProvider.overrideWithValue(
          () => realtime ?? FakeRealtimeClient(),
        ),
        offersRepositoryProvider.overrideWithValue(
          offers ?? FakeOffersRepository(),
        ),
        availabilityRepositoryProvider.overrideWithValue(
          availability ?? FakeAvailabilityRepository(),
        ),
        locationServiceProvider.overrideWithValue(
          location ?? FakeLocationService(),
        ),
        // Sin refresco periódico: con él pumpAndSettle no termina nunca.
        searchRefreshIntervalProvider.overrideWithValue(null),
        pushServiceProvider.overrideWithValue(push ?? FakePushService()),
        devicesApiProvider.overrideWithValue(devices ?? FakeDevicesApi()),
        jobsRepositoryProvider.overrideWithValue(jobs ?? FakeJobsRepository()),
        chatRepositoryProvider.overrideWithValue(chat ?? FakeChatRepository()),
        reviewsRepositoryProvider.overrideWithValue(
          reviews ?? FakeReviewsRepository(),
        ),
        reportsRepositoryProvider.overrideWithValue(
          reports ?? FakeReportsRepository(),
        ),
        notificationsRepositoryProvider.overrideWithValue(
          notifications ?? FakeNotificationsRepository(),
        ),
        earningsRepositoryProvider.overrideWithValue(
          earnings ?? FakeEarningsRepository(),
        ),
        clientAppRepositoryProvider.overrideWithValue(
          clientApp ?? FakeClientAppRepository(),
        ),
        accountRepositoryProvider.overrideWithValue(
          account ?? FakeAccountRepository(),
        ),
        pilotRepositoryProvider.overrideWithValue(
          pilot ?? FakePilotRepository(),
        ),
        // Avisos y cámara ya explicados: las pruebas que no los miran no ven diálogos.
        primerStoreProvider.overrideWithValue(
          primers ??
              MemoryPrimerStore({
                PrimedPermission.notifications: PrimerAnswer.accepted,
                PrimedPermission.camera: PrimerAnswer.accepted,
              }),
        ),
        pushAvailableProvider.overrideWithValue(pushAvailable),
        // Sin envío periódico de ubicación (pumpAndSettle no terminaría).
        tripLocationIntervalProvider.overrideWithValue(null),
        urlOpenerProvider.overrideWithValue((uri) async {
          openedUrls?.add(uri);
          return true;
        }),
      ],
      child: const SisiApp(),
    ),
  );
  await tester.pumpAndSettle();
}
