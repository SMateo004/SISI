/// En web, Google Maps necesita su script JS cargado con la llave antes de crear el
/// mapa. Se inyecta desde Dart solo cuando hay llave (index.html no lleva llaves).
/// En Android e iOS la llave va en el manifiesto/Info.plist y esto no hace nada.
library;

export 'maps_loader_stub.dart'
    if (dart.library.js_interop) 'maps_loader_web.dart';
