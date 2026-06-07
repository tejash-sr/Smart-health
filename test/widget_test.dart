// Smoke test for the Pulse Engage application.
//
// Verifies that the root [PulseApp] widget boots without throwing and renders
// a MaterialApp. PulseApp internally provides its own AppProvider, so no
// external scope is required here.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pulse_engage/main.dart';

void main() {
  testWidgets('PulseApp smoke test - boots into splash without errors',
      (WidgetTester tester) async {
    // Build the root app and pump a frame.
    await tester.pumpWidget(const PulseApp());

    // A single MaterialApp should be present at the root of the widget tree.
    expect(find.byType(MaterialApp), findsOneWidget);

    // Allow one extra frame for splash animations / async init to start.
    await tester.pump(const Duration(milliseconds: 100));
  });
}
