import 'package:flutter_test/flutter_test.dart';

import 'package:orchid_app/main.dart';

void main() {
  testWidgets('app starts on the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OrchidApp());
    await tester.pump();

    expect(find.text('Orchid'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
