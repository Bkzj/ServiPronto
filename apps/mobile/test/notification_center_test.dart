import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/features/notifications/notification_center.dart';

Widget subject() => const MaterialApp(home: NotificationCenter());

void main() {
  testWidgets('shows local transactional notices and marks one as read', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    expect(find.text('Avisos'), findsOneWidget);
    expect(find.text('Tu solicitud fue enviada'), findsOneWidget);
    expect(find.text('Sin leer'), findsNWidgets(2));

    await tester.tap(find.text('Tu solicitud fue enviada'));
    await tester.pumpAndSettle();

    expect(find.text('Tu solicitud fue enviada'), findsNothing);
    expect(find.text('Jorge te dejó una recomendación'), findsOneWidget);
  });

  testWidgets('shows an empty state after reading all local notices', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    for (final title in NotificationCenter.sampleTitles) {
      await tester.tap(find.text(title));
      await tester.pumpAndSettle();
    }

    expect(find.text('No tenés avisos nuevos'), findsOneWidget);
  });

  testWidgets('pauses local transactional notices from the notification center', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    await tester.tap(find.byTooltip('Configurar avisos'));
    await tester.pumpAndSettle();

    expect(find.text('Preferencias de avisos'), findsOneWidget);
    expect(find.text('Mensajes y servicios'), findsOneWidget);
    expect(find.text('Activos'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('Pausados'), findsOneWidget);
    expect(
      find.text('El centro de avisos sigue disponible dentro de ServiPronto.'),
      findsOneWidget,
    );
  });
}
