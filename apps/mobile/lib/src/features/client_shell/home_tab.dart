import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.onExplore,
    required this.onAskJorge,
    required this.onOpenNotifications,
  });

  final ValueChanged<String> onExplore;
  final VoidCallback onAskJorge;
  final VoidCallback onOpenNotifications;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Semantics(
      label: 'Inicio',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    'Inicio',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onOpenNotifications,
                tooltip: 'Ver avisos',
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '¿Qué necesitás resolver?',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            textInputAction: TextInputAction.search,
            onSubmitted: onExplore,
            decoration: const InputDecoration(
              hintText: 'Buscá un servicio',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: ShapeDecoration(
              color: colors.primaryContainer,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(34),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Novedades de ServiPronto',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Encontrá una categoría o pedile una mano a Jorge.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Semantics(
                  label: 'Pedir ayuda a Jorge',
                  button: true,
                  child: ExcludeSemantics(
                    child: TextButton.icon(
                      onPressed: onAskJorge,
                      icon: const Icon(Icons.auto_awesome_rounded),
                      label: const Text('Hablar con Jorge'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Servicios destacados',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          for (final service in const ['Plomería', 'Limpieza', 'Electricidad'])
            _FeaturedService(
              name: service,
              onTap: () => onExplore(service),
            ),
        ],
      ),
    );
  }
}

class _FeaturedService extends StatelessWidget {
  const _FeaturedService({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: colors.surfaceContainerHighest,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Semantics(
            button: true,
            label: 'Explorar $name',
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.pets_rounded, color: colors.secondary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded),
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
