import 'package:sisi_mobile/core/app_gate/client_app_repository.dart';
import 'package:sisi_mobile/core/http/api_exception.dart';
import 'package:sisi_mobile/features/account_deletion/account_deletion.dart';
import 'package:sisi_mobile/features/pilot/coming_soon_screen.dart';

/// Configuración de la app y textos legales en memoria (ADR-0051, ADR-0054).
class FakeClientAppRepository implements ClientAppRepository {
  FakeClientAppRepository({
    this.upgradeRequired = false,
    this.storeUrl,
    this.support,
    List<String>? legalPending,
    this.draft = true,
  }) : pending = legalPending ?? const [];

  bool upgradeRequired;
  String? storeUrl;
  SupportInfo? support;
  List<String> pending;
  bool draft;
  int termsVersion = 1;
  final accepted = <(int, int)>[];

  @override
  Future<AppConfig> config() async => AppConfig(
    minVersion: upgradeRequired ? '9.9.9' : '0.0.0',
    upgradeRequired: upgradeRequired,
    storeUrl: storeUrl,
    support: support,
  );

  @override
  Future<List<LegalDocument>> legalDocuments() async => [
    LegalDocument(
      type: 'terms',
      version: termsVersion,
      title: 'Términos de uso',
      content: '# Términos de uso\n\n- Debes ser mayor de 18 años.',
      draft: draft,
    ),
    LegalDocument(
      type: 'privacy',
      version: 1,
      title: 'Política de privacidad',
      content: '# Política de privacidad\n\nQué datos recolectamos.',
      draft: draft,
    ),
  ];

  @override
  Future<List<String>> legalPending() async => pending;

  @override
  Future<void> acceptLegal({
    required int termsVersion,
    required int privacyVersion,
  }) async {
    accepted.add((termsVersion, privacyVersion));
    pending = const [];
  }
}

/// Eliminación de cuenta en memoria (ADR-0049).
class FakeAccountRepository implements AccountRepository {
  FakeAccountRepository({this.blockers = const []});

  final List<DeletionBlocker> blockers;
  int codesSent = 0;
  final deletedWith = <String>[];

  @override
  Future<DeletionCheck> check() async => DeletionCheck(
    canDelete: blockers.isEmpty,
    blockers: blockers,
    erased: const ['Tu nombre, tu número de celular y tu foto'],
    kept: const ['Los movimientos de comisión y pagos'],
  );

  @override
  Future<void> sendCode() async => codesSent++;

  @override
  Future<void> delete(String code) async {
    if (code != '123456') {
      throw const ApiException(
        code: 'OTP_INVALID',
        message: 'El código no es correcto.',
      );
    }
    deletedWith.add(code);
  }
}

/// "Pronto en tu zona" en memoria (ADR-0052).
class FakePilotRepository implements PilotRepository {
  final interests = <(String, String, String?)>[];

  @override
  Future<void> registerInterest({
    required String phone,
    required String role,
    String? zone,
  }) async => interests.add((phone, role, zone));
}
