import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sijunjung_go_fe_customer/main.dart';
import '../lib/app.dart';
void main() {
  testWidgets('App loads with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that splash screen shows loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
