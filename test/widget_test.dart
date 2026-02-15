import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:next/main.dart';
import 'package:next/features/viva_room/presentation/screens/home_screen.dart';

void main() {
  testWidgets('App renders Home Screen with correct title', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    // We need ProviderScope for Riverpod
    await tester.pumpWidget(const ProviderScope(child: EiNextApp()));

    // Verify that HomeScreen is displayed
    expect(find.byType(HomeScreen), findsOneWidget);

    // Verify title "Ei Next!" is present
    expect(find.text('Ei Next!'), findsOneWidget);

    // Verify "Teacher" and "Student" roles are present
    expect(find.text('Teacher'), findsOneWidget);
    expect(find.text('Student'), findsOneWidget);

    // Verify icons
    expect(find.byIcon(Icons.school), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}
