import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pullup/pullup.dart';

void main() {
  /// A simple widget test for PullUpRefresh
  /// Verifies that the widget renders its child correctly
  testWidgets('PullUpRefresh renders', (WidgetTester tester) async {
    // Build the PullUpRefresh widget inside a MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: PullUpRefresh(
          onRefresh: () async {}, // Provide a dummy async callback
          child: Column(
            children: const [
              Text('Test'), // Child widget to verify rendering
            ],
          ),
        ),
      ),
    );

    // Verify that the child Text widget is found exactly once
    expect(find.text('Test'), findsOneWidget);
  });
}
