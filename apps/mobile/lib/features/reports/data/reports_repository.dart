import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_client.dart';
import '../../../core/http/api_exception.dart';

/// Qué se reporta (R9.3, ADR-0033).
enum ReportTarget {
  request('request'),
  user('user'),
  chatMessage('chat_message'),
  job('job');

  const ReportTarget(this.api);

  final String api;
}

/// Motivos (lista cerrada de la API): los de R9.1 y otros de convivencia.
enum ReportReason {
  acoso('acoso', 'Acoso o trato ofensivo'),
  fraude('fraude', 'Fraude o pedido de pago por fuera'),
  noSePresento('no_se_presento', 'No se presentó'),
  suplantacion('suplantacion', 'Se hace pasar por otra persona'),
  serviciosSexuales('servicios_sexuales', 'Servicios sexuales'),
  drogas('drogas', 'Drogas'),
  armas('armas', 'Armas'),
  ilegal('ilegal', 'Actividad ilegal'),
  inmoral('inmoral', 'Contenido inmoral'),
  ventaProductos('venta_productos', 'Venta de productos'),
  otro('otro', 'Otro motivo');

  const ReportReason(this.api, this.label);

  final String api;
  final String label;
}

class ReportsRepository {
  ReportsRepository(this._api);

  final Dio _api;

  Future<void> create(
    ReportTarget target,
    String targetId,
    ReportReason reason, {
    String? note,
  }) => _guard(() async {
    await _api.post<Map<String, dynamic>>(
      '/reports',
      data: {
        'targetType': target.api,
        'targetId': targetId,
        'reason': reason.api,
        'note': ?note,
      },
    );
  });

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => ReportsRepository(ref.watch(dioProvider)),
);
