import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/features/activity/client_activity_tab.dart';

void main() {
  testWidgets(
    'muestra un pendiente de ejemplo, historial vacío y permite explorar servicios',
    (tester) async {
      var explored = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClientActivityTab(onExplore: () => explored = true),
          ),
        ),
      );

      expect(find.text('Actividad'), findsOneWidget);
      expect(find.text('Pendientes'), findsOneWidget);
      expect(find.text('Muestra: coordiná tu visita'), findsOneWidget);
      expect(find.text('Historial'), findsOneWidget);
      expect(find.text('Todavía no terminaste servicios'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Explorar servicios'), 200);
      await tester.tap(find.text('Explorar servicios'));

      expect(explored, isTrue);
    },
  );

  testWidgets(
    'abre una agenda y detalle de muestra sin presentar acciones reales',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ClientActivityTab(onExplore: _doNothing)),
        ),
      );

      expect(find.text('Agenda de muestra'), findsOneWidget);
      expect(find.text('Martes · 16:30'), findsOneWidget);
      expect(find.text('Visita programada'), findsOneWidget);

      await tester.tap(find.text('Ver detalle'));
      await tester.pumpAndSettle();

      expect(find.text('Detalle de muestra'), findsOneWidget);
      expect(find.text('No es una contratación real'), findsOneWidget);
      expect(find.text('La visita no se puede modificar desde esta vista.'), findsOneWidget);
    },
  );
}

void _doNothing() {}
