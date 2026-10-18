import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/api_exception.dart';
import '../../../core/router/routes.dart';
import '../../profile/application/current_user.dart';
import '../../profile/domain/app_user.dart';
import '../domain/mode_denial.dart';

/// Interruptor deslizable empleador / trabajador (R1.5). Se toca o se desliza.
/// Si la API no permite el cambio, muestra el motivo y la acción siguiente.
class ModeSwitch extends ConsumerStatefulWidget {
  const ModeSwitch({super.key, required this.mode});

  final ActiveMode mode;

  @override
  ConsumerState<ModeSwitch> createState() => _ModeSwitchState();
}

class _ModeSwitchState extends ConsumerState<ModeSwitch> {
  bool _busy = false;

  Future<void> _select(ActiveMode target) async {
    if (_busy || target == widget.mode) return;
    setState(() => _busy = true);
    ModeDeniedException? denied;
    try {
      await ref.read(currentUserProvider.notifier).switchMode(target);
    } on ModeDeniedException catch (denial) {
      denied = denial;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiException.from(e).message)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    // El motivo se muestra con el interruptor ya quieto en el modo actual.
    if (denied != null && mounted) await showModeDeniedSheet(context, denied);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isWorker = widget.mode == ActiveMode.worker;
    return Semantics(
      label: 'Modo de la cuenta: ${widget.mode.label}',
      toggled: isWorker,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          final velocity = details.primaryVelocity ?? 0;
          if (velocity > 0) _select(ActiveMode.worker);
          if (velocity < 0) _select(ActiveMode.employer);
        },
        child: Container(
          key: const Key('mode-switch'),
          height: 52,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: isWorker
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  for (final mode in ActiveMode.values)
                    Expanded(
                      child: InkWell(
                        key: Key('mode-${mode.apiValue}'),
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => _select(mode),
                        child: Center(
                          child: _busy && mode != widget.mode
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  mode.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: mode == widget.mode
                                        ? scheme.onPrimary
                                        : scheme.onSurface,
                                  ),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ruta a la que lleva la acción siguiente.
String routeForAction(NextAction action) => switch (action) {
  NextAction.completeVerification ||
  NextAction.resubmitVerification => Routes.workerOnboarding,
  NextAction.payCommission => Routes.pay,
  NextAction.completeProfile => Routes.profile,
  _ => Routes.workerStatus,
};

Future<void> showModeDeniedSheet(
  BuildContext context,
  ModeDeniedException denial,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Todavía no puedes trabajar',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(denial.message, key: const Key('mode-denied-message')),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.of(sheetContext).pop();
                context.push(routeForAction(denial.nextAction));
              },
              child: Text(denial.actionLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: const Text('Seguir como empleador'),
            ),
          ],
        ),
      ),
    ),
  );
}
