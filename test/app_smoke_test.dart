import 'package:flutter_test/flutter_test.dart';
import 'package:nuance/app/nuance_app.dart';

void main() {
  testWidgets('Nuance shell renders primary tabs', (tester) async {
    await tester.pumpWidget(const NuanceApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('News'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
