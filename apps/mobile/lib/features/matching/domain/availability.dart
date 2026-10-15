/// Disponibilidad del trabajador (ADR-0024).
class Availability {
  const Availability({
    required this.available,
    required this.sendEverySec,
    required this.staleAfterSec,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
    available: json['available'] as bool,
    sendEverySec: (json['sendEverySec'] as int?) ?? 30,
    staleAfterSec: (json['staleAfterSec'] as int?) ?? 600,
  );

  final bool available;

  /// Cada cuánto enviar la ubicación mientras está disponible y en primer plano.
  final int sendEverySec;
  final int staleAfterSec;

  Availability copyWith({bool? available}) => Availability(
    available: available ?? this.available,
    sendEverySec: sendEverySec,
    staleAfterSec: staleAfterSec,
  );
}
