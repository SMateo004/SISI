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
  static const jobsPath = '/trabajos';
  static const jobPath = '/trabajos/:id';
  static const jobChatPath = '/trabajos/:id/chat';
  static const notifications = '/avisos';
  static const earnings = '/ganancias';
  static const pay = '/ganancias/pagar';

  /// Aceptar los textos legales vigentes (bloqueante, ADR-0051).
  static const legal = '/legal';
  static const legalDocumentPath = '/legal/:tipo';

  /// Versión vieja: actualizar desde la tienda (ADR-0054).
  static const update = '/actualizar';
  static const about = '/acerca';
  static const deleteAccount = '/eliminar-cuenta';

  /// Piloto cerrado: número fuera de la lista (ADR-0052).
  static const comingSoon = '/pronto';

  /// Lectura de un texto legal (`terminos` o `privacidad`).
  static String legalDocument(String type) =>
      '/legal/${type == 'privacy' ? 'privacidad' : 'terminos'}';

  static String comingSoonFor(String phoneDigits, String cityName) =>
      '$comingSoon?telefono=$phoneDigits&ciudad=${Uri.encodeComponent(cityName)}';

  static String requestDetail(String id) => '/solicitudes/$id';

  /// Solicitud que le llegó al trabajador (también la abre el push).
  static String incomingRequest(String id) => '/trabajo/solicitudes/$id';

  /// Contacto revelado tras la elección (R5.4). Hoy lleva a la pantalla del trabajo.
  static String jobContact(String jobId) => '/trabajos/$jobId/contacto';

  /// Trabajo activo o terminado (R6), con contacto, chat y calificación.
  static String job(String jobId) => '/trabajos/$jobId';

  static String jobChat(String jobId) => '/trabajos/$jobId/chat';

  /// Historial como trabajador o como empleador (R8.3).
  static String jobs({required bool asWorker}) =>
      '/trabajos?rol=${asWorker ? 'trabajador' : 'empleador'}';

  static String otp(String phoneDigits, int resendInSec) =>
      '$otpPath?telefono=$phoneDigits&espera=$resendInSec';

  /// Rutas a las que se entra sin sesión.
  static bool isPublic(String location) =>
      location == splash ||
      location == login ||
      location.startsWith(otpPath) ||
      location.startsWith(comingSoon);

  /// Rutas que funcionan sin haber aceptado los textos (leerlos, aceptarlos, borrar la cuenta).
  static bool worksWithoutLegal(String location) =>
      location.startsWith(legal) ||
      location == about ||
      location == deleteAccount;
}
