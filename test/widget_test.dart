// Smoke test for the Pulse Engage application.
//
// Verifies that the root [PulseApp] widget boots without throwing and renders
// a MaterialApp. PulseApp internally provides its own AppProvider, so no
// external scope is required here.
//
// The splash screen schedules a 2.4s Future.delayed for auto-navigation;
// the test runs all pending timers via pumpAndSettle before exiting so the
// framework doesn't flag pending-timer assertions.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulse_engage/main.dart';

void main() {
  testWidgets('PulseApp smoke test - boots and renders MaterialApp',
      (WidgetTester tester) async {
    // Build the root app and pump the first frame.
    await tester.pumpWidget(const PulseApp());

    // A single MaterialApp should be present at the root of the widget tree.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Advance well past the splash auto-navigate delay (2.4s) so any
    // Future.delayed timers fire and the binding has no pending timers.
    await tester.pump(const Duration(seconds: 3));
    // Settle remaining animations / routes (capped to avoid infinite loops
    // if animations are continuous).
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
