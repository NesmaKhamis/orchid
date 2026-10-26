import 'package:flutter_test/flutter_test.dart';

import 'package:orchid_app/main.dart';

void main() {
  testWidgets('app starts on the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OrchidApp());
    await tester.pump();

    expect(find.text('أهلاً بك من جديد'), findsOneWidget);
  });
}
