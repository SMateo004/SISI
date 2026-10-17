import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../../../shared/dates.dart';
import '../../reports/data/reports_repository.dart';
import '../../reports/presentation/report_sheet.dart';
import '../application/chat_controller.dart';
import '../domain/chat_models.dart';

/// Chat del trabajo (R9.4, ADR-0031): solo texto, moderado. Un mensaje retenido no se
/// entrega y solo lo ve quien lo envió. Pasadas 24 h del fin queda en solo lectura.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _input.text.trim();
    if (body.isEmpty) return;
    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final notice = await ref
          .read(chatControllerProvider(widget.jobId).notifier)
          .send(body);
      _input.clear();
      if (notice != null) {
        messenger.showSnackBar(SnackBar(content: Text(notice)));
      }
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      if (e.code == 'CHAT_CLOSED') {
        ref.invalidate(chatControllerProvider(widget.jobId));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _report(ChatMessage message) async {
    final sent = await showReportSheet(
      context,
      target: ReportTarget.chatMessage,
      targetId: message.id,
    );
    // El mensaje reportado deja de mostrarse para mí.
    if (sent) ref.invalidate(chatControllerProvider(widget.jobId));
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(chatControllerProvider(widget.jobId));
    return Scaffold(
      appBar: AppBar(title: const Text('Chat del trabajo')),
      body: switch (chat) {
        AsyncData(:final value) => Column(
          children: [
            Expanded(
              child: value.messages.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Escribe para coordinar el trabajo. No compartas datos de pago.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      key: const Key('chat-list'),
                      reverse: true,
                      padding: const EdgeInsets.all(12),
                      itemCount:
                          value.messages.length +
                          (value.nextCursor != null ? 1 : 0),
                      itemBuilder: (_, i) {
                        if (i == value.messages.length) {
                          return TextButton(
                            onPressed: () => ref
                                .read(
                                  chatControllerProvider(widget.jobId).notifier,
                                )
                                .loadMore(),
                            child: const Text('Ver mensajes anteriores'),
                          );
                        }
                        final m = value.messages[i];
                        return _Bubble(
                          message: m,
                          onReport: m.mine ? null : () => _report(m),
                        );
                      },
                    ),
            ),
            if (value.open)
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const Key('chat-input'),
                          controller: _input,
                          maxLength: 1000,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(
                            hintText: 'Escribe un mensaje',
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        key: const Key('chat-send'),
                        tooltip: 'Enviar',
                        onPressed: _sending ? null : _send,
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                key: const Key('chat-closed'),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Text(
                  'El chat de este trabajo se cerró. Puedes leer los mensajes.',
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              ApiException.from(error).message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, this.onReport});

  final ChatMessage message;
  final VoidCallback? onReport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = message.mine;
    final color = message.held
        ? theme.colorScheme.errorContainer
        : mine
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onReport,
        child: Container(
          key: Key('msg-${message.id}'),
          constraints: const BoxConstraints(maxWidth: 300),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message.body),
              const SizedBox(height: 2),
              Text(
                message.held
                    ? 'No enviado: no cumple las normas'
                    : formatTime(message.createdAt),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
