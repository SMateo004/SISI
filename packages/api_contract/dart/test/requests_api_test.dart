import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for RequestsApi
void main() {
  final instance = SisiApi().getRequestsApi();

  group(RequestsApi, () {
    // Cancela la solicitud (mientras no esté asignada)
    //
    //Future<RequestDto> requestsControllerCancel(String id) async
    test('test requestsControllerCancel', () async {
      // TODO
    });

    // Confirma una foto subida (verifica el objeto con HEAD)
    //
    //Future<RequestDto> requestsControllerConfirmPhoto(String id, ConfirmUploadDto confirmUploadDto) async
    test('test requestsControllerConfirmPhoto', () async {
      // TODO
    });

    // Crea una solicitud en borrador
    //
    // Solo en modo empleador. Categoría activa en la ciudad, descripción de 20 a 1000 caracteres, ubicación dentro de la zona de servicio, dirección y precio > 0. Si el precio está bajo el mínimo de referencia, se crea igual y la respuesta trae una advertencia (R3.2).
    //
    //Future<CreatedRequestDto> requestsControllerCreate(CreateRequestDto createRequestDto) async
    test('test requestsControllerCreate', () async {
      // TODO
    });

    // Quita una foto del borrador
    //
    //Future requestsControllerDeletePhoto(String id, String photoId) async
    test('test requestsControllerDeletePhoto', () async {
      // TODO
    });

    // Detalle de una solicitud propia
    //
    //Future<RequestDto> requestsControllerGet(String id) async
    test('test requestsControllerGet', () async {
      // TODO
    });

    // Mis solicitudes (más recientes primero)
    //
    //Future<RequestPageDto> requestsControllerListMine({ String cursor, num limit }) async
    test('test requestsControllerListMine', () async {
      // TODO
    });

    // URL prefirmada para subir una foto (máx. 4, solo en borrador)
    //
    //Future<PresignedUploadDto> requestsControllerPhotoUploadUrl(String id, UploadRequestDto uploadRequestDto) async
    test('test requestsControllerPhotoUploadUrl', () async {
      // TODO
    });

    // Publica la solicitud
    //
    // Pasa por moderación (R3.3). Si hay coincidencias queda \"retenida\" con un mensaje neutral; si no, pasa a \"buscando\" y empieza la búsqueda de trabajadores. Límite: 10 por hora y 30 por día por usuario.
    //
    //Future<PublishResultDto> requestsControllerPublish(String id) async
    test('test requestsControllerPublish', () async {
      // TODO
    });

  });
}
