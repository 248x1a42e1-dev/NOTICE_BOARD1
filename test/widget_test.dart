import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_connect/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('KHIT Notice Board app launches', (WidgetTester tester) async {
    // Launch the application
    app.main();

    // Build the first frame
    await tester.pump();

    // Verify that the app displays a MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
