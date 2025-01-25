// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:quokka_mobile_app/main.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify text on first page
    expect(find.text('Start device pairing'), findsOneWidget);
  });
}
