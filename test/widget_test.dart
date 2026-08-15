import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathdoku/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MathdokuApp()),
    );
    await tester.pump();
    expect(find.text('Mathdoku'), findsWidgets);
  });
}
