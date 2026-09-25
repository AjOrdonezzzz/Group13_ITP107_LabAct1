// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:finals_lab1_signup_page/main.dart';

void main() {
  testWidgets('register screen shows required form fields', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Register'), findsWidgets);
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('must contain 8 characters.'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });
}
