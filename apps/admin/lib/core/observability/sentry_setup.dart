import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../config/env.dart';

final _phone = RegExp(r'\+?591\s?[67]\d{7}|\b[67]\d{7}\b');
final _jwt = RegExp(r'eyJ[\w-]{5,}\.[\w-]{5,}\.[\w-]{5,}');
final _bearer = RegExp(r'Bearer\s+\S+', caseSensitive: false);
final _otp = RegExp(r'\b\d{6}\b');

/// Sin teléfonos, tokens ni códigos en lo que se envía a Sentry (ADR-0047).
String redactText(String text) => text
    .replaceAll(_jwt, '[jwt]')
    .replaceAll(_bearer, 'Bearer [redactado]')
    .replaceAllMapped(
      _phone,
      (m) => '${m[0]!.substring(0, m[0]!.length > 4 ? 4 : m[0]!.length)}•••',
    )
    .replaceAll(_otp, '••••••');

SentryEvent scrubEvent(SentryEvent event) {
  event.user = null;
  event.request = null;
  final message = event.message;
  if (message != null) {
    event.message = SentryMessage(redactText(message.formatted));
  }
  for (final e in event.exceptions ?? const <SentryException>[]) {
    if (e.value != null) e.value = redactText(e.value!);
  }
  return event;
}

/// Arranca la app con Sentry si hay DSN (staging y producción, ADR-0048): errores con
/// release y ambiente, sin datos personales ni trazas de rendimiento.
Future<void> runWithSentry(Widget app, {required String appName}) async {
  if (Env.sentryDsn.isEmpty) {
    runApp(app);
    return;
  }
  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDsn;
    options.environment = Env.appEnv;
    options.release = Env.appVersion.isEmpty
        ? '$appName@dev'
        : '$appName@${Env.appVersion}+${Env.appBuild}';
    options.sendDefaultPii = false;
    options.tracesSampleRate = 0;
    options.beforeSend = (event, hint) => scrubEvent(event);
    options.beforeBreadcrumb = (breadcrumb, hint) {
      final message = breadcrumb?.message;
      if (breadcrumb != null && message != null) {
        breadcrumb.message = redactText(message);
      }
      return breadcrumb;
    };
  }, appRunner: () => runApp(app));
}
