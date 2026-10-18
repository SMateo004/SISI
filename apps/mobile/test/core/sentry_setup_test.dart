import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sisi_mobile/core/observability/sentry_setup.dart';

void main() {
  test('no envía teléfonos, tokens ni códigos a Sentry (ADR-0047)', () {
    expect(redactText('Falló con +59170012345'), isNot(contains('70012345')));
    expect(redactText('Bearer abc.def'), 'Bearer [redactado]');
    expect(redactText('código 123456'), isNot(contains('123456')));

    final event = scrubEvent(
      SentryEvent(
        message: SentryMessage('Login de 71234567'),
        user: SentryUser(id: 'u1', ipAddress: '1.2.3.4'),
        exceptions: [
          SentryException(
            type: 'E',
            value: 'token eyJhbGciOi.eyJzdWIiOi.c2lnbmF0dXJl',
          ),
        ],
      ),
    );
    expect(event.user, isNull);
    expect(event.message?.formatted, isNot(contains('71234567')));
    expect(event.exceptions?.first.value, contains('[jwt]'));
  });
}
