import 'dart:typed_data';

/// Fuera del navegador no hay descarga (los tests verifican la llamada a la API).
void saveFile(Uint8List bytes, String filename, String mimeType) {}
