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
import 'package:sisi_mobile/features/worker_onboarding/data/worker_repository.dart';
import 'package:sisi_mobile/features/worker_onboarding/domain/worker_models.dart';

const testTokens = AuthTokens(accessToken: 'access', refreshToken: 'refresh');

AppUser testUser({
  ActiveMode mode = ActiveMode.employer,
  String? name = 'María Pérez',
}) => AppUser(id: 'u1', phone: '+59170012345', name: name, activeMode: mode);

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.validCode = '123456', this.resendInSec = 60});

  final String validCode;
  final int resendInSec;
  final requested = <String>[];

  @override
  Future<OtpRequested> requestOtp(String phone) async {
    requested.add(phone);
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

/// Monta la app completa (router real) con repositorios falsos.
Future<void> pumpSisiApp(
  WidgetTester tester, {
  AuthTokens? storedTokens,
  FakeAuthRepository? auth,
  FakeMeRepository? me,
  FakeWorkerRepository? worker,
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
      ],
      child: const SisiApp(),
    ),
  );
  await tester.pumpAndSettle();
}
