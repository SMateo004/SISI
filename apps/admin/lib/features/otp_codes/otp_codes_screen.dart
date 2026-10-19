import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sisi_api/sisi_api.dart';

import '../../core/format/dates.dart';
import '../../core/http/api_client.dart';
import '../../core/http/api_error.dart';
import '../../core/widgets/common.dart';

/// Cada cuánto se vuelve a pedir la lista (sin evento de tiempo real nuevo, doc 02 §6).
const otpCodesRefresh = Duration(seconds: 3);

/// Códigos de ingreso enviados mientras no hay SMS (ADR-0056): solo staging o local. Con SMS
/// real o en producción la API devuelve `enabled: false` y la lista vacía.
class OtpCodesScreen extends ConsumerStatefulWidget {
  const OtpCodesScreen({super.key});

  @override
  ConsumerState<OtpCodesScreen> createState() => _OtpCodesScreenState();
}

class _OtpCodesScreenState extends ConsumerState<OtpCodesScreen> {
  Timer? _poll;
  Timer? _tick;
  OtpCodesDto? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
    _poll = Timer.periodic(otpCodesRefresh, (_) => _load());
    // Reloj de la cuenta regresiva entre pedidos.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final res = await ref
          .read(adminApiProvider)
          .adminOtpCodesControllerList();
      if (mounted) {
        setState(() {
          _data = res.data;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = ApiError.from(error).message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          'Códigos de ingreso',
          subtitle:
              'Mientras no hay SMS: el código que pide cada persona al entrar a la app. '
              'Se actualiza solo.',
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _error!,
              key: const Key('otp-codes-error'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        Expanded(
          child: switch (data) {
            null when _error == null => const Center(
              child: CircularProgressIndicator(),
            ),
            null => const SizedBox.shrink(),
            OtpCodesDto(enabled: false) => const Center(
              key: Key('otp-codes-disabled'),
              child: Text(
                'Los códigos se envían por SMS: no se muestran en el panel.',
              ),
            ),
            OtpCodesDto(items: final items) when items.isEmpty => const Center(
              key: Key('otp-codes-empty'),
              child: Text(
                'Nadie pidió un código en los últimos minutos. '
                'Cuando alguien ingrese a la app, aparece aquí.',
              ),
            ),
            OtpCodesDto(items: final items) => ListView.separated(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _CodeCard(entry: items[i]),
            ),
          },
        ),
      ],
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.entry});

  final OtpCodeDto entry;

  String get _who {
    if (!entry.accountExists) return 'Registro nuevo';
    final mode = switch (entry.activeMode) {
      OtpCodeDtoActiveModeEnum.worker => 'Trabajador',
      _ => 'Empleador',
    };
    final name = entry.name;
    return name == null || name.trim().isEmpty ? mode : '$name · $mode';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final left = entry.expiresAt.difference(DateTime.now());
    final used = entry.usedAt != null;
    final status = used
        ? 'Usado ${formatDateTime(entry.usedAt!)}'
        : left.isNegative
        ? 'Vencido'
        : 'Vence en ${left.inMinutes}:${(left.inSeconds % 60).toString().padLeft(2, '0')}';
    return Card(
      key: Key('otp-code-${entry.phone}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SelectableText(
              entry.code,
              key: Key('otp-code-value-${entry.phone}'),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
                letterSpacing: 4,
                color: used ? theme.disabledColor : null,
              ),
            ),
            IconButton(
              tooltip: 'Copiar código',
              icon: const Icon(Icons.copy),
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: entry.code)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.phone, style: theme.textTheme.titleMedium),
                  Text(_who),
                  Text(
                    'Pedido ${formatDateTime(entry.sentAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusChip(
              status,
              tone: used
                  ? ChipTone.neutral
                  : left.isNegative
                  ? ChipTone.bad
                  : ChipTone.ok,
            ),
          ],
        ),
      ),
    );
  }
}
