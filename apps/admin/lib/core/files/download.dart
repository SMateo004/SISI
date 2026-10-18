/// Guarda un archivo en el navegador (CSV para el contador). En la VM (tests) no hace nada.
library;

export 'download_stub.dart' if (dart.library.js_interop) 'download_web.dart';
