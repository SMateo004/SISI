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
  static const incomingRequestPath = '/trabajo/solicitudes/:id';
  static const jobContactPath = '/trabajos/:id/contacto';

  static String requestDetail(String id) => '/solicitudes/$id';

  /// Solicitud que le llegó al trabajador (también la abre el push).
  static String incomingRequest(String id) => '/trabajo/solicitudes/$id';

  /// Contacto revelado tras la elección (R5.4).
  static String jobContact(String jobId) => '/trabajos/$jobId/contacto';

  static String otp(String phoneDigits, int resendInSec) =>
      '$otpPath?telefono=$phoneDigits&espera=$resendInSec';

  /// Rutas a las que se entra sin sesión.
  static bool isPublic(String location) =>
      location == splash || location == login || location.startsWith(otpPath);
}
