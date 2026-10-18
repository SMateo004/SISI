import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../data/auth_repository.dart';

/// Celular boliviano: 8 dígitos que empiezan con 6 o 7. La API valida de nuevo.
final _bolivianMobile = RegExp(r'^[67]\d{7}$');

String? validateBolivianMobile(String? value) {
  final digits = value?.trim() ?? '';
  if (digits.isEmpty) return 'Ingresa tu número de celular.';
  if (!_bolivianMobile.hasMatch(digits)) {
    return 'Ingresa un celular de 8 dígitos que empiece con 6 o 7.';
  }
  return null;
}

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final digits = _phone.text.trim();
    try {
      final sent = await ref
          .read(authRepositoryProvider)
          .requestOtp('+591$digits');
      if (!mounted) return;
      context.push(Routes.otp(digits, sent.resendInSec));
    } catch (e) {
      final error = ApiException.from(e);
      // Piloto cerrado y el número no está invitado: "Pronto en tu zona" (ADR-0052).
      if (error.code == 'PILOT_NOT_ALLOWED' && mounted) {
        final city = error.extra['cityName'] as String? ?? 'tu ciudad';
        context.push(Routes.comingSoonFor(digits, city));
        return;
      }
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'SISI',
                      style: theme.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Servicios inmediatos cerca de ti',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Ingresa tu número',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Te enviaremos un código por SMS para entrar.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('phone-field'),
                      controller: _phone,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [
                        AutofillHints.telephoneNumberNational,
                      ],
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Celular',
                        prefixText: '+591 ',
                        hintText: '70012345',
                        border: OutlineInputBorder(),
                      ),
                      validator: validateBolivianMobile,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _sending ? null : _submit,
                      child: _sending
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Recibir código'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
