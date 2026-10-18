import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/session_controller.dart';
import 'client_app_repository.dart';

/// Lo que puede impedir usar la app antes de cualquier pantalla (ADR-0051, ADR-0054):
/// una versión vieja ("Actualiza la app") o textos legales sin aceptar.
class AppGate {
  const AppGate({
    this.upgradeRequired = false,
    this.storeUrl,
    this.support,
    this.legalPending,
  });

  final bool upgradeRequired;
  final String? storeUrl;
  final SupportInfo? support;

  /// null mientras no se sabe (sin sesión o cargando); vacío = todo aceptado.
  final List<String>? legalPending;

  bool get mustAcceptLegal => legalPending?.isNotEmpty ?? false;

  AppGate copyWith({
    bool? upgradeRequired,
    String? storeUrl,
    SupportInfo? support,
    List<String>? legalPending,
    bool clearLegal = false,
  }) => AppGate(
    upgradeRequired: upgradeRequired ?? this.upgradeRequired,
    storeUrl: storeUrl ?? this.storeUrl,
    support: support ?? this.support,
    legalPending: clearLegal ? null : (legalPending ?? this.legalPending),
  );
}

class AppGateController extends Notifier<AppGate> {
  @override
  AppGate build() {
    Future.microtask(loadConfig);
    // Con sesión, qué textos faltan aceptar; sin sesión, nada.
    ref.listen(sessionProvider, (_, next) {
      if (next == SessionStatus.authenticated) {
        refreshLegal();
      } else {
        state = state.copyWith(clearLegal: true);
      }
    });
    if (ref.read(sessionProvider) == SessionStatus.authenticated) {
      Future.microtask(refreshLegal);
    }
    return const AppGate();
  }

  ClientAppRepository get _repo => ref.read(clientAppRepositoryProvider);

  /// Versión mínima y soporte. Sin red se sigue: la API igual responde 426 si hace falta.
  Future<void> loadConfig() async {
    try {
      final config = await _repo.config();
      state = state.copyWith(
        upgradeRequired: config.upgradeRequired,
        storeUrl: config.storeUrl,
        support: config.support,
      );
    } catch (_) {}
  }

  Future<void> refreshLegal() async {
    try {
      // Primero el resultado y después el estado: si no, se pisa lo que cambió mientras tanto.
      final pending = await _repo.legalPending();
      state = state.copyWith(legalPending: pending);
    } catch (_) {}
  }

  /// La API respondió 426 APP_UPGRADE_REQUIRED.
  void upgradeRequired(String? storeUrl) =>
      state = state.copyWith(upgradeRequired: true, storeUrl: storeUrl);

  /// La API respondió 403 LEGAL_ACCEPTANCE_REQUIRED (p. ej. salió una versión nueva).
  void legalRequired(List<String> pending) => state = state.copyWith(
    legalPending: pending.isEmpty ? const ['terms', 'privacy'] : pending,
  );

  void legalAccepted() => state = state.copyWith(legalPending: const []);
}

final appGateProvider = NotifierProvider<AppGateController, AppGate>(
  AppGateController.new,
);
