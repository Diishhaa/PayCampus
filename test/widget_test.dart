// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:pay_campus/main.dart';

void main() {
  testWidgets('PayCampus App Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PayCampusApp());

    // Verify that the splash/role selection elements render.
    expect(find.text('PayCampus'), findsOneWidget);
    expect(find.text('Smart School Fee Management'), findsOneWidget);
    expect(find.text('Parent Portal'), findsOneWidget);
    expect(find.text('School Admin Dashboard'), findsOneWidget);
  });
}
