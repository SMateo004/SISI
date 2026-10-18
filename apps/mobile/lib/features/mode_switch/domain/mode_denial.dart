import '../../../core/http/api_exception.dart';

/// Acción siguiente que sugiere la API cuando no se puede pasar a modo trabajador.
enum NextAction {
  completeVerification,
  viewReviewStatus,
  resubmitVerification,
  payCommission,
  contactSupport,

  /// Cargar el nombre en el perfil (R1.3 ampliada).
  completeProfile,
  unknown;

  static NextAction fromApi(String? value) => switch (value) {
    'COMPLETE_VERIFICATION' => completeVerification,
    'VIEW_REVIEW_STATUS' => viewReviewStatus,
    'RESUBMIT_VERIFICATION' => resubmitVerification,
    'PAY_COMMISSION' => payCommission,
    'CONTACT_SUPPORT' => contactSupport,
    'COMPLETE_PROFILE' => completeProfile,
    _ => unknown,
  };
}

/// Respuesta 409 de PATCH /me/mode (R1.5): motivo y acción siguiente.
class ModeDeniedException extends ApiException {
  ModeDeniedException({
    required super.code,
    required super.message,
    required this.nextAction,
    required this.actionLabel,
  }) : super(statusCode: 409);

  factory ModeDeniedException.fromApi(ApiException e) => ModeDeniedException(
    code: e.code,
    message: e.message,
    nextAction: NextAction.fromApi(e.extra['nextAction'] as String?),
    actionLabel: (e.extra['actionLabel'] as String?) ?? 'Entendido',
  );

  final NextAction nextAction;
  final String actionLabel;
}
