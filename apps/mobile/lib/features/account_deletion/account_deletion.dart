import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/session_controller.dart';
import '../../core/http/api_client.dart';
import '../../core/http/api_exception.dart';
import '../../core/router/routes.dart';
import '../../shared/money.dart';

/// Lo que impide eliminar la cuenta hoy (deuda, trabajo activo, comprobante en revisión).
class DeletionBlocker {
  const DeletionBlocker({
    required this.code,
    required this.message,
    this.balanceBs,
    this.paymentReference,
  });

  factory DeletionBlocker.fromJson(Map<String, dynamic> json) =>
      DeletionBlocker(
        code: json['code'] as String,
        message: json['message'] as String,
        balanceBs: json['balanceBs'] as String?,
        paymentReference: json['paymentReference'] as String?,
      );

  final String code;
  final String message;
  final String? balanceBs;
  final String? paymentReference;

  bool get isDebt => code == 'ACCOUNT_HAS_DEBT';
}

class DeletionCheck {
  const DeletionCheck({
    required this.canDelete,
    required this.blockers,
    required this.erased,
    required this.kept,
  });

  factory DeletionCheck.fromJson(Map<String, dynamic> json) => DeletionCheck(
    canDelete: json['canDelete'] == true,
    blockers: [
      for (final b in (json['blockers'] as List?) ?? const [])
        DeletionBlocker.fromJson((b as Map).cast<String, dynamic>()),
    ],
    erased: [for (final e in (json['erased'] as List?) ?? const []) '$e'],
    kept: [for (final k in (json['kept'] as List?) ?? const []) '$k'],
  );

  final bool canDelete;
  final List<DeletionBlocker> blockers;
  final List<String> erased;
  final List<String> kept;
}

/// Eliminación de cuenta (ADR-0049).
class AccountRepository {
  AccountRepository(this._api);

  final Dio _api;

  Future<DeletionCheck> check() async {
    try {
      final res = await _api.get<Map<String, dynamic>>('/me/deletion');
      return DeletionCheck.fromJson(res.data ?? const {});
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<void> sendCode() async {
    try {
      await _api.post<void>('/me/deletion/code');
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<void> delete(String code) async {
    try {
      await _api.post<void>('/me/deletion', data: {'code': code});
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(ref.watch(dioProvider)),
);

final deletionCheckProvider = FutureProvider.autoDispose<DeletionCheck>(
  (ref) => ref.watch(accountRepositoryProvider).check(),
);

/// Eliminar mi cuenta: qué se borra, qué se conserva y, si se puede, código por SMS.
/// Con deuda muestra el monto y lleva a pagar (ADR-0049).
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _code = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } catch (e) {
      setState(() => _error = ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() => _run(() async {
    await ref.read(accountRepositoryProvider).sendCode();
    setState(() => _codeSent = true);
  });

  Future<void> _delete() => _run(() async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(accountRepositoryProvider).delete(_code.text.trim());
    await ref.read(sessionProvider.notifier).signOut();
    messenger.showSnackBar(
      const SnackBar(content: Text('Tu cuenta fue eliminada.')),
    );
  });

  @override
  Widget build(BuildContext context) {
    final check = ref.watch(deletionCheckProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar mi cuenta')),
      body: check.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(ApiException.from(e).message)),
        data: (c) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Qué se borra', style: theme.textTheme.titleMedium),
            for (final e in c.erased) _bullet(e),
            const SizedBox(height: 12),
            Text(
              'Qué se conserva, sin tus datos personales',
              style: theme.textTheme.titleMedium,
            ),
            for (final k in c.kept) _bullet(k),
            const SizedBox(height: 20),
            if (!c.canDelete)
              for (final b in c.blockers)
                Card(
                  key: Key('deletion-blocker-${b.code}'),
                  color: theme.colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (b.isDebt && b.balanceBs != null)
                          Text(
                            'Debes ${formatBs(b.balanceBs!)}',
                            style: theme.textTheme.titleLarge,
                          ),
                        Text(b.message),
                        if (b.paymentReference != null)
                          Text('Referencia: ${b.paymentReference}'),
                        if (b.isDebt) ...[
                          const SizedBox(height: 8),
                          FilledButton(
                            key: const Key('deletion-pay'),
                            onPressed: () => context.push(Routes.pay),
                            child: const Text('Pagar comisión'),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
            else if (!_codeSent)
              FilledButton(
                key: const Key('deletion-send-code'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                onPressed: _busy ? null : _sendCode,
                child: const Text('Enviarme un código para confirmar'),
              )
            else ...[
              const Text(
                'Te enviamos un código por SMS. Escríbelo para eliminar tu cuenta. Esto no se puede deshacer.',
              ),
              const SizedBox(height: 12),
              TextField(
                key: const Key('deletion-code'),
                controller: _code,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(labelText: 'Código'),
              ),
              FilledButton(
                key: const Key('deletion-confirm'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                ),
                onPressed: _busy ? null : _delete,
                child: const Text('Eliminar mi cuenta'),
              ),
            ],
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  _error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String text) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('•  '),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
