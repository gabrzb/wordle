import 'package:flutter_test/flutter_test.dart';
import 'package:wordle/app/app.dart';

void main() {
  testWidgets('App renders Wordle screen', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Wordle'), findsOneWidget);
  });
}
