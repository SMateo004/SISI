import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for OfertasApi
void main() {
  final instance = SisiApi().getOfertasApi();

  group(OfertasApi, () {
    // Elegir una oferta (R5.4)
    //
    // Crea el trabajo, asigna la solicitud y cierra las demás ofertas. Después, el contacto se pide con GET /jobs/{jobId}/contact.
    //
    //Future<AcceptOfferResultDto> offersControllerAccept(String id, String offerId) async
    test('test offersControllerAccept', () async {
      // TODO
    });

    // Contacto de la contraparte (R5.4, R9.4)
    //
    // Solo para el empleador y el trabajador del trabajo. Al trabajador también le da la dirección.
    //
    //Future<JobContactDto> offersControllerContact(String id) async
    test('test offersControllerContact', () async {
      // TODO
    });

    // Solicitudes que me llegaron (últimas 24 h)
    //
    // Bandeja del trabajador y resincronización al reconectar el socket. Incluye el estado de mi oferta y si me eligieron.
    //
    //Future<List<IncomingRequestDto>> offersControllerIncoming() async
    test('test offersControllerIncoming', () async {
      // TODO
    });

    // Detalle de una solicitud que me llegó (R5.1)
    //
    // Solo para trabajadores notificados: a los demás les responde 404.
    //
    //Future<IncomingRequestDto> offersControllerIncomingOne(String id) async
    test('test offersControllerIncomingOne', () async {
      // TODO
    });

    // Ofertas de mi solicitud (R5.3)
    //
    // Precio, calificación, tiempo estimado de llegada y nombre corto del trabajador.
    //
    //Future<List<EmployerOfferDto>> offersControllerList(String id) async
    test('test offersControllerList', () async {
      // TODO
    });

    // Ofertar: aceptar el precio o contraofertar (R5.2)
    //
    // Solo trabajadores notificados y que sigan elegibles. Una oferta por trabajador: enviar otra la reemplaza mientras no se haya elegido ninguna.
    //
    //Future<MyOfferDto> offersControllerOffer(String id, CreateOfferDto createOfferDto) async
    test('test offersControllerOffer', () async {
      // TODO
    });

  });
}
