import 'package:flutter_test/flutter_test.dart';
import 'package:meetmax/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App()); // 👈 use App, not MyApp

    // The rest of the boilerplate counter test can be removed
    // since your app doesn’t have the default counter anymore.
    // If you keep it, it will fail because there’s no '+' FAB or '0'/'1' text.
  });
}
