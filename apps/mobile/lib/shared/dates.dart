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
