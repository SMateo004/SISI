import 'package:test/test.dart';
import 'package:sisi_api/sisi_api.dart';


/// tests for ChatApi
void main() {
  final instance = SisiApi().getChatApi();

  group(ChatApi, () {
    // Mensajes del trabajo
    //
    // Del más reciente al más antiguo. Los retenidos solo los ve quien los envió. En vivo llegan por chat:message.
    //
    //Future<ChatPageDto> chatControllerList(String id, { String cursor, num limit }) async
    test('test chatControllerList', () async {
      // TODO
    });

    // Marcar como leídos los mensajes recibidos hasta uno (incluido)
    //
    //Future<MarkReadResultDto> chatControllerRead(String id, MarkReadDto markReadDto) async
    test('test chatControllerRead', () async {
      // TODO
    });

    // Enviar un mensaje (solo texto)
    //
    // Se modera (R9.2): si coincide, queda retenido, no se entrega y vuelve con `notice`. Abierto hasta 24 h después de terminado o cancelado.
    //
    //Future<SentMessageDto> chatControllerSend(String id, SendMessageDto sendMessageDto) async
    test('test chatControllerSend', () async {
      // TODO
    });

  });
}
