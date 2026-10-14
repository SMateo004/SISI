import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for WorkerApi
void main() {
  final instance = SisiApi().getWorkerApi();

  group(WorkerApi, () {
    // Confirma un documento subido
    //
    //Future<WorkerProfileDto> workerMeControllerConfirmDocument(String type, ConfirmUploadDto confirmUploadDto) async
    test('test workerMeControllerConfirmDocument', () async {
      // TODO
    });

    // URL prefirmada para subir un documento (CI anverso, reverso o selfie)
    //
    // Válida 5 minutos. Luego confirmar con PUT /me/worker/documents/{type}.
    //
    //Future<PresignedUploadDto> workerMeControllerDocumentUploadUrl(DocumentUploadRequestDto documentUploadRequestDto) async
    test('test workerMeControllerDocumentUploadUrl', () async {
      // TODO
    });

    // Mi perfil de trabajador y el estado de cada documento
    //
    //Future<WorkerProfileDto> workerMeControllerGetProfile() async
    test('test workerMeControllerGetProfile', () async {
      // TODO
    });

    // Envía la solicitud para trabajar (R1.3)
    //
    // Requiere teléfono verificado, 18 años cumplidos (hora de Bolivia), CI ambos lados, selfie, categorías activas, transporte y radio de 1 a 10 km. El estado pasa a pendiente_revision.
    //
    //Future<WorkerProfileDto> workerMeControllerSubmitUpgrade(SubmitUpgradeDto submitUpgradeDto) async
    test('test workerMeControllerSubmitUpgrade', () async {
      // TODO
    });

    // Interruptor empleador / trabajador
    //
    // A employer siempre se puede cambiar. A worker solo con el perfil aprobado; si no, 409 con el motivo y la acción siguiente (R1.5, R1.6).
    //
    //Future<UserDto> workerMeControllerSwitchMode(SwitchModeDto switchModeDto) async
    test('test workerMeControllerSwitchMode', () async {
      // TODO
    });

  });
}
