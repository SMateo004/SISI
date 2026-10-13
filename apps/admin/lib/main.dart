import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  // URLs limpias en web (/ruta en vez de /#/ruta); vercel.json reescribe a index.html.
  usePathUrlStrategy();
  runApp(const ProviderScope(child: SisiAdminApp()));
}
