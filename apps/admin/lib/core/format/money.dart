/// Montos en Bs. La API los envía como texto con 2 decimales ("80.00"); el panel los
/// compara en centavos enteros, nunca en float.
library;

/// "80.00" → "Bs 80,00"; "-19.50" → "− Bs 19,50" (coma decimal, como en Bolivia).
String formatBs(String amount) {
  final negative = amount.trim().startsWith('-');
  final cents = parseBsCents(negative ? amount.trim().substring(1) : amount);
  if (cents == null) return 'Bs ${amount.replaceAll('.', ',')}';
  final whole = cents ~/ 100;
  final decimals = (cents % 100).toString().padLeft(2, '0');
  return '${negative ? '− ' : ''}Bs ${_thousands(whole)},$decimals';
}

String _thousands(int value) {
  final text = value.toString();
  final out = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) out.write('.');
    out.write(text[i]);
  }
  return out.toString();
}

/// Centavos de un monto escrito con punto o coma ("150", "150,5", "150.50").
/// null si no es un monto válido (máx. 2 decimales, sin signo).
int? parseBsCents(String input) {
  final text = input.trim().replaceAll(',', '.');
  final match = RegExp(r'^(\d{1,8})(?:\.(\d{1,2}))?$').firstMatch(text);
  if (match == null) return null;
  final whole = int.parse(match.group(1)!);
  final decimals = (match.group(2) ?? '').padRight(2, '0');
  return whole * 100 + int.parse(decimals);
}

/// Centavos → "150.00" (formato de la API). Admite negativos para los ajustes.
String centsToApi(int cents) {
  final sign = cents < 0 ? '-' : '';
  final abs = cents.abs();
  return '$sign${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
}

/// Saldo con signo de la API: "-30.50" → "Bs 30,50 a favor"; "19.50" → "Bs 19,50".
String formatBalance(String amount) => amount.trim().startsWith('-')
    ? '${formatBs(amount.trim().substring(1))} a favor'
    : formatBs(amount);
