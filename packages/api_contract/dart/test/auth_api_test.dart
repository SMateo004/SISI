import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for AuthApi
void main() {
  final instance = SisiApi().getAuthApi();

  group(AuthApi, () {
    // Cierra la sesión (revoca la familia del refresh token)
    //
    //Future authControllerLogout(RefreshTokenDto refreshTokenDto) async
    test('test authControllerLogout', () async {
      // TODO
    });

    // Renueva la sesión (rota el refresh token)
    //
    // Cada refresh se usa una sola vez. Reutilizar uno ya usado revoca todas las sesiones de esa familia.
    //
    //Future<TokensDto> authControllerRefresh(RefreshTokenDto refreshTokenDto) async
    test('test authControllerRefresh', () async {
      // TODO
    });

    // Envía un código de 6 dígitos al celular
    //
    // La respuesta es la misma tenga o no cuenta el número. Límites: 1 código cada 60 s, 5 por hora y 10 por día por número; 20 por hora por IP.
    //
    //Future<OtpRequestedDto> authControllerRequestOtp(RequestOtpDto requestOtpDto) async
    test('test authControllerRequestOtp', () async {
      // TODO
    });

    // Valida el código e inicia sesión
    //
    // Crea la cuenta si el número no tenía una (modo employer, R1.2).
    //
    //Future<LoginResponseDto> authControllerVerifyOtp(VerifyOtpDto verifyOtpDto) async
    test('test authControllerVerifyOtp', () async {
      // TODO
    });

  });
}
