import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starter_template_riverpod/core/widgets/dialogs/update_dialog.dart';

void main() {
  testWidgets('shows optional update dialog with dismissible actions', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));

    // Show dialog
    UpdateDialog.show(context: tester.element(find.byType(Scaffold)), isForceUpdate: false, updateMessage: 'Update available');
    await tester.pumpAndSettle();

    expect(find.text('Update Available'), findsOneWidget);
    expect(find.text('Later'), findsOneWidget);
    expect(find.text('Update Now'), findsOneWidget);
  });

  testWidgets('shows force update dialog without Later button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));

    UpdateDialog.show(context: tester.element(find.byType(Scaffold)), isForceUpdate: true, updateMessage: 'Please update');
    await tester.pumpAndSettle();

    expect(find.text('Update Required'), findsOneWidget);
    expect(find.text('Later'), findsNothing);
    expect(find.text('Update Now'), findsOneWidget);
  });
}
