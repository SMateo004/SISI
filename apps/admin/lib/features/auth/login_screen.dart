import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/http/api_error.dart';

/// Ingreso al panel con OTP (ADR-0040): teléfono, código y solo cuentas admin.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  bool _codeSent = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
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
    } catch (error) {
      if (mounted) setState(() => _error = ApiError.from(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendCode() => _run(() async {
    await ref.read(sessionProvider.notifier).requestOtp(_phone.text.trim());
    setState(() => _codeSent = true);
  });

  Future<void> _verify() => _run(
    () => ref
        .read(sessionProvider.notifier)
        .verify(_phone.text.trim(), _code.text.trim()),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionProvider);
    final notice = state is SignedOut ? state.message : null;
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 380,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Panel de SISI', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  const Text('Solo para el equipo de administración.'),
                  if (notice != null) ...[
                    const SizedBox(height: 12),
                    Text(notice, key: const Key('login-notice')),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('login-phone'),
                    controller: _phone,
                    enabled: !_codeSent && !_busy,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d+ ]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Celular',
                      prefixText: '+591 ',
                    ),
                  ),
                  if (_codeSent) ...[
                    const SizedBox(height: 12),
                    TextField(
                      key: const Key('login-code'),
                      controller: _code,
                      enabled: !_busy,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Código de 6 dígitos',
                      ),
                      onSubmitted: (_) => _verify(),
                    ),
                  ],
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      key: const Key('login-error'),
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 16),
                  FilledButton(
                    key: const Key('login-submit'),
                    onPressed: _busy ? null : (_codeSent ? _verify : _sendCode),
                    child: Text(_codeSent ? 'Ingresar' : 'Enviar código'),
                  ),
                  if (_codeSent)
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => setState(() => _codeSent = false),
                      child: const Text('Cambiar número'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
