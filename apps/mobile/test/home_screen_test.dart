import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servipronto/src/api/health_client.dart';
import 'package:servipronto/src/features/home/home_screen.dart';

class SuccessfulHealthClient extends HealthClient {
  @override
  Future<HealthStatus> readiness() async =>
      const HealthStatus(status: 'ok', service: 'database');
}

class FailingHealthClient extends HealthClient {
  @override
  Future<HealthStatus> readiness() async => throw Exception('offline');
}

Widget subject(HealthClient client) => ProviderScope(
  overrides: [healthClientProvider.overrideWithValue(client)],
  child: const MaterialApp(home: HomeScreen()),
);

void main() {
  testWidgets('shows verified connectivity', (tester) async {
    await tester.pumpWidget(subject(SuccessfulHealthClient()));
    await tester.pumpAndSettle();
    expect(find.text('Todo conectado'), findsOneWidget);
    expect(find.text('Jorge'), findsOneWidget);
  });
  testWidgets('shows a retry action when disconnected', (tester) async {
    await tester.pumpWidget(subject(FailingHealthClient()));
    await tester.pumpAndSettle();
    expect(find.text('Sin conexión'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('opens Jorge from the central navigation action', (tester) async {
    await tester.pumpWidget(subject(SuccessfulHealthClient()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jorge'));
    await tester.pumpAndSettle();
    expect(find.text('Hola, soy Jorge'), findsOneWidget);
  });
}
