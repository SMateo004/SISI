import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/health/presentation/health_screen.dart';

abstract final class AppRoutes {
  static const String home = '/';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HealthScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
