import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/features/client_shell/client_shell.dart';
import 'package:servipronto/src/features/service_request/service_request_flow.dart';
import 'package:servipronto/src/theme/app_theme.dart';

Widget subject() {
  return MaterialApp(
    theme: AppTheme.light,
    home: const ServiceRequestFlow(categoryName: 'Plomería'),
  );
}

void main() {
  testWidgets(
    'conserva la categoría y deja revisar una solicitud sin enviarla ni contratar',
    (tester) async {
      await tester.pumpWidget(subject());

      expect(find.text('Solicitud de Plomería'), findsOneWidget);
      expect(find.bySemanticsLabel('Contanos qué necesitás'), findsWidgets);

      await tester.enterText(
        find.byType(TextField),
        'Pierde agua debajo de la pileta.',
      );
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.text('¿Cuándo lo necesitás?'), findsOneWidget);
      await tester.tap(find.text('Urgente'));
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.text('¿Cómo querés resolverlo?'), findsOneWidget);
      await tester.tap(find.text('A domicilio'));
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.bySemanticsLabel('Zona o dirección aproximada'),
        'Centro, Tandil',
      );
      await tester.tap(find.text('Revisar solicitud'));
      await tester.pumpAndSettle();

      expect(find.text('Revisá tu solicitud'), findsOneWidget);
      expect(find.text('Urgente · Lo antes posible'), findsOneWidget);
      expect(find.text('A domicilio · Centro, Tandil'), findsOneWidget);
      expect(
        find.text('Todavía no se envía ni se contrata nada.'),
        findsOneWidget,
      );
      expect(find.text('Enviar solicitud'), findsNothing);
    },
  );

  testWidgets(
    'abre una solicitud desde Explorar y permite sumar un receptor familiar',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.light, home: const ClientShell()),
      );

      await tester.tap(find.bySemanticsLabel('Ir a Explorar'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Categoría Plomería'));
      await tester.pumpAndSettle();

      expect(find.text('Solicitud de Plomería'), findsOneWidget);

      await tester.enterText(
        find.byType(TextField),
        'Pierde agua en la cocina.',
      );
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Urgente'));
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A domicilio'));
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Es para otra persona'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.bySemanticsLabel('Nombre de quien recibe el servicio'),
        'Rosa Pérez',
      );
      await tester.enterText(
        find.bySemanticsLabel('Contacto de quien recibe el servicio'),
        '249 400 0000',
      );
      await tester.enterText(
        find.bySemanticsLabel('Zona o dirección aproximada'),
        'Centro, Tandil',
      );
      await tester.tap(find.text('Revisar solicitud'));
      await tester.pumpAndSettle();

      expect(find.text('Recibe el servicio'), findsOneWidget);
      expect(find.text('Rosa Pérez · 249 400 0000'), findsOneWidget);
    },
  );
}
