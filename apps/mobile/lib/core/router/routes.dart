/// Rutas de la app (en español: se ven en la barra de direcciones en web).
abstract final class Routes {
  static const splash = '/cargando';
  static const login = '/ingresar';
  static const otpPath = '/ingresar/codigo';
  static const home = '/';
  static const profile = '/perfil';
  static const serverStatus = '/estado-servidor';
  static const workerOnboarding = '/trabajador/solicitud';
  static const workerStatus = '/trabajador/estado';
  static const myRequests = '/solicitudes';
  static const newRequest = '/solicitudes/nueva';
  static const requestDetailPath = '/solicitudes/:id';

  static String requestDetail(String id) => '/solicitudes/$id';

  static String otp(String phoneDigits, int resendInSec) =>
      '$otpPath?telefono=$phoneDigits&espera=$resendInSec';

  /// Rutas a las que se entra sin sesión.
  static bool isPublic(String location) =>
      location == splash || location == login || location.startsWith(otpPath);
}
