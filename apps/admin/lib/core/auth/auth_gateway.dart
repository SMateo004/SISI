import 'package:dio/dio.dart';
import 'package:sisi_api/sisi_api.dart';

/// Login, refresh y logout del panel (ADR-0040). Se ingresa con el usuario del panel y el
/// código de una app autenticadora, sin teléfono (ADR-0055). El refresh viaja solo en la
/// cookie httpOnly; el panel nunca lo ve.
abstract interface class AuthGateway {
  Future<AdminSessionDto> login(String username, String code);
  Future<AdminSessionDto> refresh();
  Future<void> logout();
}

/// Header CSRF obligatorio en refresh y logout.
const _csrf = '1';

class DioAuthGateway implements AuthGateway {
  DioAuthGateway(Dio dio)
    : _api = SisiApi(dio: dio, interceptors: const []).getAuthApi();

  final AuthApi _api;

  @override
  Future<AdminSessionDto> login(String username, String code) async {
    final res = await _api.adminAuthControllerLogin(
      adminLoginDto: AdminLoginDto(username: username, code: code),
    );
    return res.data!;
  }

  @override
  Future<AdminSessionDto> refresh() async {
    final res = await _api.adminAuthControllerRefresh(xSISIAdmin: _csrf);
    return res.data!;
  }

  @override
  Future<void> logout() async {
    await _api.adminAuthControllerLogout(xSISIAdmin: _csrf);
  }
}
