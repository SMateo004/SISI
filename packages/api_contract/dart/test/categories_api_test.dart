import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for CategoriesApi
void main() {
  final instance = SisiApi().getCategoriesApi();

  group(CategoriesApi, () {
    // Categorías activas
    //
    // Lista cerrada (R2.1). En la Fase 1 puede venir vacía: el seed llega en la Fase 2.
    //
    //Future<List<CategoryDto>> categoriesControllerList() async
    test('test categoriesControllerList', () async {
      // TODO
    });

  });
}
