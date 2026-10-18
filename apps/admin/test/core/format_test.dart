import 'package:flutter_test/flutter_test.dart';
import 'package:sisi_admin/core/config/env.dart';
import 'package:sisi_admin/core/format/dates.dart';
import 'package:sisi_admin/core/format/money.dart';

void main() {
  test('montos en Bs con coma decimal, miles y signo', () {
    expect(formatBs('19.50'), 'Bs 19,50');
    expect(formatBs('1234567.00'), 'Bs 1.234.567,00');
    expect(formatBs('-19.50'), '− Bs 19,50');
    expect(formatBalance('-30.50'), 'Bs 30,50 a favor');
    expect(parseBsCents('29,9'), 2990);
    expect(parseBsCents('29.999'), isNull);
    expect(centsToApi(-1950), '-19.50');
  });

  test('duraciones legibles', () {
    expect(formatMs(45000), '45 s');
    expect(formatMs(180000), '3 min');
    expect(formatMs(86400000), '24 h');
    expect(formatMs(604800000), '7 días');
  });

  test('la API relativa se resuelve contra el origen del panel', () {
    expect(
      Env.resolvedApiUrl(Uri.parse('https://admin-staging.vercel.app/cobros')),
      'https://admin-staging.vercel.app/api',
    );
  });
}
