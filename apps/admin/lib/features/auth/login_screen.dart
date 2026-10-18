import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/http/api_error.dart';

/// Ingreso al panel (ADR-0055): una sola cuenta, sin teléfono. Usuario del panel y el
/// código de 6 dígitos que muestra la app autenticadora (cambia cada 30 s).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _username = TextEditingController(text: 'admin');
  final _code = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _code.dispose();
    super.dispose();
  }

  bool get _ready =>
      _username.text.trim().isNotEmpty && _code.text.trim().length == 6;

  Future<void> _login() async {
    if (!_ready || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(sessionProvider.notifier)
          .login(_username.text.trim(), _code.text.trim());
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = ApiError.from(error).message;
          _code.clear();
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

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
                    key: const Key('login-username'),
                    controller: _username,
                    enabled: !_busy,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                    onChanged: (_) => setState(() {}),
                  ),
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
                      labelText: 'Código de la app autenticadora',
                      helperText: '6 dígitos; cambia cada 30 segundos.',
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _login(),
                  ),
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
                    onPressed: _busy || !_ready ? null : _login,
                    child: Text(_busy ? 'Ingresando…' : 'Ingresar'),
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
