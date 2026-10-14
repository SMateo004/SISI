/// Montos en Bs. La API los envía como texto con 2 decimales ("80.00"); en la app se
/// comparan en centavos enteros para no usar float.
library;

/// "80.00" → "Bs 80,00" (coma decimal, como se escribe en Bolivia).
String formatBs(String amount) {
  final cents = parseBsCents(amount);
  if (cents == null) return 'Bs ${amount.replaceAll('.', ',')}';
  final whole = cents ~/ 100;
  final decimals = (cents % 100).toString().padLeft(2, '0');
  return 'Bs $whole,$decimals';
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

/// Centavos → "150.00" (formato de la API).
String centsToApi(int cents) =>
    '${cents ~/ 100}.${(cents % 100).toString().padLeft(2, '0')}';
