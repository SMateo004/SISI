import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for TrabajosApi
void main() {
  final instance = SisiApi().getTrabajosApi();

  group(TrabajosApi, () {
    // Cancelar el trabajo (cualquiera de las dos partes)
    //
    // Solo asignado o en camino; en curso ya no. Motivo de la lista y nota opcional (moderada). Sin penalidad; la solicitud queda cancelada y el empleador puede volver a publicarla.
    //
    //Future<JobDto> jobsControllerCancel(String id, CancelJobDto cancelJobDto) async
    test('test jobsControllerCancel', () async {
      // TODO
    });

    // Confirmar el término (empleador, R6.2)
    //
    // en_curso → terminado. Calcula la comisión (R6.3).
    //
    //Future<JobDto> jobsControllerConfirm(String id) async
    test('test jobsControllerConfirm', () async {
      // TODO
    });

    // Hubo un problema (empleador)
    //
    // Después de que el trabajador marcó terminado. Frena la autoconfirmación; lo resuelve un administrador.
    //
    //Future<JobDto> jobsControllerDispute(String id, DisputeJobDto disputeJobDto) async
    test('test jobsControllerDispute', () async {
      // TODO
    });

    // Terminé el trabajo (trabajador)
    //
    // Solo en curso. Queda esperando la confirmación del empleador; si no responde en el plazo (24 h), se confirma solo.
    //
    //Future<JobDto> jobsControllerFinish(String id) async
    test('test jobsControllerFinish', () async {
      // TODO
    });

    // Detalle del trabajo
    //
    // Estado, línea de tiempo y acciones permitidas. Solo para las dos partes.
    //
    //Future<JobDto> jobsControllerGet(String id) async
    test('test jobsControllerGet', () async {
      // TODO
    });

    // Historial de trabajos (R8.3)
    //
    // Como trabajador incluye la comisión y el neto de cada trabajo terminado.
    //
    //Future<JobPageDto> jobsControllerList(String role, { String cursor, num limit }) async
    test('test jobsControllerList', () async {
      // TODO
    });

    // Ubicación del trabajador en camino (empleador)
    //
    // Para resincronizar el mapa; en vivo llega por job:location. Solo mientras va en camino (409 JOB_LOCATION_UNAVAILABLE).
    //
    //Future<JobLocationDto> jobsControllerLocation(String id) async
    test('test jobsControllerLocation', () async {
      // TODO
    });

    // Voy en camino (trabajador)
    //
    // asignado → en_camino
    //
    //Future<JobDto> jobsControllerOnTheWay(String id) async
    test('test jobsControllerOnTheWay', () async {
      // TODO
    });

    // Empecé el trabajo (trabajador)
    //
    // en_camino → en_curso
    //
    //Future<JobDto> jobsControllerStart(String id) async
    test('test jobsControllerStart', () async {
      // TODO
    });

  });
}
