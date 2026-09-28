import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/health_client.dart';
import '../../theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(
        index: currentIndex,
        children: [
          _HomeContent(ref: ref),
          const _PlaceholderPage(
            icon: Icons.search_rounded,
            title: 'Explorar servicios',
            message: 'Acá vas a encontrar profesionales y categorías.',
          ),
          const _PlaceholderPage(
            icon: Icons.auto_awesome_rounded,
            title: 'Hola, soy Jorge',
            message: 'Te voy a ayudar a entender qué necesitás, paso a paso.',
            highlighted: true,
          ),
          const _PlaceholderPage(
            icon: Icons.receipt_long_rounded,
            title: 'Tu actividad',
            message: 'Solicitudes, mensajes y servicios van a vivir acá.',
          ),
          const _PlaceholderPage(
            icon: Icons.person_rounded,
            title: 'Tu perfil',
            message: 'Datos, domicilios y preferencias, siempre accesibles.',
          ),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (value) => setState(() => currentIndex = value),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Inicio'),
        NavigationDestination(
          icon: Icon(Icons.search_rounded),
          label: 'Explorar',
        ),
        NavigationDestination(
          icon: _JorgeNavigationIcon(),
          selectedIcon: _JorgeNavigationIcon(selected: true),
          label: 'Jorge',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'Actividad',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_rounded),
          label: 'Perfil',
        ),
      ],
    ),
  );
}

class _JorgeNavigationIcon extends StatelessWidget {
  const _JorgeNavigationIcon({this.selected = false});
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      color: selected
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.secondaryContainer,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    child: Text(
      'J',
      style: TextStyle(
        color: selected
            ? Colors.white
            : Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final health = ref.watch(healthProvider);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: AppTheme.orange,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: const Text(
                      'SP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ServiPronto',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                          ),
                        ),
                        Text('Servicios para tu hogar, más simples.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: health.when(
                    loading: () => const _Status(
                      icon: Icons.sync,
                      title: 'Comprobando…',
                      message:
                          'Estamos verificando la conexión con ServiPronto.',
                    ),
                    error: (error, stack) => _Status(
                      icon: Icons.cloud_off_rounded,
                      title: 'Sin conexión',
                      message:
                          'La API no respondió. Revisá el entorno y volvé a intentar.',
                      action: FilledButton.icon(
                        onPressed: () => ref.invalidate(healthProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ),
                    data: (status) => const _Status(
                      icon: Icons.check_circle_rounded,
                      title: 'Todo conectado',
                      message:
                          'La aplicación, la API y PostgreSQL están comunicados.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({
    required this.icon,
    required this.title,
    required this.message,
    this.highlighted = false,
  });
  final IconData icon;
  final String title;
  final String message;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 54,
            color: highlighted
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _Status extends StatelessWidget {
  const _Status({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 36, color: Theme.of(context).colorScheme.secondary),
      const SizedBox(height: 16),
      Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 6),
      Text(message),
      if (action != null) ...[const SizedBox(height: 18), action!],
    ],
  );
}
