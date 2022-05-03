import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_full_calendar/app/app.dart';

void main() {
  testWidgets('todo', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // expect(find.text('todo'), findsOneWidget);
  });
}
