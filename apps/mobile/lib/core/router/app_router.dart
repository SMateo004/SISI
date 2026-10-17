import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/otp_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/auth/presentation/phone_screen.dart';
import '../../features/health/presentation/health_screen.dart';
import '../../features/earnings/presentation/earnings_screen.dart';
import '../../features/earnings/presentation/pay_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/jobs/presentation/job_history_screen.dart';
import '../../features/jobs/presentation/job_screen.dart';
import '../../features/matching/presentation/incoming_request_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/requests/presentation/my_requests_screen.dart';
import '../../features/requests/presentation/new_request_flow_screen.dart';
import '../../features/requests/domain/service_request.dart';
import '../../features/requests/presentation/request_detail_screen.dart';
import '../../features/worker_onboarding/presentation/onboarding_flow_screen.dart';
import '../../features/worker_onboarding/presentation/review_status_screen.dart';
import '../auth/session_controller.dart';
import 'routes.dart';

/// Redirección según la sesión: sin sesión todo lleva a /ingresar; con sesión,
/// las pantallas de login llevan al inicio.
String? sessionRedirect(SessionStatus session, String location) {
  final public = Routes.isPublic(location);
  return switch (session) {
    SessionStatus.unknown => location == Routes.splash ? null : Routes.splash,
    SessionStatus.unauthenticated =>
      public && location != Routes.splash ? null : Routes.login,
    SessionStatus.authenticated => public ? Routes.home : null,
  };
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<SessionStatus>(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => refresh.value = next);

  final router = GoRouter(
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: (context, state) =>
        sessionRedirect(ref.read(sessionProvider), state.matchedLocation),
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const PhoneScreen(),
      ),
      GoRoute(
        path: Routes.otpPath,
        builder: (context, state) => OtpScreen(
          phoneDigits: state.uri.queryParameters['telefono'] ?? '',
          resendInSec:
              int.tryParse(state.uri.queryParameters['espera'] ?? '') ?? 60,
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.serverStatus,
        builder: (context, state) => const HealthScreen(),
      ),
      GoRoute(
        path: Routes.workerOnboarding,
        builder: (context, state) => const OnboardingFlowScreen(),
      ),
      GoRoute(
        path: Routes.workerStatus,
        builder: (context, state) => const ReviewStatusScreen(),
      ),
      GoRoute(
        path: Routes.myRequests,
        builder: (context, state) => const MyRequestsScreen(),
      ),
      // Antes que /solicitudes/:id para que "nueva" no se tome como id.
      GoRoute(
        path: Routes.newRequest,
        builder: (context, state) =>
            NewRequestFlowScreen(seed: state.extra as RepublishSeed?),
      ),
      GoRoute(
        path: Routes.requestDetailPath,
        builder: (context, state) => RequestDetailScreen(
          requestId: state.pathParameters['id']!,
          notice: state.extra as String?,
        ),
      ),
      GoRoute(
        path: Routes.incomingRequestPath,
        builder: (context, state) =>
            IncomingRequestScreen(requestId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.jobsPath,
        builder: (context, state) => JobHistoryScreen(
          role: state.uri.queryParameters['rol'] == 'trabajador'
              ? 'worker'
              : 'employer',
        ),
      ),
      // El contacto ahora vive en la pantalla del trabajo (enlaces viejos y push).
      GoRoute(
        path: Routes.jobContactPath,
        redirect: (context, state) => Routes.job(state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.jobChatPath,
        builder: (context, state) =>
            ChatScreen(jobId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.jobPath,
        builder: (context, state) =>
            JobScreen(jobId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.earnings,
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(path: Routes.pay, builder: (context, state) => const PayScreen()),
      GoRoute(
        path: Routes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
});
