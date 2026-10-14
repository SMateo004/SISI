import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for MeApi
void main() {
  final instance = SisiApi().getMeApi();

  group(MeApi, () {
    // Confirma la foto subida y la deja como foto de perfil
    //
    //Future<UserDto> meControllerConfirmPhoto(ConfirmUploadDto confirmUploadDto) async
    test('test meControllerConfirmPhoto', () async {
      // TODO
    });

    // Mi cuenta
    //
    //Future<UserDto> meControllerMe() async
    test('test meControllerMe', () async {
      // TODO
    });

    // URL prefirmada para subir mi foto de perfil
    //
    // Válida 5 minutos. Hacer PUT con el archivo y los headers indicados; luego confirmar con PUT /me/photo.
    //
    //Future<PresignedUploadDto> meControllerPhotoUploadUrl(UploadRequestDto uploadRequestDto) async
    test('test meControllerPhotoUploadUrl', () async {
      // TODO
    });

    // Actualiza mi nombre (la foto se cambia con /me/photo)
    //
    //Future<UserDto> meControllerUpdate(UpdateMeDto updateMeDto) async
    test('test meControllerUpdate', () async {
      // TODO
    });

  });
}
