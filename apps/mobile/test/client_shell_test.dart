import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/app.dart';
import 'package:servipronto/src/features/client_shell/client_shell.dart';
import 'package:servipronto/src/theme/app_theme.dart';

Widget subject() => const MaterialApp(home: ClientShell());

void main() {
  testWidgets('opens in Inicio and exposes the five client destinations', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    expect(find.text('Inicio'), findsWidgets);
    for (final destination in ClientDestination.values) {
      expect(
        find.bySemanticsLabel(destination.navigationLabel),
        findsOneWidget,
      );
    }

    final inicio = tester.getSemantics(
      find.bySemanticsLabel(ClientDestination.inicio.navigationLabel),
    );
    expect(inicio.flagsCollection.isSelected.toBoolOrNull(), isTrue);
  });

  testWidgets('changes the selected destination from the lower navigation', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    for (final destination in ClientDestination.values.skip(1)) {
      final target = find.bySemanticsLabel(destination.navigationLabel);
      await tester.tap(target);
      await tester.pumpAndSettle();

      expect(find.text(destination.title), findsWidgets);
      final semantics = tester.getSemantics(target);
      expect(semantics.flagsCollection.isSelected.toBoolOrNull(), isTrue);
    }
  });

  testWidgets('keeps Jorge as the centered accessible action', (tester) async {
    await tester.pumpWidget(subject());

    final jorge = find.bySemanticsLabel('Hablar con Jorge');
    expect(jorge, findsOneWidget);
    expect(tester.getSize(jorge).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(jorge).height, greaterThanOrEqualTo(48));

    await tester.tap(jorge);
    await tester.pumpAndSettle();

    expect(find.text('Jorge'), findsWidgets);
  });

  testWidgets(
    'Inicio offers a manual search, a ServiPronto prompt and highlights',
    (tester) async {
      await tester.pumpWidget(subject());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Novedades de ServiPronto'), findsOneWidget);
      expect(find.text('Servicios destacados'), findsOneWidget);
      expect(find.text('Plomería'), findsWidgets);
      expect(find.text('Limpieza'), findsWidgets);
    },
  );

  testWidgets(
    'Explorar filters sample categories and offers Jorge when empty',
    (tester) async {
      await tester.pumpWidget(subject());

      await tester.tap(find.bySemanticsLabel('Ir a Explorar'));
      await tester.pumpAndSettle();

      expect(find.text('Todas las categorías'), findsOneWidget);
      expect(find.text('Electricidad'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'cerrajería');
      await tester.pumpAndSettle();

      expect(find.text('No encontramos una categoría'), findsOneWidget);
      expect(find.text('Hablar con Jorge'), findsOneWidget);
    },
  );

  testWidgets('Jorge offers concise manual ways to continue', (tester) async {
    await tester.pumpWidget(subject());

    await tester.tap(find.bySemanticsLabel('Hablar con Jorge'));
    await tester.pumpAndSettle();

    expect(find.text('Hola, soy Jorge'), findsOneWidget);
    expect(find.text('Explorar categorías'), findsOneWidget);
    expect(find.text('Buscar un servicio'), findsOneWidget);

    await tester.tap(find.text('Explorar categorías'));
    await tester.pumpAndSettle();
    expect(find.text('Todas las categorías'), findsOneWidget);
  });

  testWidgets('Actividad shows a sample pending state and useful explore action', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    await tester.tap(find.bySemanticsLabel('Ir a Actividad'));
    await tester.pumpAndSettle();

    expect(find.text('Muestra: coordiná tu visita'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Todavía no terminaste servicios'),
      200,
    );
    expect(find.text('Todavía no terminaste servicios'), findsOneWidget);
    expect(find.text('Explorar servicios'), findsOneWidget);

    await tester.tap(find.text('Explorar servicios'));
    await tester.pumpAndSettle();
    expect(find.text('Todas las categorías'), findsOneWidget);
  });

  testWidgets('Perfil shows gradual progress and its next step', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    await tester.tap(find.bySemanticsLabel('Ir a Perfil'));
    await tester.pumpAndSettle();

    expect(find.text('Tu perfil'), findsOneWidget);
    expect(find.text('Empezá con tus datos básicos'), findsOneWidget);
    expect(find.text('Ver lo que falta'), findsOneWidget);

    await tester.tap(find.text('Ver lo que falta'));
    await tester.pumpAndSettle();
    expect(find.text('Próximo: confirmá tu teléfono'), findsOneWidget);
  });

  test('uses a lighter semantic primary color in dark mode', () {
    expect(
      AppTheme.dark.colorScheme.primary.computeLuminance(),
      greaterThan(AppTheme.light.colorScheme.primary.computeLuminance()),
    );
  });

  testWidgets('keeps manual text actions at a 48 dp tap target', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: TextButton(
            onPressed: () {},
            child: const Text('Acción manual'),
          ),
        ),
      ),
    );

    final target = find.byType(TextButton);
    expect(tester.getSize(target).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(target).height, greaterThanOrEqualTo(48));
  });

  testWidgets('renders the access screen with the system dark theme', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const ServiProntoApp());

    final context = tester.element(find.text('Tu correo'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(
      Theme.of(context).scaffoldBackgroundColor,
      AppTheme.dark.scaffoldBackgroundColor,
    );
  });
}
