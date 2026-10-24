import 'package:flutter_test/flutter_test.dart';

import 'package:smart_student_companion/main.dart';

void main() {
  testWidgets('App renders welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartStudentCompanionApp());

    // Verify the app title is displayed.
    expect(find.text('Smart Student Companion'), findsWidgets);

    // Verify the welcome text is shown.
    expect(find.text('Welcome!'), findsOneWidget);

    // Verify the Dart concepts button is present.
    expect(find.text('Dart Programming Concepts'), findsOneWidget);
  });
}
