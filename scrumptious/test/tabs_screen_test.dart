import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrumptious/screens/shared/tabs.dart';

void main() {
  testWidgets('TabsScreen UI Test', (WidgetTester tester) async { // add assertions
    await tester.pumpWidget(const MaterialApp(
      home: TabsScreen(),
    ));
  });
}
