/// Fechas cortas en hora local, como se escriben en Bolivia.
library;

String _two(int n) => n.toString().padLeft(2, '0');

/// "14:05".
String formatTime(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

/// "16/10 14:05".
String formatDateTime(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)} ${formatTime(d)}';

/// "16/10/2026".
String formatDate(DateTime d) => '${_two(d.day)}/${_two(d.month)}/${d.year}';

const _weekdays = [
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

/// Fecha límite exclusiva (00:00 del día siguiente) como la lee una persona: el último
/// minuto antes. "miércoles 21/10 a las 23:59".
String formatDueLabel(DateTime dueAt) {
  final d = dueAt.subtract(const Duration(minutes: 1));
  return '${_weekdays[d.weekday - 1]} ${_two(d.day)}/${_two(d.month)} a las ${formatTime(d)}';
}
