import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/moderation/dispute_screen.dart';
import '../../features/moderation/moderation_screen.dart';
import '../../features/verifications/verification_detail_screen.dart';
import '../../features/verifications/verifications_screen.dart';
import '../auth/session.dart';
import '../widgets/admin_shell.dart';

abstract final class AppRoutes {
  static const login = '/ingresar';
  static const loading = '/cargando';
  static const home = '/';
}

/// Avisa al router cuando cambia la sesión, para que vuelva a evaluar el redirect.
class _SessionListenable extends ChangeNotifier {
  void notify() => notifyListeners();
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _SessionListenable();
  ref.listen(sessionProvider, (_, _) => listenable.notify());
  final router = GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: listenable,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final at = state.matchedLocation;
      if (session is SessionRestoring) {
        return at == AppRoutes.loading ? null : AppRoutes.loading;
      }
      if (session is SignedOut) {
        return at == AppRoutes.login ? null : AppRoutes.login;
      }
      if (at == AppRoutes.login || at == AppRoutes.loading) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.loading,
        builder: (_, _) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) =>
            AdminShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (_, _) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/verificaciones',
            builder: (_, _) => const VerificationsScreen(),
            routes: [
              GoRoute(
                path: ':userId',
                builder: (_, s) => VerificationDetailScreen(
                  userId: s.pathParameters['userId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/moderacion',
            redirect: (_, _) => '/moderacion/retenidas',
          ),
          GoRoute(
            path: '/moderacion/disputas/:jobId',
            builder: (_, s) => DisputeScreen(jobId: s.pathParameters['jobId']!),
          ),
          GoRoute(
            path: '/moderacion/:tab',
            builder: (_, s) => ModerationScreen(tab: s.pathParameters['tab']!),
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
