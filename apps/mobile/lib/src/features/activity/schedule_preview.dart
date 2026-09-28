import 'package:flutter/material.dart';

/// Agenda local de demostración. Su contenido no representa una reserva,
/// disponibilidad ni una modificación real de un servicio.
class SchedulePreview extends StatelessWidget {
  const SchedulePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      button: true,
      label: 'Agenda de muestra. Martes, 16:30. Visita programada.',
      child: Material(
        color: colors.secondaryContainer,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(34),
        ),
        child: InkWell(
          onTap: () => _openDetail(context),
          customBorder: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(34),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 112),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.event_available_rounded, color: colors.secondary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Martes · 16:30',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onSecondaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Visita programada',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _openDetail(context),
                    child: const Text('Ver detalle'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(38),
      ),
      builder: (_) => const _SchedulePreviewDetail(),
    );
  }
}

class _SchedulePreviewDetail extends StatelessWidget {
  const _SchedulePreviewDetail();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Detalle de muestra',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visita programada · Martes, 16:30',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            const Text('No es una contratación real'),
            const SizedBox(height: 6),
            const Text('La visita no se puede modificar desde esta vista.'),
          ],
        ),
      ),
    );
  }
}
