import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/files/picked_image.dart';
import '../data/me_repository.dart';
import '../domain/app_user.dart';

/// Cuenta del usuario con sesión iniciada. Se recarga al cambiar la sesión.
class CurrentUserController extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final session = ref.watch(sessionProvider);
    if (session != SessionStatus.authenticated) return null;
    return ref.read(meRepositoryProvider).getMe();
  }

  Future<void> updateName(String name) async {
    state = AsyncData(await ref.read(meRepositoryProvider).updateName(name));
  }

  Future<void> uploadPhoto(PickedImage image) async {
    state = AsyncData(await ref.read(meRepositoryProvider).uploadPhoto(image));
  }

  /// Lanza ModeDeniedException con el motivo si no se puede cambiar.
  Future<void> switchMode(ActiveMode mode) async {
    state = AsyncData(await ref.read(meRepositoryProvider).switchMode(mode));
  }
}

final currentUserProvider =
    AsyncNotifierProvider<CurrentUserController, AppUser?>(
      CurrentUserController.new,
      retry: (retryCount, error) => null,
    );
