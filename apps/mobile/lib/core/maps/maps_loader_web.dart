import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<void>? _loading;

@JS('google.maps.Map')
external JSAny? get _mapsConstructor;

bool _alreadyLoaded() {
  try {
    return _mapsConstructor != null;
  } catch (_) {
    return false;
  }
}

/// Inyecta el script de Google Maps JS una sola vez y espera a que cargue.
Future<void> ensureGoogleMapsLoaded(String apiKey) {
  if (_alreadyLoaded()) return Future.value();
  return _loading ??= () {
    final completer = Completer<void>();
    final script = web.HTMLScriptElement()
      ..src =
          'https://maps.googleapis.com/maps/api/js?key=${Uri.encodeQueryComponent(apiKey)}&language=es&region=BO'
      ..async = true
      ..defer = true;
    script.onload = (web.Event _) {
      completer.complete();
    }.toJS;
    script.onerror = (web.Event _) {
      _loading = null;
      completer.completeError(StateError('No se pudo cargar Google Maps'));
    }.toJS;
    web.document.head!.append(script);
    return completer.future;
  }();
}
