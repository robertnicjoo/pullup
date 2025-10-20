import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pullup/pullup.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PullUpRefresh scroll triggers refresh', (
    WidgetTester tester,
  ) async {
    bool refreshed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PullUpRefresh(
          onRefresh: () async {
            refreshed = true;
          },
          child: Column(
            children: List.generate(30, (index) => Text('Item $index')),
          ),
        ),
      ),
    );

    final scrollable = find.byType(SingleChildScrollView);

    // Scroll up to bottom
    await tester.drag(scrollable, const Offset(0, -500));
    await tester.pumpAndSettle();

    // Check if refresh callback was triggered
    expect(refreshed, true);
  });
}
