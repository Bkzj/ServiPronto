import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/app.dart';
import 'package:servipronto/src/features/client_access/client_access_flow.dart';
import 'package:servipronto/src/features/client_access/client_profile_flow.dart';
import 'package:servipronto/src/features/client_shell/client_shell.dart';
import 'package:servipronto/src/theme/app_theme.dart';

Widget subject({DemoChallengeResult result = DemoChallengeResult.invalid}) {
  return MaterialApp(
    theme: AppTheme.light,
    home: ClientAccessFlow(demoChallengeResult: result),
  );
}

Widget profileSubject() {
  return MaterialApp(theme: AppTheme.light, home: const ClientProfileFlow());
}

void main() {
  testWidgets('pide correo, luego contraseña y teléfono en pasos cortos', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    expect(find.text('Tu correo'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'persona@ejemplo.com');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('Protegé tu cuenta'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Teléfono'), findsOneWidget);
  });

  testWidgets('explica un código inválido sin revelar secretos y permite pedir otro', (
    tester,
  ) async {
    await tester.pumpWidget(subject());

    await tester.enterText(find.byType(TextField), 'persona@ejemplo.com');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Contraseña'), 'secreto');
    await tester.enterText(find.bySemanticsLabel('Teléfono'), '2494000000');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('Confirmá tu teléfono'), findsOneWidget);
    expect(find.textContaining('••••'), findsOneWidget);
    expect(find.text('Confirmar código'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Código temporal'), '123456');
    await tester.tap(find.text('Confirmar código'));
    await tester.pumpAndSettle();

    expect(find.text('Ese código no es válido. Probá de nuevo.'), findsOneWidget);
    expect(find.text('Pedir otro código'), findsOneWidget);
    expect(find.text('123456'), findsNothing);
    expect(find.text('secreto'), findsNothing);
  });

  testWidgets('permite recuperarse de un código vencido', (tester) async {
    await tester.pumpWidget(subject(result: DemoChallengeResult.expired));

    await tester.enterText(find.byType(TextField), 'persona@ejemplo.com');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Contraseña'), 'secreto');
    await tester.enterText(find.bySemanticsLabel('Teléfono'), '2494000000');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Código temporal'), '654321');
    await tester.tap(find.text('Confirmar código'));
    await tester.pumpAndSettle();

    expect(find.text('Ese código venció. Pedí uno nuevo.'), findsOneWidget);
    expect(find.text('Pedir otro código'), findsOneWidget);
  });

  testWidgets('lleva al Inicio después de confirmar el acceso', (tester) async {
    await tester.pumpWidget(const ServiProntoApp());

    expect(find.text('Tu correo'), findsOneWidget);

    await tester.enterText(
      find.bySemanticsLabel('Correo electrónico'),
      'persona@ejemplo.com',
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Contraseña'), 'secreto');
    await tester.enterText(find.bySemanticsLabel('Teléfono'), '2494000000');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Código temporal'), '123456');
    await tester.tap(find.text('Confirmar código'));
    await tester.pumpAndSettle();

    expect(find.byType(ClientShell), findsOneWidget);
    expect(find.bySemanticsLabel('Ir a Inicio'), findsOneWidget);
  });

  testWidgets('pide un único dato del perfil y presenta el avance guardado', (
    tester,
  ) async {
    await tester.pumpWidget(profileSubject());

    expect(find.text('Tu nombre'), findsOneWidget);
    expect(find.bySemanticsLabel('Nombre'), findsOneWidget);
    expect(find.text('Nombre · falta apellido'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Nombre'), 'Ana');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('Tu apellido'), findsOneWidget);
    expect(find.text('Avance guardado'), findsOneWidget);
    expect(find.text('Apellido · falta fecha de nacimiento'), findsOneWidget);

    await tester.tap(find.text('Guardar y seguir después'));
    await tester.pumpAndSettle();

    expect(find.text('Seguimos cuando quieras'), findsOneWidget);
    expect(find.text('Retomar perfil'), findsOneWidget);
  });

  testWidgets('permite revisar y editar un dato puntual antes de confirmar', (
    tester,
  ) async {
    await tester.pumpWidget(profileSubject());

    await tester.enterText(find.bySemanticsLabel('Nombre'), 'Ana');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Apellido'), 'Pérez');
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.bySemanticsLabel('Fecha de nacimiento'),
      '12/10/1958',
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Dirección'), 'Sarmiento 123');
    await tester.tap(find.text('Revisar datos'));
    await tester.pumpAndSettle();

    expect(find.text('Revisá tu perfil'), findsOneWidget);
    expect(find.text('Editar nombre'), findsOneWidget);

    await tester.tap(find.text('Editar nombre'));
    await tester.pumpAndSettle();

    expect(find.text('Tu nombre'), findsOneWidget);
    expect(find.bySemanticsLabel('Nombre'), findsOneWidget);
  });
}
