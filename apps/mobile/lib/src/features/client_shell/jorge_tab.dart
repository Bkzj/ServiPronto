import 'package:flutter/material.dart';

class JorgeTab extends StatelessWidget {
  const JorgeTab({
    super.key,
    required this.onExploreCategories,
    required this.onSearchService,
  });

  final VoidCallback onExploreCategories;
  final VoidCallback onSearchService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: 'Jorge, el asistente de ServiPronto',
                  image: true,
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.pets_rounded,
                      size: 72,
                      color: colors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  header: true,
                  child: Text(
                    'Hola, soy Jorge',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: ShapeDecoration(
                    color: colors.secondaryContainer,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Te ayudo a encontrar por dónde empezar.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colors.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onExploreCategories,
                    child: const Text('Explorar categorías'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: onSearchService,
                    child: const Text('Buscar un servicio'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
