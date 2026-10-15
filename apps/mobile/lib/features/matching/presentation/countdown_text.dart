import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

/// Cuenta regresiva hasta el fin del plazo del anillo (R4.3).
class CountdownText extends StatefulWidget {
  const CountdownText({super.key, required this.until});

  final DateTime until;

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  Timer? _timer;

  // `clock` (y no DateTime.now) para que los tests avancen el tiempo con pump().
  DateTime _now() => clock.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (!widget.until.isAfter(_now())) _timer?.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.until.difference(_now());
    final theme = Theme.of(context);
    if (left.inSeconds <= 0) {
      return Text(
        'Responde pronto: el cliente ya puede ver otras ofertas.',
        key: const Key('countdown'),
        style: theme.textTheme.bodySmall,
      );
    }
    final m = left.inMinutes;
    final s = (left.inSeconds % 60).toString().padLeft(2, '0');
    return Row(
      key: const Key('countdown'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text('Responde en $m:$s', style: theme.textTheme.labelLarge),
      ],
    );
  }
}
