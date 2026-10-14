import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/worker_models.dart';

/// Pasos del flujo de upgrade (R1.3).
enum OnboardingStep {
  data('Tus datos'),
  documents('Carnet y selfie'),
  categories('Categorías'),
  transport('Transporte y radio'),
  summary('Resumen');

  const OnboardingStep(this.title);

  final String title;
}

/// Datos que la persona va completando antes de enviar.
class OnboardingDraft {
  const OnboardingDraft({
    this.step = OnboardingStep.data,
    this.birthDate,
    this.categoryIds = const {},
    this.transport,
    this.radiusKm = 5,
  });

  final OnboardingStep step;
  final DateTime? birthDate;
  final Set<String> categoryIds;
  final TransportMode? transport;
  final int radiusKm;

  OnboardingDraft copyWith({
    OnboardingStep? step,
    DateTime? birthDate,
    Set<String>? categoryIds,
    TransportMode? transport,
    int? radiusKm,
  }) => OnboardingDraft(
    step: step ?? this.step,
    birthDate: birthDate ?? this.birthDate,
    categoryIds: categoryIds ?? this.categoryIds,
    transport: transport ?? this.transport,
    radiusKm: radiusKm ?? this.radiusKm,
  );

  /// 'AAAA-MM-DD' para la API.
  String? get birthDateIso => birthDate == null
      ? null
      : '${birthDate!.year.toString().padLeft(4, '0')}-'
            '${birthDate!.month.toString().padLeft(2, '0')}-'
            '${birthDate!.day.toString().padLeft(2, '0')}';
}

/// Edad cumplida a la fecha `today` (la API valida de nuevo con la hora de Bolivia).
int ageOn(DateTime birth, DateTime today) {
  final hadBirthday =
      today.month > birth.month ||
      (today.month == birth.month && today.day >= birth.day);
  return today.year - birth.year - (hadBirthday ? 0 : 1);
}

class OnboardingController extends Notifier<OnboardingDraft> {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  /// Completa el borrador con lo que ya tenía el perfil (p. ej. tras un rechazo).
  void prefill(WorkerProfile profile) {
    final birth = profile.birthDate == null
        ? null
        : DateTime.tryParse(profile.birthDate!);
    state = state.copyWith(
      birthDate: birth,
      categoryIds: profile.categoryIds.toSet(),
      transport: profile.transport,
      radiusKm: profile.maxRadiusKm,
    );
  }

  void setBirthDate(DateTime date) => state = state.copyWith(birthDate: date);

  void toggleCategory(String id) {
    final ids = {...state.categoryIds};
    ids.contains(id) ? ids.remove(id) : ids.add(id);
    state = state.copyWith(categoryIds: ids);
  }

  void setTransport(TransportMode mode) =>
      state = state.copyWith(transport: mode);

  void setRadius(int km) =>
      state = state.copyWith(radiusKm: km.clamp(minRadiusKm, maxRadiusKm));

  void goTo(OnboardingStep step) => state = state.copyWith(step: step);

  void next() {
    final i = state.step.index;
    if (i < OnboardingStep.values.length - 1) {
      goTo(OnboardingStep.values[i + 1]);
    }
  }

  void back() {
    final i = state.step.index;
    if (i > 0) goTo(OnboardingStep.values[i - 1]);
  }
}

final onboardingProvider =
    NotifierProvider.autoDispose<OnboardingController, OnboardingDraft>(
      OnboardingController.new,
    );
