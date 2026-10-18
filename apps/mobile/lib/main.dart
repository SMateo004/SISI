import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';
import 'core/observability/sentry_setup.dart';

Future<void> main() async {
  // URLs limpias en web (/ruta en vez de /#/ruta); vercel.json reescribe a index.html.
  usePathUrlStrategy();
  // Errores a Sentry en staging y producción, sin datos personales (ADR-0048).
  await runWithSentry(
    const ProviderScope(child: SisiApp()),
    appName: 'sisi-mobile',
  );
}
