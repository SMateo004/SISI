import 'package:flutter/material.dart';

/// Lo que se califica: estrellas y comentario opcional.
typedef ReviewInput = ({int stars, String? comment});

/// Hoja para calificar a la contraparte (R6.2): 1 a 5 estrellas y comentario.
Future<ReviewInput?> showReviewSheet(
  BuildContext context, {
  required String counterpartName,
}) => showModalBottomSheet<ReviewInput>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _ReviewSheet(counterpartName: counterpartName),
);

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet({required this.counterpartName});

  final String counterpartName;

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  int _stars = 0;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '¿Cómo te fue con ${widget.counterpartName}?',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              'Tu calificación se mostrará cuando los dos califiquen o pasen 7 días.',
            ),
            const SizedBox(height: 12),
            StarsInput(
              value: _stars,
              onChanged: (v) => setState(() => _stars = v),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('review-comment'),
              controller: _comment,
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Comentario (opcional)',
                border: OutlineInputBorder(),
              ),
            ),
            FilledButton(
              key: const Key('review-send'),
              onPressed: _stars == 0
                  ? null
                  : () {
                      final comment = _comment.text.trim();
                      Navigator.of(context).pop((
                        stars: _stars,
                        comment: comment.isEmpty ? null : comment,
                      ));
                    },
              child: const Text('Enviar calificación'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cinco estrellas tocables.
class StarsInput extends StatelessWidget {
  const StarsInput({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 1; i <= 5; i++)
        IconButton(
          key: Key('star-$i'),
          tooltip: '$i ${i == 1 ? 'estrella' : 'estrellas'}',
          iconSize: 36,
          onPressed: () => onChanged(i),
          icon: Icon(
            i <= value ? Icons.star : Icons.star_border,
            color: Colors.amber.shade700,
          ),
        ),
    ],
  );
}

/// Estrellas de solo lectura.
class StarsView extends StatelessWidget {
  const StarsView({super.key, required this.stars, this.size = 18});

  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = 1; i <= 5; i++)
        Icon(
          i <= stars ? Icons.star : Icons.star_border,
          size: size,
          color: Colors.amber.shade700,
        ),
    ],
  );
}
