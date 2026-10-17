import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/links/url_opener.dart';
import '../../offers/data/offers_repository.dart';

/// Contacto de la contraparte (R5.4, R9.4): copiar, llamar o escribir por WhatsApp.
/// Se oculta 24 h después de terminado o cancelado.
class JobContactCard extends ConsumerWidget {
  const JobContactCard({super.key, required this.jobId});

  final String jobId;

  Future<void> _open(BuildContext context, WidgetRef ref, String? uri) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = uri != null && await ref.read(urlOpenerProvider)(Uri.parse(uri));
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo abrir. Copia el número.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(jobContactProvider(jobId));
    return switch (contact) {
      AsyncData(:final value) => Card(
        key: const Key('job-contact'),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(value.name ?? 'Sin nombre'),
              subtitle: Text(value.role == 'worker' ? 'Trabajador' : 'Cliente'),
            ),
            ListTile(
              key: const Key('contact-phone'),
              leading: const Icon(Icons.phone_outlined),
              title: Text(value.phone),
              trailing: IconButton(
                tooltip: 'Copiar número',
                icon: const Icon(Icons.copy),
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: value.phone));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Número copiado.')),
                    );
                  }
                },
              ),
            ),
            if (value.address != null)
              ListTile(
                leading: const Icon(Icons.place_outlined),
                title: Text(value.address!),
                subtitle: const Text('Dirección del trabajo'),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('contact-call'),
                      onPressed: () => _open(context, ref, value.telUri),
                      icon: const Icon(Icons.call),
                      label: const Text('Llamar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('contact-whatsapp'),
                      onPressed: () => _open(context, ref, value.whatsappUri),
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('WhatsApp'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      AsyncError(:final error) => Card(
        child: ListTile(
          leading: const Icon(Icons.phone_disabled_outlined),
          title: Text(
            ApiException.from(error).code == 'CONTACT_EXPIRED'
                ? 'El contacto ya no está disponible.'
                : ApiException.from(error).message,
          ),
        ),
      ),
      _ => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    };
  }
}
