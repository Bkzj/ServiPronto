import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/features/provider/provider_profile_flow.dart';
import 'package:servipronto/src/theme/app_theme.dart';

Widget subject() {
  return MaterialApp(theme: AppTheme.light, home: const ProviderProfileFlow());
}

Future<void> tapVisibleText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('arma un borrador de proveedor con la información inicial', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    expect(find.text('Tu servicio principal'), findsOneWidget);
    await tapVisibleText(tester, 'Plomería');
    await tapVisibleText(tester, 'Continuar');

    expect(find.text('¿Qué trabajos hacés?'), findsOneWidget);
    await tester.enterText(
      find.bySemanticsLabel('Tareas que ofrecés'),
      'Reparaciones y pérdidas de agua',
    );
    await tapVisibleText(tester, 'Continuar');

    expect(find.text('¿Cómo trabajás?'), findsOneWidget);
    await tapVisibleText(tester, 'A domicilio');
    await tapVisibleText(tester, 'Continuar');

    expect(find.text('Tu cobertura'), findsOneWidget);
    await tester.enterText(find.bySemanticsLabel('Zona de cobertura'), 'Tandil');
    await tapVisibleText(tester, 'Continuar');

    expect(find.text('Tu disponibilidad'), findsOneWidget);
    await tapVisibleText(tester, 'Lunes a viernes · 8 a 18 h');
    await tapVisibleText(tester, 'Continuar');

    expect(find.text('Tu experiencia'), findsOneWidget);
    await tester.enterText(find.bySemanticsLabel('Experiencia'), '8 años');
    await tapVisibleText(tester, 'Continuar');

    expect(find.text('Tu precio de referencia'), findsOneWidget);
    await tester.enterText(find.bySemanticsLabel('Precio por hora'), '18000');
    await tapVisibleText(tester, 'Revisar borrador');

    expect(find.text('Revisá tu borrador'), findsOneWidget);
    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('Reparaciones y pérdidas de agua'), findsOneWidget);
    expect(find.text('A domicilio'), findsOneWidget);
    expect(find.text('Tandil'), findsOneWidget);
    expect(find.text('Lunes a viernes · 8 a 18 h'), findsOneWidget);
    expect(find.text('8 años'), findsOneWidget);
    expect(find.textContaining('18.000'), findsOneWidget);
    expect(find.text('En revisión'), findsNothing);
  });
}
