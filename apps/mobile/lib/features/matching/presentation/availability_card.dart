import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../application/availability_controller.dart';

/// Se explica una vez por sesión antes de pedir el permiso del sistema.
class _RationaleShown extends Notifier<bool> {
  @override
  bool build() => false;

  void markShown() => state = true;
}

final _rationaleShownProvider = NotifierProvider<_RationaleShown, bool>(
  _RationaleShown.new,
);

/// Toggle "Disponible" (ADR-0024).
class AvailabilityCard extends ConsumerStatefulWidget {
  const AvailabilityCard({super.key});

  @override
  ConsumerState<AvailabilityCard> createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends ConsumerState<AvailabilityCard> {
  bool _busy = false;

  Future<bool> _explainLocation() async {
    if (ref.read(_rationaleShownProvider)) return true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.location_on_outlined),
        title: const Text('Tu ubicación'),
        content: const Text(
          'Para mostrarte solicitudes cerca de ti necesitamos tu ubicación. '
          'Solo la usamos mientras estás disponible y la app está abierta. '
          'Los clientes no ven dónde estás: solo la distancia aproximada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ahora no'),
          ),
          FilledButton(
            key: const Key('location-rationale-continue'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (ok == true) ref.read(_rationaleShownProvider.notifier).markShown();
    return ok == true;
  }

  Future<void> _toggle(bool on) async {
    if (on && !await _explainLocation()) return;
    if (!mounted) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(availabilityProvider.notifier).setAvailable(on);
    } on LocationAccessException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availability = ref.watch(availabilityProvider);
    final available = availability.value?.available ?? false;
    return Card(
      child: SwitchListTile(
        key: const Key('availability-switch'),
        value: available,
        onChanged: _busy || availability.isLoading ? null : _toggle,
        secondary: Icon(
          available ? Icons.location_on : Icons.location_off_outlined,
        ),
        title: Text(available ? 'Disponible' : 'No disponible'),
        subtitle: Text(
          available
              ? 'Recibes solicitudes cercanas mientras la app está abierta.'
              : 'Actívalo para recibir solicitudes cerca de ti.',
        ),
      ),
    );
  }
}
