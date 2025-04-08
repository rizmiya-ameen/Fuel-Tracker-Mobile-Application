import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracker_two/main.dart';

void main() {
  testWidgets('App loads and displays welcome message', (
    WidgetTester tester,
  ) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const TrackerApp());

    // Check if the welcome text is displayed
    expect(find.text('Let’s Build the App Step-by-Step! 🚀'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
