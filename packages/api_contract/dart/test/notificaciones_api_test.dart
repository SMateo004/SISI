import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for NotificacionesApi
void main() {
  final instance = SisiApi().getNotificacionesApi();

  group(NotificacionesApi, () {
    // Mis avisos, del más reciente al más antiguo
    //
    //Future<NotificationPageDto> notificationsControllerList({ String cursor }) async
    test('test notificationsControllerList', () async {
      // TODO
    });

    // Marcar un aviso como leído
    //
    //Future notificationsControllerMarkRead(String id) async
    test('test notificationsControllerMarkRead', () async {
      // TODO
    });

    // Registrar el token de push (FCM) de este dispositivo
    //
    // Idempotente. Si el token era de otra cuenta (cambio de sesión), pasa a esta.
    //
    //Future notificationsControllerRegisterDevice(RegisterDeviceDto registerDeviceDto) async
    test('test notificationsControllerRegisterDevice', () async {
      // TODO
    });

    // Dar de baja el token de push (al cerrar sesión)
    //
    //Future notificationsControllerUnregisterDevice(String token) async
    test('test notificationsControllerUnregisterDevice', () async {
      // TODO
    });

  });
}
