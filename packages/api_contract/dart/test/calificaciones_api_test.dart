import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for CalificacionesApi
void main() {
  final instance = SisiApi().getCalificacionesApi();

  group(CalificacionesApi, () {
    // Calificaciones del trabajo (la mía y, si ya es visible, la recibida)
    //
    //Future<JobReviewsDto> reviewsControllerForJob(String id) async
    test('test reviewsControllerForJob', () async {
      // TODO
    });

    // Calificaciones publicadas de un usuario
    //
    // Como trabajador o como empleador, con su promedio.
    //
    //Future<UserReviewsDto> reviewsControllerForUser(String id, String role, { String cursor }) async
    test('test reviewsControllerForUser', () async {
      // TODO
    });

    // Calificar a la contraparte (1 a 5 estrellas y comentario opcional)
    //
    // Una vez por trabajo, solo terminado y dentro de los 7 días. Es ciega: la contraparte la ve cuando califiquen los dos o venza el plazo. El comentario se modera.
    //
    //Future<JobReviewsDto> reviewsControllerSubmit(String id, CreateReviewDto createReviewDto) async
    test('test reviewsControllerSubmit', () async {
      // TODO
    });

  });
}
