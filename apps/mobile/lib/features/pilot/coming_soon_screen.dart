import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/http/api_client.dart';
import '../../core/http/api_exception.dart';
import '../../core/router/routes.dart';

/// "Pronto en tu zona" (ADR-0052): interés de quien todavía no entra al piloto.
class PilotRepository {
  PilotRepository(this._api);

  final Dio _api;

  Future<void> registerInterest({
    required String phone,
    required String role,
    String? zone,
  }) async {
    try {
      await _api.post<void>(
        '/pilot/interest',
        data: {
          'phone': phone,
          'role': role,
          if (zone != null && zone.isNotEmpty) 'zone': zone,
        },
      );
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}

final pilotRepositoryProvider = Provider<PilotRepository>(
  (ref) => PilotRepository(ref.watch(dioProvider)),
);

/// El piloto es solo con invitación: el número no está en la lista. Puede dejar su interés.
class ComingSoonScreen extends ConsumerStatefulWidget {
  const ComingSoonScreen({
    super.key,
    required this.phoneDigits,
    required this.cityName,
  });

  final String phoneDigits;
  final String cityName;

  @override
  ConsumerState<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends ConsumerState<ComingSoonScreen> {
  final _zone = TextEditingController();
  String _role = 'employer';
  bool _sending = false;
  bool _done = false;
  String? _error;

  @override
  void dispose() {
    _zone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref
          .read(pilotRepositoryProvider)
          .registerInterest(
            phone: widget.phoneDigits,
            role: _role,
            zone: _zone.text.trim(),
          );
      setState(() => _done = true);
    } catch (e) {
      setState(() => _error = ApiException.from(e).message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(Routes.login),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(
            Icons.rocket_launch_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'Pronto en tu zona',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Por ahora la app funciona solo con invitación en ${widget.cityName}. Déjanos tus datos y te avisamos cuando puedas entrar.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_done)
            Card(
              key: const Key('interest-done'),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text('¡Gracias! Te avisaremos por WhatsApp o SMS.'),
              ),
            )
          else ...[
            Text('Quiero…', style: theme.textTheme.titleMedium),
            RadioGroup<String>(
              groupValue: _role,
              onChanged: (v) => setState(() => _role = v ?? _role),
              child: const Column(
                children: [
                  RadioListTile(
                    value: 'employer',
                    title: Text('Contratar servicios'),
                  ),
                  RadioListTile(
                    value: 'worker',
                    title: Text('Trabajar ofreciendo servicios'),
                  ),
                  RadioListTile(value: 'ambos', title: Text('Las dos cosas')),
                ],
              ),
            ),
            TextField(
              key: const Key('interest-zone'),
              controller: _zone,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Barrio o zona (opcional)',
              ),
            ),
            if (_error != null)
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('interest-submit'),
              onPressed: _sending ? null : _submit,
              child: const Text('Avísenme'),
            ),
          ],
        ],
      ),
    );
  }
}
