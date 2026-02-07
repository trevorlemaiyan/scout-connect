import 'package:flutter_test/flutter_test.dart';

import 'package:scout_connect/main.dart';

void main() {
  testWidgets('Scout Connect app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScoutConnectApp());

    // Verify that login screen appears
    expect(find.text('Scout Connect'), findsOneWidget);
    expect(find.text('Welcome to Scout Connect'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
