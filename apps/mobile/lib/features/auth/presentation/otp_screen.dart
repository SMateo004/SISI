import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/http/api_exception.dart';
import '../data/auth_repository.dart';

/// Pantalla del código: temporizador de reenvío y envío automático al completar 6 dígitos.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.phoneDigits,
    this.resendInSec = 60,
  });

  /// Los 8 dígitos, sin +591.
  final String phoneDigits;
  final int resendInSec;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _code = TextEditingController();
  Timer? _timer;
  late int _secondsLeft;
  bool _busy = false;
  String? _error;
  String? _info;

  String get _phone => '+591${widget.phoneDigits}';

  @override
  void initState() {
    super.initState();
    _startCountdown(widget.resendInSec);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    _secondsLeft = seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _secondsLeft = _secondsLeft > 0 ? _secondsLeft - 1 : 0);
      if (_secondsLeft == 0) timer.cancel();
    });
  }

  Future<void> _verify() async {
    if (_code.text.length != 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .verifyOtp(_phone, _code.text);
      await ref.read(sessionProvider.notifier).signIn(result.tokens);
      // El router redirige al inicio al cambiar la sesión.
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = ApiException.from(e).message;
        _code.clear();
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    try {
      final sent = await ref.read(authRepositoryProvider).requestOtp(_phone);
      if (!mounted) return;
      setState(() => _info = 'Te enviamos un código nuevo.');
      _startCountdown(sent.resendInSec);
    } catch (e) {
      if (mounted) setState(() => _error = ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minutes = _secondsLeft ~/ 60;
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: const Text('Código de verificación')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Escribe el código de 6 dígitos que enviamos al +591 ${widget.phoneDigits}.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    key: const Key('otp-field'),
                    controller: _code,
                    autofocus: true,
                    enabled: !_busy,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      letterSpacing: 12,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '······',
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (value.length == 6) _verify();
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                  if (_info != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _info!,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _verify,
                    child: _busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ingresar'),
                  ),
                  const SizedBox(height: 16),
                  if (_secondsLeft > 0)
                    Text(
                      'Puedes pedir otro código en $minutes:$seconds',
                      key: const Key('resend-countdown'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    )
                  else
                    TextButton(
                      onPressed: _busy ? null : _resend,
                      child: const Text('Reenviar código'),
                    ),
                  TextButton(
                    onPressed: () => context.pop(),
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
