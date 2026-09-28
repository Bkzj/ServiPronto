import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/features/jorge/jorge_chat_tab.dart';

Widget chatSubject({bool responseAvailable = true}) => MaterialApp(
  home: Scaffold(body: JorgeChatTab(responseAvailable: responseAvailable)),
);

void main() {
  testWidgets(
    'convierte un mensaje del cliente en una orientación breve local',
    (tester) async {
      await tester.pumpWidget(chatSubject());

      await tester.enterText(
        find.bySemanticsLabel('Contale a Jorge qué pasó'),
        'Se me cortó la luz',
      );
      await tester.tap(find.byTooltip('Enviar mensaje a Jorge'));
      await tester.pumpAndSettle();

      expect(find.text('Se me cortó la luz'), findsOneWidget);
      expect(
        find.text('Entiendo. Contame si es en toda la casa o solo en un ambiente.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('permite sumar un adjunto visual de muestra', (tester) async {
    await tester.pumpWidget(chatSubject());

    await tester.tap(find.byTooltip('Adjuntar foto de muestra'));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Foto de muestra adjunta'), findsOneWidget);
    expect(find.text('Foto de muestra'), findsOneWidget);
  });

  testWidgets('explica con honestidad cuando no puede responder', (tester) async {
    await tester.pumpWidget(chatSubject(responseAvailable: false));

    await tester.enterText(
      find.bySemanticsLabel('Contale a Jorge qué pasó'),
      'Tengo una pérdida de agua',
    );
    await tester.tap(find.byTooltip('Enviar mensaje a Jorge'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Ahora no puedo responder desde acá.'),
      findsOneWidget,
    );
    expect(find.textContaining('No envié ninguna solicitud.'), findsOneWidget);
  });

  testWidgets(
    'ofrece una recomendación orientativa y permite explorar sin crear solicitud',
    (tester) async {
      var openedExplore = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JorgeChatTab(
              onExploreCategories: () => openedExplore = true,
            ),
          ),
        ),
      );

      await tester.enterText(
        find.bySemanticsLabel('Contale a Jorge qué pasó'),
        'Se me cortó la luz',
      );
      await tester.tap(find.byTooltip('Enviar mensaje a Jorge'));
      await tester.pumpAndSettle();

      expect(find.text('Podría ser electricidad'), findsOneWidget);
      expect(
        find.text('Es una orientación. No confirma disponibilidad ni crea una solicitud.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Ver electricidad'));

      expect(openedExplore, isTrue);
    },
  );
}
