import 'package:flutter/material.dart';

class SampleCategory {
  const SampleCategory(this.name, this.icon);

  final String name;
  final IconData icon;
}

const sampleCategories = [
  SampleCategory('Plomería', Icons.plumbing_rounded),
  SampleCategory('Electricidad', Icons.electrical_services_rounded),
  SampleCategory('Gas y calefacción', Icons.local_fire_department_rounded),
  SampleCategory('Limpieza', Icons.cleaning_services_rounded),
  SampleCategory('Jardinería', Icons.yard_rounded),
  SampleCategory('Mudanzas y fletes', Icons.local_shipping_rounded),
  SampleCategory('Clases particulares', Icons.menu_book_rounded),
  SampleCategory('Reparación técnica', Icons.build_rounded),
  SampleCategory('Aire acondicionado', Icons.ac_unit_rounded),
  SampleCategory('Cámaras y seguridad', Icons.videocam_rounded),
  SampleCategory('Mecánica a domicilio', Icons.car_repair_rounded),
];

class ExploreTab extends StatelessWidget {
  const ExploreTab({
    super.key,
    required this.query,
    required this.onQueryChanged,
    required this.onAskJorge,
    required this.onRequestCategory,
  });

  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onAskJorge;
  final ValueChanged<SampleCategory> onRequestCategory;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final categories = sampleCategories
        .where(
          (category) => category.name.toLowerCase().contains(normalizedQuery),
        )
        .toList();
    final theme = Theme.of(context);

    return Semantics(
      label: 'Explorar',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Explorar',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: onQueryChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Buscá una categoría',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 20),
            if (categories.isNotEmpty) ...[
              Text(
                'Todas las categorías',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) => _CategoryRow(
                    category: categories[index],
                    onTap: () => onRequestCategory(categories[index]),
                  ),
                ),
              ),
            ] else
              Expanded(
                child: Center(child: _NoResults(onAskJorge: onAskJorge)),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.onTap});

  final SampleCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      container: true,
      button: true,
      label: 'Categoría ${category.name}',
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: colors.surfaceContainerHighest,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.pets_rounded, color: colors.secondary),
                    const SizedBox(width: 10),
                    Icon(category.icon, color: colors.primary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded),
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

class _NoResults extends StatelessWidget {
  const _NoResults({required this.onAskJorge});

  final VoidCallback onAskJorge;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.pets_rounded, size: 48),
        const SizedBox(height: 12),
        Text(
          'No encontramos una categoría',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Contale a Jorge qué necesitás.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: onAskJorge,
          icon: const Icon(Icons.auto_awesome_rounded),
          label: const Text('Hablar con Jorge'),
        ),
      ],
    );
  }
}
