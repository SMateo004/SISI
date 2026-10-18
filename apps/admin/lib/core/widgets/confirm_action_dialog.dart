import 'package:flutter/material.dart';

import '../http/api_error.dart';

/// Lo que el admin escribió al confirmar.
class ConfirmInput {
  const ConfirmInput({required this.note, this.reasonCode});

  /// Motivo de la lista cerrada, si la acción tiene una.
  final String? reasonCode;

  /// Motivo o nota en texto libre (queda en la auditoría).
  final String note;
}

/// Confirmación de toda acción que cambia un estado o dinero (Fase 6): pide un motivo
/// (de una lista cerrada, más una nota, si corresponde), muestra el efecto antes de guardar
/// si hay vista previa, deshabilita el botón mientras envía y muestra el error de la API
/// sin cerrarse. Un reintento vuelve a llamar a [onConfirm] con los mismos datos (p. ej. la
/// misma Idempotency-Key, que el que llama genera al abrir el diálogo).
Future<T?> confirmAction<T>(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required Future<T> Function(ConfirmInput input) onConfirm,
  bool destructive = false,
  List<(String, String)>? reasons,
  String noteLabel = 'Motivo',
  String? noteHint,
  bool noteRequired = true,
  Future<Widget> Function()? loadPreview,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (_) => ConfirmActionDialog<T>(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      onConfirm: onConfirm,
      destructive: destructive,
      reasons: reasons,
      noteLabel: noteLabel,
      noteHint: noteHint,
      noteRequired: noteRequired,
      loadPreview: loadPreview,
    ),
  );
}

class ConfirmActionDialog<T> extends StatefulWidget {
  const ConfirmActionDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.destructive = false,
    this.reasons,
    this.noteLabel = 'Motivo',
    this.noteHint,
    this.noteRequired = true,
    this.loadPreview,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final Future<T> Function(ConfirmInput input) onConfirm;
  final bool destructive;
  final List<(String, String)>? reasons;
  final String noteLabel;
  final String? noteHint;
  final bool noteRequired;
  final Future<Widget> Function()? loadPreview;

  /// Mínimo de letras del motivo (igual que la API).
  static const minNote = 5;

  @override
  State<ConfirmActionDialog<T>> createState() => _ConfirmActionDialogState<T>();
}

class _ConfirmActionDialogState<T> extends State<ConfirmActionDialog<T>> {
  final _note = TextEditingController();
  String? _reason;
  bool _sending = false;
  String? _error;
  Future<Widget>? _preview;

  @override
  void initState() {
    super.initState();
    _preview = widget.loadPreview?.call();
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _valid {
    if (widget.reasons != null && _reason == null) return false;
    final note = _note.text.trim();
    if (!widget.noteRequired) {
      return note.isEmpty || note.length >= ConfirmActionDialog.minNote;
    }
    return note.length >= ConfirmActionDialog.minNote;
  }

  Future<void> _submit() async {
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final result = await widget.onConfirm(
        ConfirmInput(note: _note.text.trim(), reasonCode: _reason),
      );
      if (mounted) Navigator.of(context).pop(result);
    } catch (error) {
      if (mounted) {
        setState(() {
          _sending = false;
          _error = ApiError.from(error).message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reasons = widget.reasons;
    return AlertDialog(
      key: const Key('confirm-dialog'),
      title: Text(widget.title),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              if (_preview != null) ...[
                const SizedBox(height: 16),
                FutureBuilder<Widget>(
                  future: _preview,
                  builder: (context, snap) => switch (snap) {
                    AsyncSnapshot(hasData: true, :final data) => data!,
                    AsyncSnapshot(hasError: true, :final error) => Text(
                      ApiError.from(error!).message,
                      key: const Key('confirm-preview-error'),
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                    _ => const LinearProgressIndicator(),
                  },
                ),
              ],
              if (reasons != null) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: const Key('confirm-reason'),
                  isExpanded: true,
                  initialValue: _reason,
                  decoration: const InputDecoration(labelText: 'Motivo'),
                  items: [
                    for (final (value, label) in reasons)
                      DropdownMenuItem(value: value, child: Text(label)),
                  ],
                  onChanged: _sending
                      ? null
                      : (v) => setState(() => _reason = v),
                ),
              ],
              const SizedBox(height: 16),
              TextField(
                key: const Key('confirm-note'),
                controller: _note,
                enabled: !_sending,
                minLines: 2,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: widget.noteRequired
                      ? widget.noteLabel
                      : '${widget.noteLabel} (opcional)',
                  hintText: widget.noteHint,
                  helperText: widget.noteRequired
                      ? 'Al menos ${ConfirmActionDialog.minNote} letras. Queda en la auditoría.'
                      : 'Queda en la auditoría.',
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _error!,
                    key: const Key('confirm-error'),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('confirm-submit'),
          style: widget.destructive
              ? FilledButton.styleFrom(backgroundColor: theme.colorScheme.error)
              : null,
          onPressed: _sending || !_valid ? null : _submit,
          child: _sending
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
