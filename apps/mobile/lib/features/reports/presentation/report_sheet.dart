import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../data/reports_repository.dart';

/// Hoja para reportar una solicitud, un perfil, un mensaje o un trabajo (R9.3).
/// Devuelve true si se envió el reporte.
Future<bool> showReportSheet(
  BuildContext context, {
  required ReportTarget target,
  required String targetId,
}) async {
  final sent = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ReportSheet(target: target, targetId: targetId),
  );
  return sent ?? false;
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.target, required this.targetId});

  final ReportTarget target;
  final String targetId;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  ReportReason? _reason;
  final _note = TextEditingController();
  bool _busy = false;
  String? _error;

  String get _title => switch (widget.target) {
    ReportTarget.request => 'Reportar solicitud',
    ReportTarget.user => 'Reportar perfil',
    ReportTarget.chatMessage => 'Reportar mensaje',
    ReportTarget.job => 'Reportar un problema con el trabajo',
  };

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final reason = _reason;
    if (reason == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final note = _note.text.trim();
      await ref
          .read(reportsRepositoryProvider)
          .create(
            widget.target,
            widget.targetId,
            reason,
            note: note.isEmpty ? null : note,
          );
      navigator.pop(true);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gracias. Revisaremos tu reporte con cuidado.'),
        ),
      );
    } on ApiException catch (e) {
      setState(() {
        _busy = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Tu reporte es confidencial. Lo revisa el equipo de SISI.',
            ),
            const SizedBox(height: 8),
            RadioGroup<ReportReason>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v),
              child: Column(
                children: [
                  for (final r in ReportReason.values)
                    RadioListTile<ReportReason>(
                      key: Key('report-reason-${r.api}'),
                      value: r,
                      title: Text(r.label),
                      dense: true,
                    ),
                ],
              ),
            ),
            TextField(
              key: const Key('report-note'),
              controller: _note,
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Detalle (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              const SizedBox(height: 8),
            ],
            FilledButton(
              key: const Key('report-send'),
              onPressed: _reason == null || _busy ? null : _send,
              child: const Text('Enviar reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
