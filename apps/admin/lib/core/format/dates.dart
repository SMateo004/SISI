/// Fechas del panel en la hora del navegador del admin (Bolivia), formato es_BO.
library;

import 'package:intl/intl.dart';

final _dateTime = DateFormat('dd/MM/yyyy HH:mm');
final _date = DateFormat('dd/MM/yyyy');

String formatDateTime(DateTime value) => _dateTime.format(value.toLocal());

String formatDate(DateTime value) => _date.format(value.toLocal());

/// Fecha sin hora de la API ("2000-01-15", p. ej. la de nacimiento): no se convierte de
/// zona, o en Bolivia se vería un día antes.
String formatCalendarDate(DateTime value) =>
    _date.format(DateTime(value.year, value.month, value.day));

/// Texto ISO de la API ("2026-10-19T04:05:00.000Z"); vacío si no hay.
String formatIso(String? iso) {
  if (iso == null || iso.isEmpty) return '—';
  final parsed = DateTime.tryParse(iso);
  return parsed == null ? iso : formatDateTime(parsed);
}

/// Duración en ms para leer: "45 s", "3 min", "24 h", "7 días".
String formatMs(num ms) {
  final s = ms / 1000;
  if (s < 60) return '${_trim(s)} s';
  final min = s / 60;
  if (min < 60) return '${_trim(min)} min';
  final h = min / 60;
  if (h < 48) return '${_trim(h)} h';
  return '${_trim(h / 24)} días';
}

String _trim(num value) => value == value.roundToDouble()
    ? value.round().toString()
    : value.toStringAsFixed(1);
