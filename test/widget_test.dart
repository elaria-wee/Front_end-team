// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:grad_pro1/main.dart';

void main() {
  testWidgets('Welcome screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EliEnglishAdventuresApp());

    // Verify that the welcome title is displayed.
    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('Eli\'s English Adventures!'), findsOneWidget);

    // Verify that the Sign In button is displayed.
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
