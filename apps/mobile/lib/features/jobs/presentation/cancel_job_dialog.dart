import 'package:flutter/material.dart';

import '../domain/job_models.dart';

typedef CancelInput = ({CancelReason reason, String? note});

/// Cancelar un trabajo antes de empezar: motivo de la lista y nota opcional.
Future<CancelInput?> showCancelJobDialog(BuildContext context) =>
    showDialog<CancelInput>(
      context: context,
      builder: (_) => const _CancelJobDialog(),
    );

class _CancelJobDialog extends StatefulWidget {
  const _CancelJobDialog();

  @override
  State<_CancelJobDialog> createState() => _CancelJobDialogState();
}

class _CancelJobDialogState extends State<_CancelJobDialog> {
  CancelReason? _reason;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('¿Cancelar el trabajo?'),
    scrollable: true,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cuéntanos el motivo. La otra parte recibirá un aviso.'),
        RadioGroup<CancelReason>(
          groupValue: _reason,
          onChanged: (v) => setState(() => _reason = v),
          child: Column(
            children: [
              for (final r in CancelReason.values)
                RadioListTile<CancelReason>(
                  key: Key('cancel-reason-${r.api}'),
                  value: r,
                  title: Text(r.label),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
        TextField(
          key: const Key('cancel-note'),
          controller: _note,
          maxLength: 300,
          decoration: const InputDecoration(labelText: 'Nota (opcional)'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Volver'),
      ),
      FilledButton(
        key: const Key('cancel-confirm'),
        onPressed: _reason == null
            ? null
            : () {
                final note = _note.text.trim();
                Navigator.of(
                  context,
                ).pop((reason: _reason!, note: note.isEmpty ? null : note));
              },
        child: const Text('Cancelar trabajo'),
      ),
    ],
  );
}
