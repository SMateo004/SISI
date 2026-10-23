import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/http/api_client.dart';
import '../../core/http/api_error.dart';

/// Provoca el error 5xx de prueba de la API (ADR-0048). La API lo rechaza en producción.
final opsDrillProvider = Provider<Future<void> Function()>(
  (ref) => () async {
    await ref.read(dioProvider).post<void>('/admin/ops/drill-500');
  },
);

/// Simulacro de alertas (solo staging o local): el error 5xx se prueba desde aquí; los demás
/// (outbox, OTP, push, worker y cron) se provocan desde Render (runbook, "Alertas").
class OpsDrillPanel extends ConsumerStatefulWidget {
  const OpsDrillPanel({super.key});

  @override
  ConsumerState<OpsDrillPanel> createState() => _OpsDrillPanelState();
}

class _OpsDrillPanelState extends ConsumerState<OpsDrillPanel> {
  bool _busy = false;
  String? _result;

  Future<void> _run() async {
    setState(() {
      _busy = true;
      _result = null;
    });
    final sentAt = TimeOfDay.now().format(context);
    String result;
    try {
      await ref.read(opsDrillProvider)();
      result = 'La API no devolvió el error esperado.';
    } on DioException catch (e) {
      result = e.response?.statusCode == 500
          ? 'Listo: la API devolvió el error 5xx de prueba a las $sentAt. '
                'Revisa Sentry (y tu email) en 1 o 2 minutos.'
          : ApiError.from(e).message;
    } catch (e) {
      result = ApiError.from(e).message;
    }
    if (mounted) {
      setState(() {
        _busy = false;
        _result = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
    children: [
      const Text(
        'Para probar que las alertas llegan. Provoca un error interno de prueba en la API '
        '(Sentry lo registra como un error real). No afecta a los usuarios.',
      ),
      const SizedBox(height: 16),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonal(
          key: const Key('ops-drill-500'),
          onPressed: _busy ? null : _run,
          child: Text(_busy ? 'Enviando…' : 'Provocar un error 5xx de prueba'),
        ),
      ),
      if (_result != null) ...[
        const SizedBox(height: 12),
        Text(_result!, key: const Key('ops-drill-result')),
      ],
    ],
  );
}
