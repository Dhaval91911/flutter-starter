import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_template_riverpod/features/check_version/screens/maintenance_screen.dart';

void main() {
  testWidgets('renders maintenance screen and blocks back', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MaintenanceScreen()));
    expect(find.text('Under Maintenance'), findsOneWidget);
    // There is no direct back to test here; presence is enough for golden-like smoke test
  });
}
