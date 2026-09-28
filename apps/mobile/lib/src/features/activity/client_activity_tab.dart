import 'package:flutter/material.dart';

import 'schedule_preview.dart';

/// Actividad local de demostración. No representa contrataciones ni cambios
/// reales: prepara la jerarquía visual hasta conectar el módulo de trabajos.
class ClientActivityTab extends StatelessWidget {
  const ClientActivityTab({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      label: 'Actividad',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Semantics(
            header: true,
            child: Text(
              'Actividad',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Así se van a ordenar tus próximos pasos.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          Semantics(
            header: true,
            child: Text(
              'Agenda de muestra',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const SchedulePreview(),
          const SizedBox(height: 28),
          Semantics(
            header: true,
            child: Text(
              'Pendientes',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Material(
            color: colors.primaryContainer,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(34),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Semantics(
                label: 'Muestra: coordiná tu visita. Solicitud pendiente.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Muestra',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Muestra: coordiná tu visita',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Cuando envíes una solicitud, su próximo paso aparece acá.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Semantics(
            header: true,
            child: Text(
              'Historial',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Todavía no terminaste servicios',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text('Tus servicios finalizados van a quedar guardados acá.'),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onExplore,
            icon: const Icon(Icons.search_rounded),
            label: const Text('Explorar servicios'),
          ),
        ],
      ),
    );
  }
}
